// =====
// ../build 命令会自动设置的变量
// 其它一般情况下不需要改变设置
// 但为了避免直接使用`docker buildx bake`使用该文件时出现异常，BUILD_NAM能有可用的默认值
variable "BUILD_NAME" { default = "alpine" }
variable "BUILD_USER" { default = "" }
variable "BUILD_IMAGE" {
    default = trimspace(BUILD_USER) != "" ? "${BUILD_USER}/${BUILD_NAME}" : "${BUILD_NAME}"
}

// =====
variable "LATEST_VERSION" { default = "3.16" }

group "default" {
    targets = ["latest", "edge", "3_15"]
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

target "edge" {
    tags = [
        "${BUILD_IMAGE}:edge"
    ]
    args = {
        VERSION = "edge"
    }
}

target "gnu" {
    context = "gnu"
    tags = [
        "${BUILD_IMAGE}:gnu"
    ]
}

// ===
target "3_15" {
    tags = [
        "${BUILD_IMAGE}:3.15"
    ]
    dockerfile = "Dockerfile.3.15"
    args = {
        VERSION = "3.15"
    }
}
