variable "ec2_config" {
  type = list(object({
    ami           = string
    instance_type = string
    # Key-pair name
    # etc like Other EC2 Instances features
  }))
}

#Note:- we can also use the default value for this variable here only