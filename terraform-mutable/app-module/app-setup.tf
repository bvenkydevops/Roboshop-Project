resource "null_resource" "app-deploy" {
  count = length(local.PRIVATE_IPS)
  triggers = {
    //private_ip = element(local.PRIVATE_IPS, count.index)
    abc = timestamp()
  }
  provisioner "remote-exec" {
    connection {
      host     = element(local.PRIVATE_IPS, count.index)
      user     = local.ssh_user
      password = local.ssh_pass
    }

    inline = [
      "ansible-pull -U https://DevOps-Batches@dev.azure.com/DevOps-Batches/DevOps60/_git/ansible roboshop-pull.yml -e ENV=${var.ENV} -e COMPONENT=${var.COMPONENT} -e APP_VERSION=${var.APP_VERSION} -e NEXUS_USER=${var.NEXUS_USER} -e NEXUS_PASS=${var.NEXUS_PASS}"
    ]
  }
}
