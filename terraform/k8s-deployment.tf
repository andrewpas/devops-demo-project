resource "kubernetes_namespace" "ingress" {
  metadata {
	name   = "nginx-ingress"
	labels = {
	  "project"     = "test"
	  "environment" = "stage"
	}
  }
}
