#!/usr/bin/env python3
import json
import subprocess

raw = subprocess.check_output(["terraform", "output", "-json"])
data = json.loads(raw)

nodes = data["nodes"]["value"]

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
