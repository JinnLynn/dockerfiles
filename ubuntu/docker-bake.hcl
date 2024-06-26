variable "VERSION" { default = "24.04" }

variable "MULTI_TARGET" { default = true }
# ubuntu 官方镜像没有 linux/arm/v6 架构
variable "PLATFORM" {
    default = "linux/amd64,linux/arm64,linux/arm/v7"
}

group "default" {
    targets = ["24_04", "22_04", "20_04", "edge"]
}

// =====
// latest
target "24_04" {
    inherits = ["base"]
    args = {
        VERSION = "24.04"
    }
}

target "22_04" {
    inherits = ["base"]
    tags = genTags("22.04")
    args = {
        VERSION = "22.04"
    }
}

target "20_04" {
    inherits = ["base"]
    tags = genTags("20.04")
    args = {
        VERSION = "20.04"
    }
}

target "edge" {
    inherits = ["base"]
    tags = genTags("edge")
    args = {
        VERSION = "rolling"
    }
}
