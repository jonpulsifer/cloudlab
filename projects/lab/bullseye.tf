locals {
  /* GCE settings */
  # turn the VM on or off
  online = true

  linux_user = "jawn"
  ssd_size   = 10
  vm_cidr    = "10.13.37.0/29"
}

module "network" {
  source = "../../terraform/modules/gcp-vpc"
  name   = "lab"

  vm_cidr = "${local.vm_cidr}"
}

module "vm" {
  source = "../../terraform/modules/gce-vm"
  name   = "bullseye"

  image_config = {
    family  = "ubuntu-1804-lts"
    project = "trusted-builds"
  }

  instance_config = {
    online       = "${local.online}"
    machine_type = "n1-standard-1"
    subnet       = "${module.network.subnet}"
    linux_user   = "${local.linux_user}"
    mount_point  = "/home/${local.linux_user}"
    ssd_size     = "${local.ssd_size}"
    preemptible  = false
  }
}

module "cos-vm" {
  source = "../../terraform/modules/gce-vm"
  name   = "bullseye-cos"

  image_config = {
    family  = "cos-beta"
    project = "cos-cloud"
  }

  instance_config = {
    online       = "${local.online}"
    machine_type = "n1-standard-1"
    subnet       = "${module.network.subnet}"
    linux_user   = "${local.linux_user}"
    mount_point  = "/home/${local.linux_user}"
    ssd_size     = "${local.ssd_size}"
    preemptible  = false

    metadata_startup_script = <<HEREDOC
#cloud-config

users:
- name: cloudservice
  uid: 2000

write_files:
- path: /etc/systemd/system/cloudservice.service
  permissions: 0644
  owner: root
  content: |
    [Unit]
    Description=Start a simple docker container

    [Service]
    ExecStart=/usr/bin/docker run --rm -u 2000 --name=mycloudservice busybox:latest /bin/sleep 3600
    ExecStop=/usr/bin/docker stop mycloudservice
    ExecStopPost=/usr/bin/docker rm mycloudservice

runcmd:
- systemctl daemon-reload
- systemctl start cloudservice.service

# Optional once-per-boot setup. Ex: mounting a PD.
bootcmd:
- fsck.ext4 -tvy /dev/[DEVICE_ID]
- mkdir -p /mnt/disks/[MNT_DIR]
- mount -t ext4 -O ... /dev/[DEVICE_ID] /mnt/disks/[MNT_DIR]
HEREDOC
  }
}
