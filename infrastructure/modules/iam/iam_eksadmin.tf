#########################################################
# IAM 역할 관련 모듈 main.tf
# EKS Admin Role 생성
# EKS 접근 가능한 가능한 역할 생성
resource "aws_iam_role" "eks_admin_role" {
  name = "${var.name_prefix}-eks-admin-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = var.admin_user_arn  # 여기 관리자 사용자 ARN 넣기
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
  tags = var.tags
}

# IAM 역할에 AdministratorAccess 정책 연결
# 만들어진 역할에 AdministratorAccess 정책 연결
resource "aws_iam_role_policy_attachment" "eks_admin_role_policy" {
  role       = aws_iam_role.eks_admin_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

# EKS 액세스 엔트리로 등록
# 생성한 역할을 클러스터 접근 허용 대상에 등록 -> IAM 액세스 항목
resource "aws_eks_access_entry" "admin" {
  cluster_name  = var.cluster_name
  principal_arn = aws_iam_role.eks_admin_role.arn    #이 부분에 AWS 사용자가 들어가야 함
  type          = "STANDARD"
    depends_on = [
    var.eks_cluster_resource
  ]
}

# EKS Access Policy Association - 관리자 권한 부여
# 역할에 클러스터 관리자 권한 정책 연결
resource "aws_eks_access_policy_association" "eks_admin" {
  cluster_name   = var.cluster_name
  principal_arn  = aws_eks_access_entry.admin.principal_arn
  policy_arn     = var.eks_admin_policy_arn

  access_scope {
    type = "cluster"
  }

  depends_on = [
    aws_eks_access_entry.admin
  ]
}

# 현재 AWS 계정 정보를 가져옴
data "aws_caller_identity" "current" {}

# IAM 사용자에게 sts:AssumeRole 권한 주기
resource "aws_iam_policy" "allow_assume_role" {
  # name = "${var.name_prefix}-eks-allow-role"
  name = "${var.name_prefix}-allow-assume-role"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "sts:AssumeRole"
        Resource = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/matchfit-eks-admin-role"
      }
    ]
  })
}

resource "aws_iam_user_policy_attachment" "attach_assume_role" {
  user       = "lion3fteam03"     # var.iam_user_name
  policy_arn = aws_iam_policy.allow_assume_role.arn
}