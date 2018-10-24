data "vsphere_virtual_machine" "template" {
  name          = "packer-ubuntu-1804"
  datacenter_id = "${data.vsphere_datacenter.lab.id}"
}

resource "vsphere_virtual_disk" "home" {
  size         = 10
  vmdk_path    = "homedir.vmdk"
  datacenter   = "${data.vsphere_datacenter.lab.name}"
  datastore    = "${data.vsphere_datastore.ssd.name}"
  type         = "thin"
}

resource "vsphere_virtual_machine" "bullseye" {
  count = 0
  name             = "bullseye"
  annotation       = "Bullseye - Ubuntu 1804"
  resource_pool_id = "${data.vsphere_resource_pool.host.id}"
  datastore_id     = "${data.vsphere_datastore.ssd.id}"

  num_cpus = 2
  memory   = 1024
  guest_id = "${data.vsphere_virtual_machine.template.guest_id}"

  
  cpu_hot_add_enabled    = true
  cpu_hot_remove_enabled = true
  memory_hot_add_enabled = true
  
  enable_logging      = true
  sync_time_with_host = true

  network_interface {
    network_id   = "${data.vsphere_network.vms.id}"
    adapter_type = "${data.vsphere_virtual_machine.template.network_interface_types[0]}"
  }
  
  scsi_controller_count = 1
  scsi_type = "${data.vsphere_virtual_machine.template.scsi_type}"

  disk {
      label            = "disk0"
      size             = "${data.vsphere_virtual_machine.template.disks.0.size}"
      eagerly_scrub    = "${data.vsphere_virtual_machine.template.disks.0.eagerly_scrub}"
      thin_provisioned = "${data.vsphere_virtual_machine.template.disks.0.thin_provisioned}"
  }

  enable_disk_uuid = true
  disk {
    label        = "disk1"
    unit_number  = 1
    attach       = true
    path         = "/homedir.vmdk"
    datastore_id = "${data.vsphere_datastore.ssd.id}"
  }

  clone {
    template_uuid = "${data.vsphere_virtual_machine.template.id}"
  }
}