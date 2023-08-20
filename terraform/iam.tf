resource "aws_iam_instance_profile" "ssm" {
  name = "terraform-test-ssm-instanceprofile"
  role = aws_iam_role.ssm.name
}

resource "aws_iam_role" "ssm" {
  name               = "terraform-test-ssm-iamrole"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
}

resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.ssm.name
  policy_arn = data.aws_iam_policy.systems_manager.arn
}
