// =====
variable "BUILD_NAME" { default = "selenium" }
variable "BUILD_USER" { default = "" }
variable "BUILD_IMAGE" {
    default = trimspace(BUILD_USER) != "" ? "${BUILD_USER}/${BUILD_NAME}" : "${BUILD_NAME}"
}
// =====

group "default" {
    targets = ["latest"]
}

target "latest" {
	tags = [
        "${BUILD_IMAGE}",
        "${BUILD_IMAGE}:py3"
    ]
    args = {
        PY_VERSION = "3"
    }
}

target "py2" {
	tags = [
        "${BUILD_IMAGE}:py2"
    ]
    args = {
        PY_VERSION = "2"
    }
}


