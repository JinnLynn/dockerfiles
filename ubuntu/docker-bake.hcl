variable "DOCKER_USER" {
	default = ""
}
variable "LATEST_VERSION" {
    default = "20.04"
}

group "default" {
    targets = ["latest", "18.04"]
}

target "latest" {
    dockerfile = "Dockerfile"
    platforms = ["linux/amd64", "linux/arm64", "linux/arm"]
    pull = true
	tags = [
         "${DOCKER_USER}/ubuntu",
         "${DOCKER_USER}/ubuntu:${LATEST_VERSION}"
    ]
    args = {
        VERSION = "${LATEST_VERSION}"
    }
}

target "18.04" {
    inherits = ["latest"]
    tags = ["${DOCKER_USER}/ubuntu:18.04"]
    args = {
        VERSION = "18.04"
    }
}
