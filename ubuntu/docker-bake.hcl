variable "BUILD_NAME" { default = "ubuntu" }
variable "BUILD_USER" { default = "" }
variable "BUILD_IMAGE" {
    default = trimspace(BUILD_USER) != "" ? "${BUILD_USER}/${BUILD_NAME}" : "${BUILD_NAME}"
}
// =====

variable "LATEST_VERSION" {
    default = "22.04"
}

group "default" {
    targets = ["latest"]
}

target "latest" {
    tags = [
        "${BUILD_IMAGE}",
        "${BUILD_IMAGE}:${LATEST_VERSION}"
    ]
    args = {
        VERSION = "${LATEST_VERSION}"
    }
}
// =====

target "20_04" {
    tags = [
        "${BUILD_IMAGE}:20.04"
    ]
    args = {
        VERSION = "20.04"
    }
}
