variable "VERSION" { default = "24.04" }

# ubuntu 官方镜像没有 linux/arm/v6 架构
variable "PLATFORM" {
    default = "linux/amd64,linux/arm64,linux/arm/v7"
}

group "default" {
    targets = ["latest", "20_04", "22_04"]
}

target "latest" {
    inherits = ["base"]
    args = {
        VERSION = "${VERSION}"
    }
}
// =====

target "20_04" {
    inherits = ["base"]
    tags = genTags("20.04")
    args = {
        VERSION = "20.04"
    }
}

target "22_04" {
    inherits = ["base"]
    tags = genTags("22.04")
    args = {
        VERSION = "22.04"
    }
}
