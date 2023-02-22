resource "aws_kms_key" "cluster_encrypt" {
  key_usage               = "ENCRYPT_DECRYPT"
  is_enabled              = true
  description             = "Cluster credentials encryption key"
  enable_key_rotation     = true
  deletion_window_in_days = 7
}

resource "aws_kms_alias" "cluster" {
  target_key_id = aws_kms_key.cluster_encrypt.key_id
  name          = "alias/${var.project}-kms-key"
}

