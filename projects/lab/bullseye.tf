locals {
  /* GCE settings */
  # turn the VM on or off
  online = true

  ssd_size = 10
  vm_cidr  = "10.13.37.0/29"
}

module "network" {
  source = "../../terraform/modules/gcp-vpc"
  name   = "lab"

  vm_cidr = "${local.vm_cidr}"
}

module "cos-vm" {
  source = "../../terraform/modules/gce-cos-vm"
  name   = "bullseye-cos"

  image_config = {
    family  = "cos-beta"
    project = "cos-cloud"
  }

  instance_config = {
    online       = "${local.online}"
    machine_type = "n1-standard-1"
    subnet       = "${module.network.subnet}"
    ssd_size     = "${local.ssd_size}"
    preemptible  = false

    cloud_init = <<HEREDOC
#cloud-config

write_files:
- path: /etc/systemd/system/bullseye.service
  permissions: 0644
  owner: root
  content: |
    [Unit]
    Description=Start the bullseye container
    Wants=gcr-online.target
    After=gcr-online.target

    [Service]
    Environment="HOME=/home/cloudservice"
    ExecStartPre=/usr/bin/docker-credential-gcr configure-docker
    ExecStartPre=/sbin/iptables -w -A INPUT -p tcp --dport 30022 -j ACCEPT
    ExecStart=/usr/bin/docker run --rm --name=bullseye --network=host -v /home/bullseye:/home/jawn gcr.io/trusted-builds/cloudlab-linux-build:latest
    ExecStop=/usr/bin/docker stop bullseye
    ExecStopPost=/usr/bin/docker rm bullseye

- path: /etc/systemd/system/datadog.service
  permissions: 0644
  owner: root
  content: |
    [Unit]
    Description=Datadog Agent container

    [Service]
    Environment="HOME=/home/cloudservice"
    ExecStart=/usr/bin/docker run --rm --name=datadog -v /var/run/docker.sock:/var/run/docker.sock:ro -v /proc/:/host/proc/:ro -v /sys/fs/cgroup/:/host/sys/fs/cgroup:ro -v /etc/passwd:/etc/passwd:ro -e DD_PROCESS_AGENT_ENABLED=true -e DD_API_KEY=lolol datadog/agent:latest
    ExecStop=/usr/bin/docker stop datadog
    ExecStopPost=/usr/bin/docker rm datadog

runcmd:
- systemctl daemon-reload
- systemctl start bullseye.service
- systemctl start datadog.service

# Optional once-per-boot setup. Ex: mounting a PD.
bootcmd:
- mkfs.ext4 -m 0 -F -E lazy_itable_init=0,lazy_journal_init=0,discard /dev/sdb
- mkdir -p /home/bullseye
- mount -o discard,defaults /dev/sdb /home/bullseye
HEREDOC
  }
}
