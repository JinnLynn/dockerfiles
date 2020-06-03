variable "DOCKER_USER" {
	default = ""
}

group "default" {
    targets = ["py3", "py2"]
}

target "py3" {
	dockerfile = "Dockerfile"
    platforms = ["linux/amd64", "linux/arm64", "linux/arm"]
    pull = true
	tags = [
         "${DOCKER_USER}/flask",
         "${DOCKER_USER}/flask:py3"
    ]
    args = {
        PY_VERSION = "3"
    }
}

target "py2" {
    inherits = ["py3"]
    tags = ["${DOCKER_USER}/flask:py2"]
    args = {
        PY_VERSION = "2"
    }
}
