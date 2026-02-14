variable "sakuracloud_token" {
  type        = string
  description = "Sakura Cloud API トークン"
}

variable "sakuracloud_secret" {
  type        = string
  description = "Sakura Cloud API シークレット"
}

variable "ssh_public_key_path" {
  type        = string
  description = "サーバーに登録するSSH公開鍵ファイルのパス（例: ~/.ssh/id_rsa.pub）"
}

variable "disk_size_gb" {
  type        = number
  default     = 20
  description = "ブートディスクのサイズ（GiB）"
}
