from flask import Flask, render_template, request, redirect, url_for, jsonify
import os
import shutil
import re
import ssl
from pyVim.connect import SmartConnect, Disconnect
from pyVmomi import vim, vmodl

app = Flask(__name__)

@app.context_processor
def utility_processor():
    return dict(check_vm_exists=check_vm_exists)

@app.route('/server_details/<server_name>')
def server_details(server_name):
    terraform_data = get_terraform_data(server_name)
    vm_exists = check_vm_exists(server_name)
    vcenter_data = get_vcenter_data(server_name) if vm_exists else {'IP': 'xxx', 'Netmask': 'xxx', 'Gateway': 'xxx', 'DNS': 'xxx'}
    
    return jsonify({'terraform': terraform_data, 'vcenter': vcenter_data})

# Funktion, um bestimmte Ordner auszuschließen
def get_folders():
    exclude_folders = ['dev', 'dev-linux', 'dev-windows']
    deployments_path = './test-terraform/deployments'
    folders = [d for d in os.listdir(deployments_path) if os.path.isdir(os.path.join(deployments_path, d)) and d not in exclude_folders]
    return folders

# Route für die Hauptseite
@app.route('/')
def index():
    folders = get_folders()
    return render_template('index.html', folders=folders)

# Route zur Seite für die VM-Erstellung
@app.route('/create_vm', methods=['GET', 'POST'])
def create_vm():
    if request.method == 'POST':
        # Daten aus dem Formular extrahieren
        vm_name = request.form['vm_name']
        vm_host = request.form['vm_host']
        vm_type = request.form['vm_type']  # 'Linux' oder 'Windows'
        vm_datastore = request.form['vm_datastore']
        vm_network  = request.form['vm_network']
        vm_template = request.form['vm_template']
        vm_memory = request.form['vm_memory']
        vm_num_cpus = request.form['vm_num_cpus']
        vm_ipv4_address = request.form['vm_ipv4_address']
        vm_ipv4_netmask = request.form['vm_ipv4_netmask']
        vm_ipv4_gateway = request.form['vm_ipv4_gateway']
        vm_ipv4_dns = request.form['vm_ipv4_dns']
        vm_folder = request.form['vm_folder']
        vm_annotation = request.form['vm_annotation']

        source_folder_name = 'dev-linux' if vm_type == 'Linux' else 'dev-windows'
        target_folder_name = request.form['vm_name']  # Verwende den VM-Namen als neuen Ordner
        source_path = os.path.join('./test-terraform/deployments', source_folder_name)
        target_path = os.path.join('./test-terraform/deployments', target_folder_name)

        if not os.path.exists(target_path):
            shutil.copytree(source_path, target_path)
            # Bearbeite die locals.tf im Zielordner
            locals_path = os.path.join(target_path, 'locals.tf')
            with open(locals_path, 'r') as file:
                content = file.read()
            # Ersetze Platzhalter mit Formulardaten
            content = content.replace('<vm_host>', vm_host).replace('<vm_datastore>', vm_datastore).replace('<vm_network>', vm_network).replace('<vm_template>', vm_template).replace('<vm_memory>', vm_memory).replace('<vm_num_cpus>', vm_num_cpus).replace('<vm_ipv4_address>', vm_ipv4_address).replace('<vm_ipv4_netmask>', vm_ipv4_netmask).replace('<vm_ipv4_gateway>', vm_ipv4_gateway).replace('<vm_ipv4_dns>', vm_ipv4_dns).replace('<vm_folder>', vm_folder).replace('<vm_annotation>', vm_annotation).replace('<vm_name>', vm_name)
            # Füge hier weitere Ersetzungen hinzu
            with open(locals_path, 'w') as file:
                file.write(content)
            return redirect(url_for('index'))
        else:
            return "Ein Ordner mit diesem Namen existiert bereits.", 400
    return render_template('create_vm.html')

# Diese Funktion holt alle Objekte eines bestimmten Typs (z.B. alle VMs)
def get_all_objs(content, vimtype):
    obj = {}
    container = content.viewManager.CreateContainerView(content.rootFolder, vimtype, True)
    for managed_object_ref in container.view:
        obj.update({managed_object_ref: managed_object_ref.name})
    return obj


