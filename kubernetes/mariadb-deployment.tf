resource "kubernetes_persistent_volume_claim" "mariadb_pvc" {
  metadata {
    name      = "mariadb-pvc"
    namespace = kubernetes_namespace.wordpress.metadata[0].name
  }

  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "5Gi"
      }
    }
  }
}

resource "kubernetes_deployment" "mariadb" {
  metadata {
    name      = "mariadb"
    namespace = kubernetes_namespace.wordpress.metadata[0].name
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "mariadb"
      }
    }

    template {
      metadata {
        labels = {
          app = "mariadb"
        }
      }

      spec {
        container {
          image = "mariadb:10.5"
          name  = "mariadb"

          env {
            name  = "MYSQL_ROOT_PASSWORD"
            value = "your-root-password"
          }

          env {
            name  = "MYSQL_DATABASE"
            value = "wordpress"
          }

          volume_mount {
            mount_path = "/var/lib/mysql"
            name       = "mariadb-storage"
          }
        }

        volume {
          name = "mariadb-storage"

          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.mariadb_pvc.metadata[0].name
          }
        }
      }
    }
  }
}
