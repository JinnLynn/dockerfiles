// =====
variable "BUILD_NAME" { default = "v2ray" }
variable "BUILD_USER" { default = "" }
variable "BUILD_IMAGE" {
    default = trimspace(BUILD_USER) != "" ? "${BUILD_USER}/${BUILD_NAME}" : "${BUILD_NAME}"
}

// =====
variable "LATEST_VERSION" { default = "5.1.0" }

group "default" {
    targets = ["latest"]
}

target "latest" {
    tags = [
        "${BUILD_IMAGE}",
        "${BUILD_IMAGE}:5",
        "${BUILD_IMAGE}:${LATEST_VERSION}"
    ]
    args = {
        VERSION = "${LATEST_VERSION}"
    }
}
