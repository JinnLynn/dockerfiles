variable "VERSION" { default="3.12" }
variable "EDGE_VERSION" { default="3.13-rc" }
variable "ALPINE_VERSION" { default="3.19" } // NOTE: 3.20的还没有armv6 armv7架构 WHY?

group "default" {
    targets = ["latest", "edge", "3_11", "3_10"]
}

target "latest" {
    inherits = ["base"]
    tags = genLatestTags("3", "${VERSION}")
    args = {
        VERSION = "${VERSION}"
        ALPINE_VERSION = "${ALPINE_VERSION}"
    }
}

target "edge" {
    inherits = ["_base"]
    tags = genTags("edge")
    args = {
        VERSION = "${EDGE_VERSION}"
    }
}

// ===
target "3_11" {
    inherits = ["_base"]
    tags = genTags("3.11")
    args = {
        VERSION = "3.11"
    }
}

target "3_10" {
    inherits = ["_base"]
    tags = genTags("3.10")
    args = {
        VERSION = "3.10"
    }
}

// ===
target "_base" {
    inherits = ["base"]
    args = {
        ALPINE_VERSION = "${ALPINE_VERSION}"
    }
}

// ===
target "2" {
    dockerfile = "2/Dockerfile"
    tags = genTags("2")
}
