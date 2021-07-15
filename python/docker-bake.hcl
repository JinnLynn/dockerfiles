variable "DOCKER_USER" {
	default = ""
}

group "default" {
    targets = ["latest"]
}

target "latest" {
	dockerfile = "Dockerfile"
	tags = [
         "${DOCKER_USER}/python",
         "${DOCKER_USER}/python:3"
    ]
}

target "2" {
    dockerfile = "Dockerfile.2"
    tags = [
        "${DOCKER_USER}/python:2"
    ]
}
