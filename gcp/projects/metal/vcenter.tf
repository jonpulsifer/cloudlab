resource "vsphere_virtual_machine" "vcenter" {
  name             = "vcenter"
  annotation       = "VMware vCenter Server Appliance"
  resource_pool_id = "${data.vsphere_resource_pool.host.id}"
  datastore_id     = "${data.vsphere_datastore.ssd.id}"

  num_cpus = 2
  memory   = 4096
  guest_id = "other3xLinux64Guest"

  cpu_hot_add_enabled    = true
  cpu_hot_remove_enabled = true
  memory_hot_add_enabled = true

  enable_logging      = true
  sync_time_with_host = true

  network_interface {
    network_id = "${data.vsphere_network.vms.id}"
  }

  scsi_controller_count = 2
  scsi_type             = "lsilogic"

  cdrom {
    client_device = true
    datastore_id  = ""
    path          = ""
  }

  disk {
    label          = "disk0"
    size           = 12
    keep_on_remove = true
  }

  disk {
    label          = "disk1"
    size           = 1
    keep_on_remove = true
    unit_number    = 1
  }

  disk {
    label          = "disk2"
    size           = 25
    keep_on_remove = true
    unit_number    = 2
  }

  disk {
    label          = "disk3"
    size           = 25
    keep_on_remove = true
    unit_number    = 3
  }

  disk {
    label          = "disk4"
    size           = 10
    keep_on_remove = true
    unit_number    = 4
  }

  disk {
    label          = "disk5"
    size           = 10
    keep_on_remove = true
    unit_number    = 5
  }

  disk {
    label          = "disk6"
    size           = 15
    keep_on_remove = true
    unit_number    = 6
  }

  disk {
    label          = "disk7"
    size           = 10
    keep_on_remove = true
    unit_number    = 7
  }

  disk {
    label          = "disk8"
    size           = 1
    keep_on_remove = true
    unit_number    = 8
  }

  disk {
    label          = "disk9"
    size           = 10
    keep_on_remove = true
    unit_number    = 9
  }

  disk {
    label          = "disk10"
    size           = 10
    keep_on_remove = true
    unit_number    = 10
  }

  disk {
    label          = "disk11"
    size           = 100
    keep_on_remove = true
    unit_number    = 11
  }

  disk {
    label          = "disk12"
    size           = 50
    keep_on_remove = true
    unit_number    = 12
  }
}
