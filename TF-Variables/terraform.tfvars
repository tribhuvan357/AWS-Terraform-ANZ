my_instance_type = "t3.micro"

my_root_block_device = {
  v_size = 30
  v_type = "gp3"
}

additional_tags = {
  Dept    = "QA"
  Project = "MyTestQA"
}