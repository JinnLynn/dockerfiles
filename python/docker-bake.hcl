variable "DOCKER_USER" {
	default = ""
}

group "default" {
    targets = ["latest"]
}

target "latest" {
	dockerfile = "Dockerfile"
    platforms = ["linux/amd64", "linux/arm64", "linux/arm"]
    pull = true
	tags = [
         "${DOCKER_USER}/python",
         "${DOCKER_USER}/python:3"
    ]
}
