variable "DOCKER_USER" { default = "" }

variable "LATEST_VERSION" { default = "3.15" }

group "default" {
    targets = ["latest", "edge"]
}

target "latest" {
    inherits = ["base"]
	tags = [
        "${DOCKER_USER}/alpine",
        "${DOCKER_USER}/alpine:${LATEST_VERSION}"
    ]
    args = {
        VERSION = "${LATEST_VERSION}"
    }
}

target "edge" {
    inherits = ["base"]
    tags = ["${DOCKER_USER}/alpine:edge"]
    args = {
        VERSION = "edge"
    }
}

// =====
target "base" {
	dockerfile = "Dockerfile"
    pull = true
    tags = ["${DOCKER_USER}/alpine:${LATEST_VERSION}"]
    args = {
        VERSION = "${LATEST_VERSION}"
    }
}
