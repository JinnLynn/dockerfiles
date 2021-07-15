variable "DOCKER_USER" {
	default = ""
}

variable "LATEST_VERSION" {
    default = "3.14"
}

group "default" {
    targets = ["latest", "edge"]
}

target "_base" {
	dockerfile = "Dockerfile"
    pull = true
}

target "edge" {
    inherits = ["_base"]
    tags = ["${DOCKER_USER}/alpine:edge"]
    args = {
        VERSION = "edge"
    }
}

target "3.14" {
    inherits = ["_base"]
    tags = ["${DOCKER_USER}/alpine:3.14"]
    args = {
        VERSION = "3.14"
    }
}

target "3.13" {
    inherits = ["_base"]
    tags = ["${DOCKER_USER}/alpine:3.13"]
    args = {
        VERSION = "3.13"
    }
}

target "3.12" {
    inherits = ["_base"]
    tags = ["${DOCKER_USER}/alpine:3.12"]
    args = {
        VERSION = "3.12"
    }
}

target "3.11" {
    inherits = ["_base"]
    tags = ["${DOCKER_USER}/alpine:3.11"]
    args = {
        VERSION = "3.11"
    }
}

target "3.10" {
    inherits = ["_base"]
    tags = ["${DOCKER_USER}/alpine:3.10"]
    args = {
        VERSION = "3.10"
        MIRROR = "http://dl-cdn.alpinelinux.org/alpine"
    }
}

target "3.9" {
    inherits = ["_base"]
    tags = ["${DOCKER_USER}/alpine:3.9"]
    args = {
        VERSION = "3.9"
    }
}

target "latest" {
    inherits = ["${LATEST_VERSION}"]
	tags = [
        "${DOCKER_USER}/alpine",
        "${DOCKER_USER}/alpine:${LATEST_VERSION}"
    ]
    args = {
        VERSION = "${LATEST_VERSION}"
    }
}
