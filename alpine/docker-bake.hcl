variable "DOCKER_USER" {
	default = ""
}
# ["linux/amd64", "linux/arm64", "linux/arm"]
variable "LATEST_VERSION" {
    default = "3.11"
}

group "default" {
    targets = ["latest", "edge"]
}

target "latest" {
	dockerfile = "Dockerfile"
    platforms = ["linux/amd64", "linux/arm64", "linux/arm"]
    pull = true
	tags = [
         "${DOCKER_USER}/alpine",
         "${DOCKER_USER}/alpine:${LATEST_VERSION}"
    ]
    args = {
        VERSION = "${LATEST_VERSION}"
    }
}

target "edge" {
    inherits = ["latest"]
    tags = ["${DOCKER_USER}/alpine:edge"]
    args = {
        VERSION = "edge"
    }
}

target "3.10" {
    inherits = ["latest"]
    tags = ["${DOCKER_USER}/alpine:3.10"]
    args = {
        VERSION = "3.10"
    }
}

target "3.9" {
    inherits = ["latest"]
    tags = ["${DOCKER_USER}/alpine:3.9"]
    args = {
        VERSION = "3.9"
    }
}
