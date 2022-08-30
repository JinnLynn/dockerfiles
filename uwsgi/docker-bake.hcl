// =====
variable "BUILD_NAME" { default = "uwsgi" }
variable "BUILD_USER" { default = "" }
variable "BUILD_IMAGE" {
    default = trimspace(BUILD_USER) != "" ? "${BUILD_USER}/${BUILD_NAME}" : "${BUILD_NAME}"
}
// =====


group "default" {
    targets = ["latest"]
}

target "latest" {
    dockerfile = "Dockerfile"
	tags = [
        "${BUILD_IMAGE}",
        "${BUILD_IMAGE}:py3"
    ]
}

target "py2" {
    context = "py2"
    dockerfile = "Dockerfile"
    tags = [
        "${BUILD_IMAGE}:py2"
    ]
}
