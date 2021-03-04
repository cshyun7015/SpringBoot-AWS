resource "aws_codedeploy_app" "CodedeployApp" {
  compute_platform = "Server"
  name             = "IB07441-CodeDeployApp-SpringBoot-AWS"
}

resource "aws_codedeploy_deployment_group" "CodedeployDeploymentGroup" {
  app_name              = aws_codedeploy_app.CodedeployApp.name
  deployment_group_name = "IB07441-CodedeployDeploymentGroup-SpringBoot-AWS"
  service_role_arn      = aws_iam_role.IAMRole_CodeDeployTrustRole.arn
  deployment_config_name = "CodeDeployDefault.OneAtATime"
  ec2_tag_set {
    ec2_tag_filter {
      key = "Name"
      type = "KEY_AND_VALUE"
      value = "IB07441-Instance-SpringBoot-AWS"
    }
  }
}