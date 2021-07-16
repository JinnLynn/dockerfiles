variable "DOCKER_USER" {
	default = ""
}

group "default" {
    targets = ["latest"]
}

target "latest" {
    dockerfile = "Dockerfile"
	tags = [
        "${DOCKER_USER}/flask",
        "${DOCKER_USER}/flask:py3",
        "${DOCKER_USER}/flask:2"
    ]
    args = {
        PY_VERSION = "3"
    }
}

target "v1" {
    dockerfile = "Dockerfile"
    tags = [
        "${DOCKER_USER}/flask:1"
    ]
    args = {
        PY_VERSION = "3"
        VERSION = "1.1.4"
    }
}

// 只用1.x.x支持python2
target "py2" {
    dockerfile = "Dockerfile"
    tags = [
        "${DOCKER_USER}/flask:py2"
    ]
    args = {
        PY_VERSION = "2"
        VERSION = "1.1.4"
    }
}
