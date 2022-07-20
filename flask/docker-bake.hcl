// =====
variable "BUILD_NAME" { default = "flask" }
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
        "${BUILD_IMAGE}:py3",
        "${BUILD_IMAGE}:2"
    ]
    args = {
        PY_VERSION = "3"
    }
}

target "v1" {
    dockerfile = "Dockerfile"
    tags = [
        "${BUILD_IMAGE}:1"
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
        "${BUILD_IMAGE}:py2"
    ]
    args = {
        PY_VERSION = "2"
        VERSION = "1.1.4"
    }
}
