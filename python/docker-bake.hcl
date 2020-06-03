variable "DOCKER_USER" {
	default = ""
}

group "default" {
    targets = ["latest", "2"]
}

target "latest" {
	dockerfile = "Dockerfile"
    platforms = ["linux/amd64", "linux/arm64", "linux/arm"]
	tags = [
         "${DOCKER_USER}/python",
         "${DOCKER_USER}/python:3"
    ]
    args = {
        VERSION = "3"
    }
}

target "2" {
    inherits = ["latest"]
    tags = ["${DOCKER_USER}/python:2"]
    args = {
        VERSION = "2"
        ALPINE_VERSION="3.10" # alpine 3.10后 python2不再被支持 很多包没有
    }
}
