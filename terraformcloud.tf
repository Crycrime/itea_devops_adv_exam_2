terraform {
  backend "remote" {
    organization = "devops-adv"

    workspaces {
      name = "devops-adv"
    }
  }
}
