module "vsphere" {
  source   = "git::ssh://git@gitlab.com.git"
  globals  = var.globals
  secrets  = var.secrets
  each_foo = var.each_foo
}

resource "null_resource" "file_system_resizing" {
  for_each = var.each_foo
  connection {
    type        = "ssh"
    host        = module.vsphere.each_vm[each.key].ip_address
    user        = var.secrets.remote_exec.username
    password    = var.secrets.remote_exec.password
    script_path = var.globals.vsphere.script_execution_path
  }

  provisioner "remote-exec" {
    inline = [<<EOF
sudo vgextend "${each.value.file_system_resizing.root_volume_group_name}" /dev/"${each.value.file_system_resizing.group_volume_disk}"
sudo lvextend -L+"${each.value.file_system_resizing.lv_opt_addition}"G /dev/"${each.value.file_system_resizing.root_volume_group_name}/${each.value.file_system_resizing.logical_app_volume_disk}"
sudo lvextend -L+"${each.value.file_system_resizing.lv_tmp_addition}"G /dev/"${each.value.file_system_resizing.root_volume_group_name}/${each.value.file_system_resizing.logical_tmp_volume_disk}"
sudo xfs_growfs /dev/"${each.value.file_system_resizing.root_volume_group_name}/${each.value.file_system_resizing.logical_app_volume_disk}"
sudo resize2fs /dev/"${each.value.file_system_resizing.root_volume_group_name}/${each.value.file_system_resizing.logical_tmp_volume_disk}"
EOF
    ]
  }
  depends_on = [module.vsphere]
}


resource "null_resource" "provisioning" {
  for_each = var.each_foo

  triggers = {
    vm_id           = module.vsphere.each_vm[each.key].id
    vm_fqdn         = module.vsphere.each_vm[each.key].fqdn
    vm_ip           = module.vsphere.each_vm[each.key].ip_address
    chef_user_name  = var.globals.chef.username
    chef_user_key   = var.globals.chef.key
    chef_server_url = var.globals.chef.master_server_url
    user            = var.secrets.remote_exec.username
    password        = var.secrets.remote_exec.password
    wc_profile_name = var.globals.chef.profile_name
    version         = var.globals.chef.client_version
    environment     = var.globals.chef.environment
    dmgr_hostname   = var.globals.chef.dmgr_hostname
    node_name       = each.value.deployment.node_name
    runlist_destroy = var.globals.chef.runlist_destroy
  }

  depends_on = [module.vsphere, null_resource.file_system_resizing]
  #Chef Provisioning      
  provisioner "chef" {
    attributes_json = <<EOF
      {
        "wc_profile_name": "${self.triggers.wc_profile_name}",
        "websphere": {
          "dmgr_host": "${self.triggers.dmgr_hostname}"
          },
        "websphere-test": {
          "node_name": "${self.triggers.node_name}"
        }  
      }
    EOF
    environment     = var.globals.chef.environment
    recreate_client = true
    user_name       = self.triggers.chef_user_name
    user_key        = self.triggers.chef_user_key
    run_list        = var.globals.chef.run_list
    node_name       = module.vsphere.each_vm[each.key].fqdn
    server_url      = self.triggers.chef_server_url
    version         = var.globals.chef.client_version

    # If you have a self signed cert on your chef server change this to :verify_none
    ssl_verify_mode = ":verify_none"

    connection {
      type     = "ssh"
      host     = self.triggers.vm_ip
      user     = self.triggers.user
      password = self.triggers.password
      timeout  = "3600000000000s"
    }
  }

  ####### remove Node#######
  provisioner "chef" {
    when            = destroy
    attributes_json = <<EOF
      {
        "wc_profile_name": "${self.triggers.wc_profile_name}",
        "websphere": {
          "dmgr_host": "${self.triggers.dmgr_hostname}"
          },
        "websphere-test": {
          "node_name": "${self.triggers.node_name}"
        }  
      }
    EOF
    environment     = self.triggers.environment
    recreate_client = true
    user_name       = self.triggers.chef_user_name
    user_key        = self.triggers.chef_user_key
    run_list        = [self.triggers.runlist_destroy]
    node_name       = self.triggers.node_name
    server_url      = self.triggers.chef_server_url
    version         = self.triggers.version

    # If you have a self signed cert on your chef server change this to :verify_none
    ssl_verify_mode = ":verify_none"

    connection {
      type     = "ssh"
      host     = self.triggers.vm_ip
      user     = self.triggers.user
      password = self.triggers.password
      timeout  = "3600000000000s"
    }
  }

  // provisioner "local-exec" {
  //   when = destroy
  //   command = "bash scripts/cleanup_node.sh ${self.triggers.chef_user_name} '${self.triggers.chef_user_key}' ${self.triggers.chef_server_url} ${self.triggers.vm_fqdn}"
  // }

}