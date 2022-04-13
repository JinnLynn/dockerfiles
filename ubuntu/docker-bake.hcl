variable "DOCKER_USER" {
	default = ""
}
variable "LATEST_VERSION" {
    default = "20.04"
}

group "default" {
    targets = ["latest", "22_04"]
}

// =====
target "base" {
    dockerfile = "Dockerfile"
    platforms = ["linux/amd64", "linux/arm64", "linux/arm/v7"]
    pull = true
    tags = [
        "${DOCKER_USER}/ubuntu:${LATEST_VERSION}"
    ]
    args = {
        VERSION = "${LATEST_VERSION}"
    }
}

target "latest" {
    inherits = ["base"]
    tags = [
        "${DOCKER_USER}/ubuntu",
        "${DOCKER_USER}/ubuntu:${LATEST_VERSION}"
    ]
    args = {
        VERSION = "${LATEST_VERSION}"
    }
}
// =====

target "22_04" {
    inherits = ["base"]
    tags = ["${DOCKER_USER}/ubuntu:22.04"]
    args = {
        VERSION = "22.04"
    }
}
