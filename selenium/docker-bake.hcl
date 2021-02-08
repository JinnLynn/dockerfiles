variable "DOCKER_USER" {
	default = ""
}

group "default" {
    targets = ["latest"]
}

target "latest" {
	dockerfile = "Dockerfile"
    platforms = ["linux/amd64", "linux/arm64"]
    pull = true
	tags = [
         "${DOCKER_USER}/selenium",
         "${DOCKER_USER}/selenium:py3"
    ]
    // args = {
    //     PY_VERSION = "3"
    // }
}
