from flask import Flask, jsonify, render_template
import requests

app = Flask(__name__)

@app.route('/')
def home():
    return render_template('index.html')

def get_imds_token():
    """Fetch IMDSv2 token from AWS metadata service."""
    url = "http://169.254.169.254/latest/api/token"
    headers = {"X-aws-ec2-metadata-token-ttl-seconds": "21600"}
    resp = requests.put(url, headers=headers, timeout=2)
    return resp.text

def get_metadata(path, token):
    """Fetch a metadata field using IMDSv2 token."""
    url = f"http://169.254.169.254/latest/meta-data/{path}"
    headers = {"X-aws-ec2-metadata-token": token}
    resp = requests.get(url, headers=headers, timeout=2)
    return resp.text

@app.route('/metadata')
def metadata():
    token = get_imds_token()

    # Gather metadata
    local_ipv4 = get_metadata("local-ipv4", token)
    az = get_metadata("placement/availability-zone", token)
    macid = get_metadata("network/interfaces/macs/", token).strip("/")
    vpc_id = get_metadata(f"network/interfaces/macs/{macid}/vpc-id", token)
    hostname = get_metadata("hostname", token)

    return jsonify({
        "Instance Name": hostname,
        "Instance Private IP Address": local_ipv4,
        "Availability Zone": az,
        "VPC ID": vpc_id
    })

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=80, debug=True)
