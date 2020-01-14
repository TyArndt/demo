
data "aws_route53_zone" "talabs_zone" {
    name        = "tylerarndtlabs.com"
}



resource "aws_route53_record" "brownbagdemo" {
    zone_id     = data.aws_route53_zone.talabs_zone.id
    name        = "brownbagdemo.tylerarndtlabs.com"
    type        = "CNAME"
    ttl         = "300"
    records     = ["${aws_lb.demo_lb.dns_name}"]
}
