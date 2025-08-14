# 네! 링크된 블로그에 있는 Karpenter 관련 코드를 가능한 한 모두 뽑아서 정리해 드릴게요.

# ---

# # 1. IAM 정책 JSON 파일 (karpenter\_iam\_policy.json)

# ```json
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Effect": "Allow",
#       "Action": [
#         "ec2:CreateFleet",
#         "ec2:CreateLaunchTemplate",
#         "ec2:DeleteLaunchTemplate",
#         "ec2:DeleteLaunchTemplateVersions",
#         "ec2:DescribeLaunchTemplateVersions",
#         "ec2:DescribeInstances",
#         "ec2:DescribeInstanceStatus",
#         "ec2:DescribeLaunchTemplates",
#         "ec2:DescribeSubnets",
#         "ec2:DescribeSecurityGroups",
#         "ec2:DescribeInstanceTypes",
#         "ec2:DescribeInstanceTypeOfferings",
#         "ec2:DescribeImages",
#         "ec2:RunInstances",
#         "ec2:TerminateInstances",
#         "ec2:CreateTags",
#         "ec2:DeleteTags"
#       ],
#       "Resource": "*"
#     },
#     {
#       "Effect": "Allow",
#       "Action": [
#         "iam:PassRole"
#       ],
#       "Resource": "*"
#     }
#   ]
# }
# ```

# ---

# # 2. Terraform IAM 정책 및 역할 설정

# ```hcl
# variable "infra_name" {
#   type    = string
#   default = "myinfra"
# }

# data "aws_caller_identity" "current" {}

# data "aws_eks_cluster" "cluster" {
#   name = var.cluster_name
# }

# data "aws_iam_policy_document" "karpenter_assume_role_policy" {
#   statement {
#     actions = ["sts:AssumeRoleWithWebIdentity"]
#     effect  = "Allow"
#     principals {
#       type        = "Federated"
#       identifiers = [
#         "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${replace(data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer, "https://", "")}"
#       ]
#     }
#     condition {
#       test     = "StringEquals"
#       variable = "${replace(data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer, "https://", "")}:sub"
#       values   = ["system:serviceaccount:kube-system:karpenter"]
#     }
#   }
# }

# resource "aws_iam_policy" "karpenter_iam_policy" {
#   name        = "karpenter_iam_policy-${var.infra_name}"
#   description = "Karpenter IAM policy"
#   policy      = file("${path.module}/policy/karpenter_iam_policy.json")
# }

# resource "aws_iam_role" "karpenter_role" {
#   name               = "karpenter-role-${var.infra_name}"
#   assume_role_policy = data.aws_iam_policy_document.karpenter_assume_role_policy.json
# }

# resource "aws_iam_role_policy_attachment" "karpenter_role_attach" {
#   role       = aws_iam_role.karpenter_role.name
#   policy_arn = aws_iam_policy.karpenter_iam_policy.arn
# }
# ```

# ---

# # 3. Helm으로 Karpenter 설치 명령어

# ```bash
# helm repo add karpenter https://charts.karpenter.sh
# helm repo update

# helm install karpenter karpenter/karpenter \
#   --namespace kube-system \
#   --set controller.clusterName=${CLUSTER_NAME} \
#   --set controller.clusterEndpoint=${CLUSTER_ENDPOINT} \
#   --set serviceAccount.annotations."eks\.amazonaws\.com/role-arn"=${KARPENTER_ROLE_ARN} \
#   --create-namespace
# ```

# ---

# # 4. Karpenter Provisioner YAML 예제

# ```yaml
# apiVersion: karpenter.sh/v1alpha5
# kind: Provisioner
# metadata:
#   name: default
# spec:
#   requirements:
#     - key: "node.kubernetes.io/instance-type"
#       operator: In
#       values: ["m5.large", "m5.xlarge"]
#     - key: "topology.kubernetes.io/zone"
#       operator: In
#       values: ["ap-northeast-2a", "ap-northeast-2b"]
#   provider:
#     subnetSelector:
#       karpenter.sh/discovery: ${CLUSTER_NAME}
#     securityGroupSelector:
#       karpenter.sh/discovery: ${CLUSTER_NAME}
#   limits:
#     resources:
#       cpu: 1000
#   ttlSecondsAfterEmpty: 30
# ```

# ---

# # 5. 추가 참고: cluster-autoscaler와 비교 설명 (내용 요약)

# * cluster-autoscaler는 ASG를 기반으로 노드 관리
# * karpenter는 Fleet API로 노드 프로비저닝하며 더 빠른 확장성 제공

# ---

# 필요한 부분 모두 정리해봤는데, 혹시 파일별로 정리해서 드리거나 다른 코드도 더 필요하면 편하게 말씀해주세요!
