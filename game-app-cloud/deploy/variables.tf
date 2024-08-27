variable "project" {
  type = object({
    id = string
    region = string 
  })

  default = {
    id = "game-app-433321"
    region = "us-central1"
  }

  sensitive = true
}