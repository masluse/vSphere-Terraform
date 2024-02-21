from flask import Flask, render_template, request, redirect, url_for
import os
import shutil
import re
from pyVim.connect import SmartConnect, Disconnect
from pyVmomi import vim

app = Flask(__name__)

@app.context_processor
def utility_processor():
    return dict(check_vm_exists=check_vm_exists)

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

def check_vm_exists(vm_name):
    vcenter_url = os.getenv('VCENTER_URL', 'default_vcenter_domain')
    username = os.getenv('VCENTER_USERNAME', 'default_username')
    password = os.getenv('VCENTER_PASSWORD', 'default_password')
    
    # Stellen Sie sicher, dass die URL mit https:// beginnt
    if not vcenter_url.startswith('https://'):
        vcenter_url = 'https://' + vcenter_url

    try:
        service_instance = SmartConnectNoSSL(host=vcenter_url, user=username, pwd=password)
        content = service_instance.RetrieveContent()

        for datacenter in content.rootFolder.childEntity:
            vmFolder = datacenter.vmFolder
            vmList = vmFolder.childEntity
            for vm in vmList:
                if vm.name == vm_name:
                    Disconnect(service_instance)
                    return True  # VM gefunden
        Disconnect(service_instance)
    except Exception as e:
        print(f"Es gab ein Problem bei der Verbindung oder der Suche: {e}")
    return False  # VM nicht gefunden oder Fehler aufgetreten

if __name__ == "__main__":
    app.run('0.0.0.0', 5000, app)