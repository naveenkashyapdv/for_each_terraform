globals = {
  vsphere = {
    address                   = ""
    datacenter                = ""
    datastore_cluster         = ""
    resource_pool             = ""
    distributed_switch_folder = ""
    distributed_port_group    = ""
    script_execution_path     = ""
  }
  infoblox = {
    address      = ""
    network_view = ""
    ip_block = {
      cidr    = ""
      gateway = ""
    }
    tenant   = ""
    dns_view = ""
    domain   = ""
  }
  datacenter_code = ""
  dns_servers     = ["", ""]
  chef = {
    master_server_url = ""
    username          = ""
    key               = ""
    dmgr_hostname     = ""
    run_list          = [""]
    runlist_destroy   = ""
    profile_name      = ""
    environment       = ""
    client_version    = ""
  }
}

secrets = {
  vsphere = {
    username = ""
    password = ""
  }
  infoblox = {
    username = ""
    password = ""
  }
  remote_exec = {
    username = ""
    password = ""
  }
}

each_foo = {
  server1 = {
    file_system_resizing = {
      lv_opt_addition         = "40" # grow /var by
      lv_tmp_addition         = "10"
      physical_volume_disk    = "sdb"
      root_volume_group_name  = "vg_root"
      group_volume_disk       = "sdb"
      logical_app_volume_disk = "lv_app"
      logical_tmp_volume_disk = "lv_tmp"
    }
    deployment = {
      template  = ""
      cpu_cores = "4"
      memory_mb = "8192"
      node_name = ""
      disks = [
        {
          unit_number = "0"
          size_gb     = "150"
        },
        {
          unit_number = "1"
          size_gb     = "100"
        }
      ]
    }
  },
  server2 = {
    file_system_resizing = {
      lv_opt_addition         = "40" # grow /var by
      lv_tmp_addition         = "10"
      physical_volume_disk    = "sdb"
      root_volume_group_name  = "vg_root"
      group_volume_disk       = "sdb"
      logical_app_volume_disk = "lv_app"
      logical_tmp_volume_disk = "lv_tmp"
    }
    deployment = {
      template  = ""
      cpu_cores = "4"
      memory_mb = "8192"
      node_name = ""
      disks = [
        {
          unit_number = "0"
          size_gb     = "150"
        },
        {
          unit_number = "1"
          size_gb     = "100"
        }
      ]
    }
  },
  server3 = {
    file_system_resizing = {
      lv_opt_addition         = "40" # grow /var by
      lv_tmp_addition         = "10"
      physical_volume_disk    = "sdb"
      root_volume_group_name  = "vg_root"
      group_volume_disk       = "sdb"
      logical_app_volume_disk = "lv_app"
      logical_tmp_volume_disk = "lv_tmp"
    }
    deployment = {
      template  = "rhel_latest"
      cpu_cores = "4"
      memory_mb = "8192"
      node_name = ""
      disks = [
        {
          unit_number = "0"
          size_gb     = "150"
        },
        {
          unit_number = "1"
          size_gb     = "100"
        }
      ]
    }
  },
  server4 = {
    file_system_resizing = {
      lv_opt_addition         = "40" # grow /var by
      lv_tmp_addition         = "10"
      physical_volume_disk    = "sdb"
      root_volume_group_name  = "vg_root"
      group_volume_disk       = "sdb"
      logical_app_volume_disk = "lv_app"
      logical_tmp_volume_disk = "lv_tmp"
    }
    deployment = {
      template  = ""
      cpu_cores = "4"
      memory_mb = "8192"
      node_name = ""
      disks = [
        {
          unit_number = "0"
          size_gb     = "150"
        },
        {
          unit_number = "1"
          size_gb     = "100"
        }
      ]
    }
  }
}                                                                                                                     