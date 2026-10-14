# AWS Multi-VPC Transit Gateway Network

## Project Overview

This project demonstrates the design and deployment of a **multi-VPC AWS network using Terraform and AWS Transit Gateway**.

Three separate environments — **Production, Staging, and Test** — are deployed in independent VPCs and connected through a central **AWS Transit Gateway (TGW)**.

A **Bastion Host** in the Production VPC provides controlled access to private resources, while Transit Gateway routing enables private communication between the environments without exposing the private EC2 instances directly to the internet.

---

## Architecture

The environment consists of:

- Production VPC — `10.10.0.0/16`
- Staging VPC — `10.20.0.0/16`
- Test VPC — `10.30.0.0/16`
- AWS Transit Gateway
- Transit Gateway VPC attachments
- Public subnet for the Bastion Host
- Private subnets for environment servers
- Internet Gateway for Bastion access
- EC2 instances
- Route tables
- Security groups
- Terraform Infrastructure as Code

### Architecture Diagram

![Architecture Diagram](screenshots/architecture.png)

---

## Network Design

### Production Environment

```text
VPC CIDR:             10.10.0.0/16
Private Subnet:       10.10.1.0/24
Bastion Public Subnet: 10.10.2.0/24
```

The Production environment contains:

- Bastion Host in the public subnet
- Production EC2 instance in the private subnet
- Internet Gateway for Bastion internet connectivity
- Routes to Staging and Test through the Transit Gateway

### Staging Environment

```text
VPC CIDR:       10.20.0.0/16
Private Subnet: 10.20.1.0/24
```

The Staging private subnet routes traffic destined for Production and Test through the Transit Gateway.

### Test Environment

```text
VPC CIDR:       10.30.0.0/16
Private Subnet: 10.30.1.0/24
```

The Test private subnet routes traffic destined for Production and Staging through the Transit Gateway.

---

## Transit Gateway

AWS Transit Gateway acts as the central network hub connecting all three VPCs.

```text
                    AWS Transit Gateway
                           │
              ┌────────────┼────────────┐
              │            │            │
              ▼            ▼            ▼
         Production     Staging        Test
        10.10.0.0/16  10.20.0.0/16  10.30.0.0/16
```

Each VPC is connected to the Transit Gateway through a dedicated **Transit Gateway VPC attachment**.

### Transit Gateway Attachments

![Transit Gateway Attachments](screenshots/tgw-attachments.png)

---

## Routing

The VPC route tables direct traffic for remote environments through the Transit Gateway.

### Production

```text
10.10.0.0/16 → Local
10.20.0.0/16 → Transit Gateway
10.30.0.0/16 → Transit Gateway
```

### Staging

```text
10.20.0.0/16 → Local
10.10.0.0/16 → Transit Gateway
10.30.0.0/16 → Transit Gateway
```

### Test

```text
10.30.0.0/16 → Local
10.10.0.0/16 → Transit Gateway
10.20.0.0/16 → Transit Gateway
```

This enables private communication between the three environments using their internal IP addresses.

---

## Bastion Host

A single **Bastion Host** is deployed in the Production public subnet.

The access flow is:

```text
Administrator
      │
      │ SSH
      ▼
Bastion Host
Production Public Subnet
      │
      ├────────► Production Private EC2
      │
      └────────► Other VPCs through Transit Gateway
```

Private instances do not require direct public access for administration through this design.

---

## Connectivity Validation

Connectivity between the environments was tested after deployment.

### Production → Staging

The Bastion Host in Production successfully communicated with the private Staging EC2 instance through the Transit Gateway.

![Staging Connectivity](screenshots/staging-connectivity.png)

### Production → Test

The Bastion Host in Production successfully communicated with the private Test EC2 instance through the Transit Gateway.

![Test Connectivity](screenshots/test-connectivity.png)

Both tests completed successfully with:

```text
4 packets transmitted
4 received
0% packet loss
```

This validates private cross-VPC connectivity through AWS Transit Gateway.

---

## AWS Reachability Analyzer

AWS **VPC Reachability Analyzer** was also used to analyze network connectivity and troubleshoot the communication path between AWS resources.

The analysis validated the configured AWS network path and provided visibility into components such as:

- Network interfaces
- Subnets
- Route tables
- Security groups
- Network ACLs
- Source and destination resources

### Reachability Analysis

![Reachability Analyzer](screenshots/reachability-analyzer.png)

This demonstrates both infrastructure deployment and practical AWS network troubleshooting.

---

## Terraform Infrastructure

The complete environment is provisioned using **Terraform**.

Terraform manages:

- VPCs
- Subnets
- Internet Gateway
- Route tables
- Route table associations
- AWS Transit Gateway
- Transit Gateway VPC attachments
- Transit Gateway routing
- Security groups
- EC2 instances
- Bastion Host
- Infrastructure outputs

This allows the entire environment to be created and destroyed consistently using Infrastructure as Code.

---

## Project Structure

```text
transit-gateway-project/
│
├── provider.tf
├── network.tf
├── security.tf
├── servers.tf
├── variables.tf
├── outputs.tf
├── .gitignore
├── README.md
│
└── screenshots/
    ├── architecture.png
    ├── tgw-attachments.png
    ├── staging-connectivity.png
    ├── test-connectivity.png
    └── reachability-analyzer.png
```

---

## Deployment

### 1. Initialize Terraform

```bash
terraform init
```

### 2. Review the Infrastructure

```bash
terraform plan
```

### 3. Deploy the Infrastructure

```bash
terraform apply
```

Confirm the deployment when prompted.

---

## Validation

After deployment:

1. Connect to the Bastion Host using SSH.
2. Verify connectivity to the Staging private EC2 instance.
3. Verify connectivity to the Test private EC2 instance.
4. Review Transit Gateway attachments.
5. Use VPC Reachability Analyzer when troubleshooting network paths.

Example connectivity test:

```bash
ping -c 4 <PRIVATE_IP>
```

---

## Destroy the Environment

After completing the lab, the infrastructure can be removed using:

```bash
terraform destroy
```

This prevents unnecessary AWS resource usage and charges.

---

## Security Considerations

The architecture separates public and private resources:

- Only the Bastion Host requires public access.
- Application/environment EC2 instances remain in private subnets.
- Inter-VPC traffic uses private AWS networking.
- Security groups control instance-level access.
- Network ACLs provide subnet-level controls.
- Route tables explicitly control communication between environments.

For a production environment, Bastion SSH access should be restricted to approved administrator IP ranges rather than allowing unrestricted internet access.

---

## Skills Demonstrated

**AWS | Terraform | AWS Transit Gateway | VPC | EC2 | Bastion Host | Routing | Security Groups | Network ACLs | VPC Reachability Analyzer | Linux | SSH | Infrastructure as Code | Network Troubleshooting**

---

## Key Takeaway

This project demonstrates how **Terraform and AWS Transit Gateway** can be used to build and manage centralized private connectivity across multiple isolated AWS environments.

The implementation connects **Production, Staging, and Test VPCs**, provides controlled administrative access through a **Bastion Host**, and validates cross-VPC communication using practical connectivity testing and **AWS VPC Reachability Analyzer**.
