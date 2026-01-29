# 🚀 K8s-Builder: Automated Kubernetes Cluster Deployment on OpenStack

![GitHub Stars](https://img.shields.io/github/stars/yourusername/k8s-builder?style=flat-square)
![GitHub Forks](https://img.shields.io/github/forks/yourusername/k8s-builder?style=flat-square)
![GitHub Issues](https://img.shields.io/github/issues/yourusername/k8s-builder?style=flat-square)
![License](https://img.shields.io/github/license/yourusername/k8s-builder?style=flat-square)

**Deploy production-grade Kubernetes clusters on OpenStack with minimal effort!**

K8s-Builder is a **Terraform + Ansible** automation framework that provisions **RKE2-based Kubernetes clusters** on OpenStack with **OpenStack Cloud Controller Manager (CCM)** and **Cinder CSI Driver** integration. Perfect for developers, DevOps engineers, and cloud administrators who need a **repeatable, production-ready** Kubernetes deployment workflow.

---

## ✨ **Why K8s-Builder?**

✅ **Automated Infrastructure** – Provision OpenStack VMs with Terraform
✅ **Kubernetes-Ready Nodes** – Pre-configured for RKE2 with optimal storage
✅ **OpenStack Integration** – Native cloud provider support for load balancing, networking, and storage
✅ **Production-Grade** – Uses RKE2 (Rancher’s lightweight Kubernetes distribution)
✅ **Minimal Manual Work** – Fully automated from VM provisioning to cluster deployment
✅ **Extensible** – Easy to customize for different OpenStack environments

---

## 🛠️ **Tech Stack**

| Category           | Tools/Technologies                           |
| ------------------ | -------------------------------------------- |
| **Infrastructure** | Terraform, OpenStack (Nova, Cinder, Neutron) |
| **Configuration**  | HCL (Terraform), YAML (Ansible)              |
| **Kubernetes**     | RKE2 (Rancher Kubernetes Engine)             |
| **Cloud Provider** | OpenStack Cloud Controller Manager (CCM)     |
| **Storage**        | Cinder CSI Driver                            |
| **Scripting**      | Python (for inventory generation)            |

**System Requirements:**

- OpenStack environment with Nova, Cinder, and Neutron
- Terraform ≥ 1.0
- Python 3.8+
- Ansible ≥ 2.10

---

## 📦 **Installation**

### **Prerequisites**

1. **OpenStack Credentials** – Ensure you have:
   - `OS_AUTH_URL`, `OS_REGION`, `OS_INTERFACE`
   - Application credential ID & secret (`os_app_cred_id`, `os_app_cred_secret`)
   - External network ID (`external_network_id`)

2. **Terraform & Ansible** – Install:

   ```bash
   # Install Terraform (Linux/macOS)
   sudo apt-get install -y gnupg software-properties-common
   wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
   echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
   sudo apt update && sudo apt install terraform

   # Install Ansible
   sudo apt-get install -y ansible
   ```

3. **Python Dependencies** – Install `pyOpenSSL` for Terraform output parsing:
   ```bash
   pip install pyopenssl
   ```

---

### **Quick Start**

#### **1. Configure Terraform & Ansible**

Replace placeholders in:

- `ansible/group_vars/all.yml` (OpenStack & RKE2 settings)
- `cloud-init.yaml` (user credentials, SSH keys)

#### **2. Generate Ansible Inventory**

Run the Python script to create `ansible/inventory.ini`:

```bash

```

#### **2. Deploy the VM's**

```bash
# Initialize Terraform
terraform init

# Plan & apply infrastructure
terraform plan
terraform apply -auto-approve

# Wait for VMs to boot (~5-10 mins)
sleep 300

```

#### **3. Generate Ansible Inventory**

Run the Python script to create `ansible/inventory.ini`:

```bash
python3 script.py
```

#### **4. Deploy the Cluster**

```bash
# Run Ansible playbook
ansible-playbook -i ansible/inventory.ini ansible/site.yml
```

#### **5. Access Your Cluster**

After deployment (~15-20 mins), your cluster will be ready:

```bash
# Get kubeconfig
kubectl --kubeconfig /etc/rancher/rke2/rke2.yaml get nodes
```

---

### **Alternative: Docker Setup (For Local Testing)**

If you want to test without OpenStack:

```bash
# Build a Docker image with dependencies
docker build -t k8s-builder .
docker run -it --rm -v $(pwd):/workspace k8s-builder bash
```

---

## 🎯 **Usage Examples**

### **Basic Cluster Deployment**

1. **Terraform Provisioning** – Deploys 3 masters + 3 workers:

   ```hcl
   # Example Terraform snippet (simplified)
   resource "openstack_compute_instance_v2" "k8s_nodes" {
     name        = "auto-kube-${var.node_type}-${count.index}"
     image_name  = "Ubuntu 22.04"
     flavor_name = "m1.medium"
     count       = var.node_count
     key_pair    = "your-keypair"
     user_data   = filebase64("cloud-init.yaml")
   }
   ```

2. **Ansible Playbook Execution** – Deploys RKE2 with OpenStack CCM:
   ```yaml
   # ansible/site.yml (simplified)
   - hosts: masters[0]
     roles:
       - rke2-bootstrap
       - openstack-ccm
   ```

### **Customizing Storage**

Modify `ansible/group_vars/all.yml` to change:

```yaml
default_volume_type: "rbd-production" # or "ceph-rgw"
```

### **Scaling the Cluster**

Add more nodes by updating `script.py` and re-running:

```bash
python3 script.py  # Regenerates inventory.ini
ansible-playbook -i ansible/inventory.ini ansible/site.yml
```

---

## 📁 **Project Structure**

```
📦 k8s-builder/
├── .gitignore                # Ignore sensitive files & artifacts
├── cloud-init.yaml           # Cloud-init template for VMs
├── script.py                 # Generates Ansible inventory from Terraform
│
├── ansible/
│   ├── group_vars/           # Ansible variables (masters/workers)
│   ├── inventory.ini         # Dynamic inventory file
│   ├── roles/                # Ansible roles (common, rke2, openstack-ccm, etc.)
│   └── site.yml              # Main Ansible playbook
│
└── README.md                 # You are here!
```

---

## 🔧 **Configuration**

### **Environment Variables**

| Variable              | Purpose                             | Example Value                                                                            |
| --------------------- | ----------------------------------- | ---------------------------------------------------------------------------------------- |
| `OS_AUTH_URL`         | OpenStack auth URL                  | `https://vip.public.cloud:5000/v3`                                                       |
| `OS_REGION`           | OpenStack region                    | `RegionOne`                                                                              |
| `OS_INTERFACE`        | Network interface                   | `internal`                                                                               |
| `os_app_cred_id`      | OpenStack app credential ID         | `7c1d87309f654583bdab148f4f681dc0`                                                       |
| `os_app_cred_secret`  | OpenStack app credential secret     | `BLuNVi-3YSDXypc1YXr7jymmt7HwqP5vvMsa5hiwt2OhVbaGT7DM0w_spQovAJxmscnfHKRVRBEI8-xFTmfDSw` |
| `external_network_id` | OpenStack external network ID       | `765373d8-6982-40f4-9d58-b9fbc95f8d29`                                                   |
| `rke2_version`        | RKE2 version                        | `v1.35.0+rke2r1`                                                                         |
| `rke2_token`          | RKE2 cluster token (auto-generated) | `SUPER-SECRET-RKE2-TOKEN`                                                                |

### **Customization Options**

1. **Node Types** – Modify `script.py` to add more node types (e.g., GPU workers).
2. **Storage Backend** – Change `default_volume_type` in `ansible/group_vars/all.yml`.
3. **Networking** – Adjust `cloud-init.yaml` for custom networking policies.

---

## 🤝 **Contributing**

We welcome contributions! Here’s how you can help:

### **Development Setup**

1. Fork the repository.
2. Clone locally:
   ```bash
   git clone https://github.com/yourusername/k8s-builder.git
   cd k8s-builder
   ```
3. Install dependencies (see **Prerequisites**).
4. Run tests (if any) or start contributing!

### **Code Style Guidelines**

- **Terraform**: Follow [HashiCorp’s style guide](https://developer.hashicorp.com/terraform/styleguide).
- **Ansible**: Use YAML formatting and modular roles.
- **Python**: PEP 8 compliant.

### **Pull Request Process**

1. Create a feature branch:
   ```bash
   git checkout -b feature/your-feature
   ```
2. Commit changes with clear messages.
3. Push to your fork and open a PR.

---

## 📝 **License**

This project is licensed under the **MIT License** – see [LICENSE](LICENSE) for details.

---

## 👥 **Authors & Contributors**

👤 **Maintainer**: [Your Name](https://github.com/pushpak-23)
🤝 **Contributors**: [List of contributors](https://github.com/pushpak-23/k8s-builder/graphs/contributors)

---

## 🐛 **Issues & Support**

- **Report bugs** or request features via [GitHub Issues](https://github.com/pushpak-23/k8s-builder/issues).

### **FAQ**

| Question                           | Answer                                                     |
| ---------------------------------- | ---------------------------------------------------------- |
| **How long does deployment take?** | ~15-20 minutes (depends on OpenStack performance).         |
| **Can I use this for production?** | Yes! This is designed for production-grade clusters.       |
| **Does it support multi-cloud?**   | Currently OpenStack-only; PRs welcome for other providers! |

---

## 🗺️ **Roadmap**

| Feature                  | Status         | Description                                                           |
| ------------------------ | -------------- | --------------------------------------------------------------------- |
| **Multi-Cloud Support**  | 🚧 In Progress | Add support for AWS, GCP, and Azure.                                  |
| **Helm Charts**          | 🎨 Planned     | Pre-configured Helm values for common apps (e.g., Prometheus, NGINX). |
| **Terraform Modules**    | 🎨 Planned     | Convert to reusable Terraform modules.                                |
| **Kubernetes Dashboard** | 🎨 Planned     | Auto-deploy Kubernetes Dashboard with RBAC.                           |
| **Monitoring Stack**     | 🎨 Planned     | Integrate Prometheus + Grafana for observability.                     |

---

## 🚀 **Get Started Today!**

[![Star this repo](https://img.shields.io/badge/Star-this-repo-blue?style=for-the-badge&logo=github)](https://github.com/yourusername/k8s-builder/stargazers)
[![Fork this repo](https://img.shields.io/badge/Fork-this-repo-blue?style=for-the-badge&logo=github)](https://github.com/yourusername/k8s-builder/fork)

**Deploy your Kubernetes cluster in minutes!** 🚀

```bash
git clone https://github.com/yourusername/k8s-builder.git
cd k8s-builder
./deploy.sh  # (Add this script to automate the process!)
```

---

**Happy Deploying!** 🎉

```

```
