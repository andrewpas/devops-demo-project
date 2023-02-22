region = "eu-central-1"

az_count               = 3
public_dns_zone_name   = "dvpslabs.com."
project                = "pepsi-test"
public_route53_records = [
  {
	name    = "dvpslabs.com"
	type    = "NS"
	ttl     = 172800
	records = [
	  "ns-534.awsdns-02.net.", "ns-1302.awsdns-34.org.", "ns-1842.awsdns-38.co.uk.", "ns-51.awsdns-06.com."
	]
  }, {
	name    = "dvpslabs.com."
	type    = "SOA"
	ttl     = 900
	records = ["ns-534.awsdns-02.net. awsdns-hostmaster.amazon.com. 1 7200 900 1209600 86400"]
  }, {
	name    = "dev.dvpslabs.com."
	type    = "A"
	ttl     = 60
	records = ["62.205.130.221"]
  }, {
	name    = "web.dvpslabs.com."
	type    = "A"
	ttl     = 60
	records = ["3.73.46.2"]
  }
]

private_dns_zone_name = [
  {
	name          = "local"
	comment       = "Internal domain name for tests"
	force_destroy = false
  }
]

private_route53_records = [
  {
	name    = "local."
	type    = "NS"
	ttl     = "172800"
	records = ["ns-1536.awsdns-00.co.uk.", "ns-0.awsdns-00.com.", "ns-1024.awsdns-00.org.", "ns-512.awsdns-00.net."]
  }, {
	name    = "local."
	type    = "SOA"
	ttl     = "900"
	records = ["ns-1536.awsdns-00.co.uk. awsdns-hostmaster.amazon.com. 1 7200 900 1209600 86400"]
  }
]

vpc_cidr            = "10.0.0.0/16"
vpc_public_subnets  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
vpc_private_subnets = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]

resource_tags = {
  project_name = "dev-app"
  environment  = "stage"
}
subnet_cidr_bits = 8
aws_access_key   = "xxxxxxxxxxxxxxxx"
aws_secret_key   = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"

node_group_desired_size = 3
node_group_min_size     = 2
node_group_max_size     = 5
node_instance_disk_size = 40
node_instance_type      = "t3.medium"

