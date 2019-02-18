workflow "Main" {
  on = "push"
  resolves = ["Push image"]
}

action "Build image" {
  uses = "actions/docker/cli@76ff57a"
  args = "build -t sagebind/digitalocean-volume-snapshots ."
}

action "Master" {
  needs = ["Build image"]
  uses = "actions/bin/filter@b2bea07"
  args = "branch master"
}

action "Registry login" {
  needs = ["Master"]
  uses = "actions/docker/login@76ff57a"
  secrets = ["DOCKER_USERNAME", "DOCKER_PASSWORD"]
}

action "Push image" {
  needs = ["Registry login"]
  uses = "actions/docker/cli@76ff57a"
  args = "push sagebind/digitalocean-volume-snapshots"
}
