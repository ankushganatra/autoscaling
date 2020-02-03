output "subnet_ids" {
  value = module.vpc.vpc_id
  description  = "Subnet ids created"
  depends_on = [ module.vpc ]
}
