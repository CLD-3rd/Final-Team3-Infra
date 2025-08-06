# IRSA용 IAM 역할 생성
resource "aws_iam_role" "ca_irsa" {
  name = "${var.cluster_name}-ca-irsa"
  assume_role_policy = jsonencode({  # 해당 IAM 역할을 누가 위임할 수 있는지 정의하는 정책
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Federated = var.oidc_provider_arn  # EKS의 OIDC가 위임
      }
      Action = "sts:AssumeRoleWithWebIdentity"
      Condition = {
        StringEquals = {
          "${replace(var.cluster_oidc_url, "https://", "")}:sub" = "system:serviceaccount:kube-system:cluster-autoscaler"
        }  # 이 역할은 kube-system 네임스페이스의 cluster-autoscaler라는 이름의 SA가 위임할 수 있음을 의미
      }
    }]
  })
  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "ca_policy_attach" {  # 정책을 역할에 연결
  role       = aws_iam_role.ca_irsa.name
  policy_arn = "arn:aws:iam::aws:policy/AutoScalingFullAccess"
}  # CA가 ASG의 크기 변경, 인스턴스 조정 등 AWS 리소스 조작이 가능해지는 정책

resource "kubernetes_service_account" "ca_sa" {  # k8s 내 CA pod가 사용할 SA 생성
  metadata {
    name      = "cluster-autoscaler"
    namespace = "kube-system"
    annotations = {  # EKS가 해당 SA로부터 실행되는 Pod에게 ca_irsa IAM 역할을 위임할 수 있게 연결
      "eks.amazonaws.com/role-arn" = aws_iam_role.ca_irsa.arn
    }
    labels = {
      "k8s-addon" = "cluster-autoscaler.addons.k8s.io"
    }
  }
}  # 생성된 SA에 IAM 역할(ca_irsa)을 연결하여 IRSA(OIDC 기반 IAM 역할 위임)를 가능하게 함

resource "helm_release" "ca" {  # CA 설치
  name       = "cluster-autoscaler"
  namespace  = "kube-system"
  chart      = "cluster-autoscaler"
  repository = "https://kubernetes.github.io/autoscaler"
  version    = "9.47.0"

  values = [  # Helm Chart의 values.yaml에 전달할 값
    yamlencode({
      cloudProvider = "aws"
      awsRegion     = var.aws_region
      autoDiscovery = {
        clusterName = var.cluster_name
        tags = {
            "kubernetes.io/cluster/${var.cluster_name}" = "owned"
            "eks.amazonaws.com/nodegroup" = var.node_group_name
        }
      }
      rbac = {
        serviceAccount = {
          create = false  # 자체적인 SA 생성 방지
          name   = kubernetes_service_account.ca_sa.metadata[0].name  # 위에서 만든 SA 이름 지정
        }
      }
      extraArgs = {  # CA Pod에 전달될 추가 인자
        skip-nodes-with-local-storage = "false"
        scan-interval                 = "10s"
        expander                      = "least-waste"  # 스케일 아웃 시 가장 적은 리소스를 낭비하는 노드를 우선 선택
      }
      nodeSelector = {
        "kubernetes.io/os" = "linux"
      }
      tolerations = [{  # 기본적으로 control-plane 노드는 NoSchedule taint가 있어서 파드를 안 받음
        key      = "node-role.kubernetes.io/control-plane"
        operator = "Exists"
        effect   = "NoSchedule"
      }]  # Cluster Autoscaler가 control-plane 노드에도 스케줄될 수 있게 세팅
    })
  ]
  depends_on = [kubernetes_service_account.ca_sa]
}

resource "kubernetes_cluster_role" "cluster_autoscaler" {  # RBAC
  metadata {
    name = "cluster-autoscaler"
  }

  rule {
    api_groups = [""]
    resources  = ["events", "endpoints", "pods", "services", "nodes", "persistentvolumeclaims", "persistentvolumes"]
    verbs      = ["watch", "list", "get"]
  }

  rule {
    api_groups = [""]
    resources  = ["nodes/status"]
    verbs      = ["patch"]
  }

  rule {
    api_groups = ["apps"]
    resources  = ["replicasets"]
    verbs      = ["watch", "list", "get"]
  }

  rule {
    api_groups = ["extensions"]
    resources  = ["replicasets"]
    verbs      = ["watch", "list", "get"]
  }

  rule {
    api_groups = ["apps", "extensions"]
    resources  = ["deployments"]
    verbs      = ["watch", "list", "get"]
  }

  rule {
    api_groups = [""]
    resources  = ["replicationcontrollers"]
    verbs      = ["watch", "list", "get"]
  }

  rule {
    api_groups = ["policy"]
    resources  = ["poddisruptionbudgets"]
    verbs      = ["watch", "list"]
  }

  rule {
    api_groups = [""]
    resources  = ["pods/eviction"]
    verbs      = ["create"]
  }

  rule {
    api_groups = ["autoscaling.k8s.io"]
    resources  = ["verticalpodautoscalers"]
    verbs      = ["watch", "list", "get"]
  }

  rule {
    api_groups = ["coordination.k8s.io"]
    resources  = ["leases"]
    verbs      = ["create", "get", "list", "update"]
  }
}

resource "kubernetes_cluster_role_binding" "cluster_autoscaler" {
  metadata {
    name = "cluster-autoscaler"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.cluster_autoscaler.metadata[0].name
  }

  subject {
    kind      = "ServiceAccount"
    name      = "cluster-autoscaler"
    namespace = "kube-system"
  }
}