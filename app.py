from flask import Flask, jsonify, send_from_directory
import requests
import os

app = Flask(__name__)

@app.route('/')
def home():
    return send_from_directory('/var/www/html', 'index.html')

@app.route('/metadata')
def metadata():
    METADATA_URL = "http://metadata.google.internal/computeMetadata/v1"
    METADATA_FLAVOR_HEADER = {"Metadata-Flavor": "Google"}
    
    local_ipv4 = requests.get(f"{METADATA_URL}/instance/network-interfaces/0/ip", headers=METADATA_FLAVOR_HEADER).text
    zone = requests.get(f"{METADATA_URL}/instance/zone", headers=METADATA_FLAVOR_HEADER).text
    project_id = requests.get(f"{METADATA_URL}/project/project-id", headers=METADATA_FLAVOR_HEADER).text
    network_tags = requests.get(f"{METADATA_URL}/instance/tags", headers=METADATA_FLAVOR_HEADER).text
    hostname = requests.get(f"{METADATA_URL}/instance/hostname", headers=METADATA_FLAVOR_HEADER).text
    
    return jsonify({
        "Instance Name": hostname,
        "Instance Private IP Address": local_ipv4,
        "Zone": zone,
        "Project ID": project_id,
        "Network Tags": network_tags
    })

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
