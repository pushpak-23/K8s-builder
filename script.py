#!/usr/bin/env python3
import json
import subprocess
from pathlib import Path
import re

# --- Get Terraform output ---
raw = subprocess.check_output(["terraform", "output", "-json"])
data = json.loads(raw)

nodes = data["nodes"]["value"]
lb_ip = data.get("rke2_lb_host", {}).get("value", "")

# --- Generate Ansible inventory ---
with open("ansible/inventory.ini", "w") as f:
    f.write("[masters]\n")
    for m in nodes["masters"]:
        host_ip = m["floating_ip"] if m.get("floating_ip") else m["private_ip"]
        f.write(f"{m['name']} ansible_host={host_ip} private_ip={m['private_ip']}\n")

    f.write("\n[workers]\n")
    for w in nodes["workers"]:
        host_ip = w["floating_ip"] if w.get("floating_ip") else w["private_ip"]
        f.write(f"{w['name']} ansible_host={host_ip} private_ip={w['private_ip']}\n")

    f.write("\n[all:vars]\n")
    f.write("ansible_user=kubeadmin\n")
    f.write("ansible_ssh_common_args='-o StrictHostKeyChecking=no'\n")

print("Inventory generated: inventory.ini")

# --- Update rke2_lb_host in all.yaml without touching anything else ---
all_yaml_file = Path("ansible/group_vars/all.yml")


with all_yaml_file.open("r") as f:
    lines = f.readlines()

pattern = re.compile(r'^(rke2_lb_host\s*:\s*).*$', re.IGNORECASE)
with all_yaml_file.open("w") as f:
    for line in lines:
        if pattern.match(line):
            prefix = pattern.match(line).group(1)
            line = f'{prefix}"{lb_ip}"\n'
        f.write(line)

print(f"RKE2 LB IP updated in {all_yaml_file}: {lb_ip}")
