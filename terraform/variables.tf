variable "vpc_cidr" {
  description = "vpc_cidr"
  type        = string
}

variable "public-subnets" {
  description = "public subnets"
  type = map(object({
    az   = string
    cidr = string
  }))
}

variable "private-subnets" {
  description = "private subnets"
  type = map(object({
    az   = string
    cidr = string
  }))
}
