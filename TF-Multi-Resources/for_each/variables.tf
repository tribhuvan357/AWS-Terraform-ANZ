#for_each is used with map or set
#key=value (object{ami, instance})

variable "ec2_map" {
  type = map(object({
    ami           = string
    instance_type = string
  }))
}