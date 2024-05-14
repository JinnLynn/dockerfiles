
variable "VERSION" { default = "3.19" }

// NOTE: SEE target gnu
group "default" {
    targets = ["latest", "edge", "3_18", "3_17"]
}

target "latest" {
    inherits = ["3_19", "base"]
}

// NOTE: gun 依赖 latest 需push latest后再构建
target "gnu" {
    inherits = ["base"]
    context = "gnu"
    tags = genTags("gnu")
    args = {
        VERSION = "${VERSION}"
    }
}

// ===
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

target "3_17" {
    inherits = ["base"]
    tags = genTags("3.17")
    args = {
        VERSION = "3.17"
    }
}

target "edge" {
    inherits = ["base"]
    tags = genTags("edge")
    args = {
        VERSION = "edge"
    }
}
