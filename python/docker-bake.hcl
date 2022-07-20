// =====
variable "BUILD_NAME" { default = "python" }
variable "BUILD_USER" { default = "" }
variable "BUILD_IMAGE" {
    default = trimspace(BUILD_USER) != "" ? "${BUILD_USER}/${BUILD_NAME}" : "${BUILD_NAME}"
}
// =====

variable "LATEST_PYTHON_VERSION" { default="3.10" }

group "default" {
    targets = ["latest"]
}

target "latest" {
	tags = [
        "${BUILD_IMAGE}",
        "${BUILD_IMAGE}:3",
        "${BUILD_IMAGE}:${LATEST_PYTHON_VERSION}"
    ]
}

// ===
target "2" {
    dockerfile = "Dockerfile.2"
    tags = [
        "${BUILD_IMAGE}:2"
    ]
}
