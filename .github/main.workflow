workflow "build and push image" {
  on = "push"
  resolves = ["pangzineng/Github-Action-One-Click-Docker@master"]
}

action "pangzineng/Github-Action-One-Click-Docker@master" {
  uses = "pangzineng/Github-Action-One-Click-Docker@master"
  secrets = ["DOCKER_USERNAME", "DOCKER_PASSWORD"]
  env = {
    BRANCH_FILTER = "master"
  }
}
