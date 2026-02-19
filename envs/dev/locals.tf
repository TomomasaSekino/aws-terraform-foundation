locals {
  name_prefix = "${var.env}-${var.project}"

  common_tags = merge(
    {
      Env     = var.env
      Project = var.project
      Owner   = var.owner
    },
    var.tags
  )
}