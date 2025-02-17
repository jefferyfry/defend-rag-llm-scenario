resource "aws_security_group" "sg_new" {
  name        = var.name
  description = var.description
  vpc_id      = var.vpc_id

  tags = var.tags
  lifecycle {
    ignore_changes = [tags["Created-Date"]]
  }
}

resource "aws_security_group_rule" "custom_rules" {
  count             = length(var.custom_security_rules) > 0 ? length(var.custom_security_rules) : 0
  type              = lookup(var.custom_security_rules[count.index], "type")
  from_port         = lookup(var.custom_security_rules[count.index], "from_port")
  to_port           = lookup(var.custom_security_rules[count.index], "to_port")
  protocol          = lookup(var.custom_security_rules[count.index], "protocol")
  cidr_blocks       = [lookup(var.custom_security_rules[count.index], "cidr_blocks")]
  description       = lookup(var.custom_security_rules[count.index], "description")
  security_group_id = aws_security_group.sg_new.id
}
