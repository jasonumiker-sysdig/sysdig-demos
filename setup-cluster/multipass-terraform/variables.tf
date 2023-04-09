variable "name" {
  description = "The name of our VM"
  type        = string
  default     = "microk8s-vm-sysdig"
}

variable "memory" {
  description = "Memory/RAM to allocate in GBs"
  type        = number
  default     = 8
}

variable "storage" {
  description = "Disk space to allocate in GBs"
  type        = number
  default     = 20
}

variable "cores" {
  description = "Number of CPUs to allocate"
  type        = number
  default     = 4
}

variable "userdata" {
  description = "Cloud-init Script"
  type        = string
  default     = "../cloud-init.yaml"
}

variable "image" {
  description = "The multipass image to launch"
  type        = string
  default     = "22.04"
}

variable "syddig-helm-values" {
  description = "The values file to use for Sysdig Agent"
  type        = string
  default     = "../sysdig-agent-values.yaml"
}
