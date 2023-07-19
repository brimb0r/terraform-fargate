aws_region                = "us-west-2"
dns_zone_id               = "Z029066226EQ52O1INONO" // need to make a new zone
environment               = "dev"
web_ssl_cert_arn          = "" // need us-west-2 cert
vpc_cidr_block            = "10.0.0.0/16"
pub_d_cidr_block          = "10.0.1.0/25"
priv_d_cidr_block         = "10.0.2.0/25"
pub_e_cidr_block          = "10.0.1.128/25"
priv_e_cidr_block         = "10.0.2.128/25"
sunrise_container_ingress = [3000, 3000, "tcp", "LB Can hit this"]
sunrise_container_port    = 3000
api_whitelist = [
  "0.0.0.0/0",
]

