resource "aws_iam_role" "IAMRole-Ec2TrustRole" {
  name = "IB07441_IAMRole_Ec2TrustRole_SpringBoot_AWS"
  path = "/"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
            {
              "Sid": "",
              "Effect": "Allow",
              "Principal": {
                "Service": "ec2.amazonaws.com"
              },
              "Action": "sts:AssumeRole"
            }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "IAMRolePolicyAttachment_AmazonEC2RoleforAWSCodeDeploy" {
  role       = aws_iam_role.IAMRole-Ec2TrustRole.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforAWSCodeDeploy"
}

//resource "aws_iam_role_policy_attachment" "IAMRolePolicyAttachment_AWSCodeDeployReadOnlyAccess" {
//  role       = aws_iam_role.IAMRole-Ec2TrustRole.name
//  policy_arn = "arn:aws:iam::aws:policy/AWSCodeDeployReadOnlyAccess"
//}
//
//resource "aws_iam_role_policy_attachment" "IAMRolePolicyAttachment_AmazonEC2ReadOnlyAccess" {
//  role       = aws_iam_role.IAMRole-Ec2TrustRole.name
//  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
//}

//resource "aws_iam_policy" "IAMPolicy_SpringBoot_AWS" {
//  name        = "IB07441_IAMPolicy_SpringBoot_AWS"
//  path        = "/"
//  description = "IB07441_IAMPolicy_SpringBoot_AWS"
//
//  policy = <<EOF
//{
//  "Version": "2012-10-17",
//  "Statement": [
//            {
//              "Effect": "Allow",
//              "Action": [
//                "ec2:DescribeInstances",
//                "ec2:DescribeInstanceStatus"
//              ],
//              "Resource": "*"
//            },
//            {
//              "Effect": "Allow",
//              "Action": [
//                "s3:Get*",
//                "s3:List*"
//              ],
//              "Resource": [
//                "arn:aws:s3:::ib07441-s3bucket-springboot-aws",
//                "arn:aws:s3:::ib07441-s3bucket-springboot-aws/*"
//              ]
//            }
//  ]
//}
//EOF
//}

//resource "aws_iam_role_policy_attachment" "IAMRolePolicyAttachment_SpringBoot_AWS" {
//  role       = aws_iam_role.IAMRole-Ec2TrustRole.name
//  policy_arn = aws_iam_policy.IAMPolicy_SpringBoot_AWS.arn
//}

resource "aws_iam_instance_profile" "IAMInstanceProfile" {
  name = "IB07441_IAMInstanceProfile_SpringBoot_AWS"
  role = aws_iam_role.IAMRole-Ec2TrustRole.name
}

resource "aws_iam_role" "IAMRole_CodeDeployTrustRole" {
  name = "IB07441_IAMRole_CodeDeployTrustRole_SpringBoot_AWS"
  path = "/"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
            {
              "Sid" : "",
              "Effect" : "Allow",
              "Principal" : {
                "Service": [
                    "codedeploy.amazonaws.com"
                ]
              },
              "Action" : "sts:AssumeRole"
            }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "IAMRolePolicyAttachment_AWSCodeDeployRole" {
  role       = aws_iam_role.IAMRole_CodeDeployTrustRole.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
}