def get_terraform_data(server_name):
    # Pfad zur Terraform-Konfigurationsdatei
    terraform_path = os.path.join('./test-terraform/deployments', server_name, 'locals.tf')
    data = {}
    try:
        with open(terraform_path, 'r') as file:
            terraform_content = file.read()
            # Extrahiere die benötigten Daten mit regulären Ausdrücken
            data_patterns = {
                '01._Name': r'vm_name\s*=\s*"([^"]+)"',
                '02._vSphere_Server': r'vsphere_server\s*=\s*"([^"]+)"',
                '03._Datacenter': r'datacenter\s*=\s*"([^"]+)"',
                '04._Host': r'vm_host\s*=\s*"([^"]+)"',
                '05._Folder': r'vm_folder\s*=\s*"([^"]+)"',
                '06._Template': r'vm_template\s*=\s*"([^"]+)"',
                '07._Annotation': r'vm_annotation\s*=\s*"([^"]+)"',
                '08._Type': r'vm_type\s*=\s*"([^"]+)"',
                '09._Datastore': r'vm_datastore\s*=\s*"([^"]+)"',
                '10._Network': r'vm_network\s*=\s*"([^"]+)"',
                '11._Memory': r'vm_memory\s*=\s*"([^"]+)"',
                '12._vCPU': r'vm_num_cpus\s*=\s*"([^"]+)"',
                '13._IPv4_Address': r'vm_ipv4_address\s*=\s*"([^"]+)"',
                '14._IPv4_Netmask': r'vm_ipv4_netmask\s*=\s*"([^"]+)"',
                '15._IPv4_Gateway': r'vm_ipv4_gateway\s*=\s*"([^"]+)"',
                '16._IPv4_Dns': r'vm_ipv4_dns\s*=\s*"([^"]+)"'
            }
            # Durchlaufe alle Muster und suche nach Übereinstimmungen im Terraform-Content
            for key, pattern in data_patterns.items():
                match = re.search(pattern, terraform_content)
                if match:
                    data[key] = match.group(1)
                else:
                    data[key] = 'Nicht definiert'
                    
            return data
    except FileNotFoundError:
        return "Terraform-Konfigurationsdatei nicht gefunden."



def get_vcenter_data(vm_name):
    vcenter_url = "vcenter.teleport.mregli.com"
    username = "administrator@vsphere.local"
    password = "HalloM3in*"
    port = 443

    try:
        # SSL-Zertifikatsprüfung deaktivieren
        context = ssl._create_unverified_context()

        # Verbindung zum vCenter Server herstellen
        service_instance = SmartConnect(host=vcenter_url, user=username, pwd=password, sslContext=context)

        content = service_instance.RetrieveContent()

        container = content.viewManager.CreateContainerView(content.rootFolder, [vim.VirtualMachine], True)
        vm = None
        for c in container.view:
            if c.name == vm_name:
                vm = c
                break
        container.Destroy()

        if vm:
            data = {
                '01._Name': vm.name,
                '02._vSphere_Server': vcenter_url,
                '03._Datacenter': vm.datacenter.name if vm.datacenter else 'xxx',
                '04._Host': vm.runtime.host.name if vm.runtime.host else 'xxx',
                '05._Folder': 'xxx',
                '06._Template': 'xxx',
                '07._Annotation': vm.config.annotation if vm.config.annotation else 'xxx',
                '08._Type': 'xxx',
                '09._Datastore': vm.datastore[0].name if vm.datastore else 'xxx',
                '10._Network': vm.network[0].name if vm.network else 'xxx',
                '11._Memory': str(int(vm.config.hardware.memoryMB / 1024)),
                '12._vCPU': str(vm.config.hardware.numCPU),
                '13._IPv4_Address': 'xxx',
                '14._IPv4_Netmask': 'xxx',
                '15._IPv4_Gateway': 'xxx',
                '16._IPv4_Dns': 'xxx'
            }
            print(vm.network[0])
        else:
            data = {'Fehler': 'VM nicht gefunden'}

        Disconnect(service_instance)
    except Exception as e:
        print(f"Fehler: {e}")
        data = {'Fehler': str(e)}

    return data


# Funktion zum Überprüfen, ob eine VM existiert, basierend auf der get_all_objs Funktion
def check_vm_exists(vm_name):
    vcenter_url = "vcenter.teleport.mregli.com"
    username = "administrator@vsphere.local"
    password = "HalloM3in*"
    
    try:
        # SSL-Zertifikatsprüfung deaktivieren
        context = ssl._create_unverified_context()

        # Verbindung zum vCenter Server herstellen
        service_instance = SmartConnect(host=vcenter_url, user=username, pwd=password, sslContext=context)

        # Inhalte vom vCenter Server abrufen
        content = service_instance.RetrieveContent()

        # Alle VMs holen
        all_vms = get_all_objs(content, [vim.VirtualMachine])

        # Überprüfen, ob die VM in der Liste der geholten VMs existiert
        for vm in all_vms.values():
            if vm == vm_name:
                Disconnect(service_instance)
                return True  # VM gefunden
        Disconnect(service_instance)
    except Exception as e:
        print(f"Es gab ein Problem bei der Verbindung oder der Suche: {e}")
    return False  # VM nicht gefunden oder Fehler aufgetreten

if __name__ == "__main__":
    app.run('0.0.0.0', 5000, app)