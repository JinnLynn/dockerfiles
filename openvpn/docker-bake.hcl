// =====
variable "BUILD_NAME" { default = "openvpn" }
variable "BUILD_USER" { default = "" }
variable "BUILD_IMAGE" {
    default = trimspace(BUILD_USER) != "" ? "${BUILD_USER}/${BUILD_NAME}" : "${BUILD_NAME}"
}
// =====

variable "CURRENT_OPENVPN_VERSION" { default="2.5" }

group "default" {
    targets = ["latest"]
}

target "latest" {
	tags = [
        "${BUILD_IMAGE}",
        "${BUILD_IMAGE}:${CURRENT_OPENVPN_VERSION}"
    ]
}
