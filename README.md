
---

# OpenStack FT Terraform Module

This Terraform project simulates **Fault Tolerance (FT)** on OpenStack by provisioning a basic web setup with load balancing, anti-affinity, and auto-provisioned infrastructure.

---

## 📁 Directory Structure

```
openstack-ft-web/
├── environments/
│   └── dev/
│       ├── main.tf                 # Top-level config where all modules are declared
│       ├── variables.tf            # Variable definitions for dev environment
│       ├── terraform.tfvars        # Actual variable values for dev
│       ├── outputs.tf              # Consolidated outputs from modules
│       └── ankur-poc.pem           # SSH key used for provisioning (replace with your key)
│
│   └── prod/                       # For Production env
└── modules/
├── network/            # Creates network + subnet
├── router/             # Creates router and attaches subnet + sets external gw
├── security_group/     # Creates SSH (22) and HTTP (80) rules
├── instance/           # Launches 2 VMs with anti-affinity + floating IPs
├── loadbalancer/       # Sets up Octavia LB, pool, listener
└── provisioner/        # Provisions VMs via SSH using null\_resource

````

---

## 🚀 What It Does

- Creates a custom OpenStack network and subnet  
- Adds subnet to router and connects router to external gateway  
- Sets up security group with inbound rules for **SSH (22)** and **HTTP (80)**
- Defines anti-affinity policy to spread VMs across hosts
- Launches **2 VMs**, installs a simple webpage inside each
- Creates a **load balancer (Octavia)** with listener + pool pointing to the VMs
- Associates a **Floating IP** to the LB for external access

---

## 🛠️ Prerequisites

- Terraform ≥ 1.0
- OpenStack CLI credentials (`clouds.yaml` or ENV vars)
- A valid OpenStack project with required quotas
- SSH keypair to access instances

---

## ⚙️ Setup Instructions

1. **Clone the repo**
   ```bash
   git clone https://github.com/ankurgautam90/openstack-ft-demo.git
   cd openstack-ft-demo/environments/dev
````

2. **Replace SSH Key**

   * Copy your SSH private key to `ankur-poc.pem`
   * Or edit `main.tf` / `tfvars` to point to your own key file.

3. **Update Variables**

   * Edit `terraform.tfvars` to include your:

     * `auth_url`, `username`, `password`, `tenant_name`, `region`, etc.
     * Network/Subnet details if different

4. **Run Terraform**

   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

---

## 🧹 Cleanup

To delete all created resources:

```bash
terraform destroy
```

---

## 📝 Notes

* This setup demonstrates fault tolerance using anti-affinity + load balancing.
* You can test FT by manually shutting down one instance and confirming webpage is still reachable.
* Webpage is provisioned using `remote-exec` in `provisioner` module.

---

## 📬 Author

Ankur Kumar
[https://github.com/ankurgautam90](https://github.com/ankurgautam90)

---

