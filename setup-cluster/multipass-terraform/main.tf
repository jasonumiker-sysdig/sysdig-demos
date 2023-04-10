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

resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = "5.28.1"
  namespace        = "argocd"
  create_namespace = "true"
  values = [
    "${file("${var.argocd-helm-values}")}"
  ]
  depends_on       = [null_resource.multipass]
}