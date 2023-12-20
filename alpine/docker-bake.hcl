
variable "VERSION" { default = "3.19" }

// NOTE: SEE target gnu
group "default" {
    targets = ["latest", "edge", "3_18", "3_17", "gnu"]
}

target "latest" {
    inherits = ["3_19", "base"]
}

target "edge" {
    inherits = ["base"]
    tags = genTags("edge")
    args = {
        VERSION = "edge"
    }
}

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

target "3_16" {
    inherits = ["base"]
    tags = genTags("3.16")
    args = {
        VERSION = "3.16"
    }
}

// python2 3.15后被删除
target "3_15" {
    inherits = ["base"]
    tags = genTags("3.15")
    dockerfile = "Dockerfile.3.15"
    args = {
        VERSION = "3.15"
    }
}
