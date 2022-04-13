variable "DOCKER_USER" {
	default = ""
}

group "default" {
    targets = ["latest"]
}

target "latest" {
    dockerfile = "Dockerfile"
	tags = [
        "${DOCKER_USER}/selenium",
        "${DOCKER_USER}/selenium:py3"
    ]
    args = {
        PY_VERSION = "3"
    }
}

target "py2" {
	dockerfile = "Dockerfile"
	tags = [
        "${DOCKER_USER}/selenium:py2"
    ]
    args = {
        PY_VERSION = "2"
    }
}


