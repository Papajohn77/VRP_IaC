# VRP_Solver Infrastructure as Code (IaC)

The purpose of this repository is to provide the necessary Infrastructure as Code (IaC) scripts to deploy the [VRP_Solver](https://github.com/Papajohn77/VRP_Solver) project.

## Prerequisites

- A DigitalOcean Personal Access Token, which can be [created](https://docs.digitalocean.com/reference/api/create-personal-access-token/) via the DigitalOcean control panel.
- An SSH key named `vrp-env` added to DigitalOcean and GitHub accounts. The `init.yml` Ansible Playbook will generate an SSH key pair inside the VRP_IaC directory.
- A personal domain [pointed](https://docs.digitalocean.com/tutorials/dns-registrars/) to DigitalOcean’s nameservers.

## Ansible Control Node Setup

The Control Node, the machine on which Ansible is installed, is responsible for executing Ansible Playbooks to configure the Ansible Hosts - the target servers that Ansible manages. Unlike other configuration management tools, Ansible is agentless, meaning that it does not require any specialized software to be installed on the Ansible Hosts being managed.

### Installation Guide

- #### Update Packages

  `sudo apt update`

- #### Install pip3

  `sudo DEBIAN_FRONTEND=noninteractive apt install python3-pip -y`

- #### Install Ansible

  `pip3 install ansible`

- #### Clone IaC scripts

  `git clone https://github.com/Papajohn77/VRP_IaC.git`

- #### Change Directory

  `cd ./VRP_IaC`

- #### Execute Ansible Playbook (change <your_email_address>)

  `ansible-playbook -e "email_address=<your_email_address>" init.yml`

- #### [Add](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account) the contents of the SSH public key `tf-digitalocean.pub` to your GitHub account. Moreover, [add](https://docs.digitalocean.com/products/droplets/how-to/add-ssh-keys/to-team/) the contents of the SSH public key `tf-digitalocean.pub` to your DigitalOcean account and give it the name of `vrp-env`.

  `cat tf-digitalocean.pub`

- #### Export Environment Variable (change <your_API_token>)

  `export DIGITALOCEAN_TOKEN=<your_API_token>`

- #### Change Directory

  `cd ./vrp_env`

- #### Execute terraform apply (change <your_domain_name>)

  `terraform apply -var="domain_name=<your_domain_name>" --auto-approve`

- #### Get the IPv4 address of the `vrp-env` Droplet

  `cat vrp-env-ipv4`

- #### Setup the `vrp-env` Droplet (change \<vrp-env-ipv4\>, <your_domain_name> & <your_email_address>)

  `ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u root -i '<vrp-env-ipv4>,' -e 'domain_name=<your_domain_name>' -e 'email_address=<your_email_address>' -e 'pub_key=../tf-digitalocean.pub' --private-key ../tf-digitalocean setup.yml`

## Author

- Ioannis Papadatos
