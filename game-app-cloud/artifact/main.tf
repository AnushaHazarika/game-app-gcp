resource "google_artifact_registry_repository" "game-repo" {
  repository_id = "game-repo"
  location = var.project.region
  description = "Docker repo for container image"
  format = "DOCKER"

    docker_config {
        immutable_tags = false
    }

    labels = {
        "env" = "test"
        "created-using"= "terraform"
    }
}