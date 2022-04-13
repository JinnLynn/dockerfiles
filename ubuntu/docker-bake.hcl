variable "DOCKER_USER" {
	default = ""
}
variable "LATEST_VERSION" {
    default = "20.04"
}

group "default" {
    targets = ["latest", "22.04"]
}

target "_base" {
    dockerfile = "Dockerfile"
    platforms = ["linux/amd64", "linux/arm64", "linux/arm/v7"]
    pull = true
}

target "22.04" {
    inherits = ["_base"]
    tags = ["${DOCKER_USER}/ubuntu:22.04"]
    args = {
        VERSION = "22.04"
    }
}

target "20.04" {
    inherits = ["_base"]
    tags = ["${DOCKER_USER}/ubuntu:20.04"]
    args = {
        VERSION = "20.04"
    }
}

target "18.04" {
    inherits = ["_base"]
    tags = ["${DOCKER_USER}/ubuntu:18.04"]
    args = {
        VERSION = "18.04"
    }
}

target "latest" {
    inherits = ["${LATEST_VERSION}"]
	tags = [
         "${DOCKER_USER}/ubuntu",
         "${DOCKER_USER}/ubuntu:${LATEST_VERSION}"
    ]
    args = {
        VERSION = "${LATEST_VERSION}"
    }
}
