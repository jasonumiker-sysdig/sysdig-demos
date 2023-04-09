resource "null_resource" "multipass" {
  triggers = {
    name = var.name
  }

  provisioner "local-exec" {
    command    = "multipass launch --name ${var.name} -c${var.cores} -m${var.memory}GB -d${var.storage}GB --cloud-init ${var.userdata} --timeout 600 ${var.image}"
    on_failure = fail
  }

  provisioner "local-exec" {
    command    = "multipass transfer ${var.name}:/home/ubuntu/.kube/config kubeconfig"
    on_failure = fail
  }

  provisioner "local-exec" {
    when       = destroy
    command    = "multipass delete ${self.triggers.name} --purge"
    on_failure = continue
  }
}

resource "helm_release" "sysdig_agent_chart" {
  name             = "sysdig-agent"
  repository       = "https://charts.sysdig.com"
  chart            = "sysdig-deploy"
  version          = "1.6.12"
  namespace        = "sysdig-agent"
  create_namespace = "true"
  values           = ["${file("${var.syddig-helm-values}")}"]
  depends_on       = [null_resource.multipass]
}