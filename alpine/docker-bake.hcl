// 官方维护4个版本
variable "VERSION" { default = "3.22" }

variable "MULTI_TARGET" { default = true }

// NOTE: SEE target gnu
group "default" {
    targets = ["3_22", "3_21", "3_20", "3_19", "edge"]
}

// ===
// latest
target "3_22" {
    inherits = ["base"]
}

target "3_21" {
    inherits = ["base"]
    tags = genTags("3.21")
    args = {
        VERSION = "3.21"
    }
}

target "3_20" {
    inherits = ["base"]
    tags = genTags("3.20")
    args = {
        VERSION = "3.20"
    }
}

target "3_19" {
    inherits = ["base"]
    tags = genTags("3.19")
    args = {
        VERSION = "3.19"
    }
}

target "3_18" {
    inherits = ["base"]
    tags = genTags("3.18")
    args = {
        VERSION = "3.18"
    }
}

target "edge" {
    inherits = ["base"]
    tags = genTags("edge")
    args = {
        VERSION = "edge"
    }
}

// NOTE: gun 依赖 latest 需push latest后再构建
target "gnu" {
    inherits = ["base"]
    context = "gnu"
    tags = genTags("gnu", "gnu-${VERSION}")
    args = {
        VERSION = "${VERSION}"
    }
}
