variable "VERSION" { default="3.12" }
variable "EDGE_VERSION" { default="3.13-rc" }
variable "ALPINE_VERSION" { default="3.19" } // NOTE: 3.20的还没有armv6 armv7架构 WHY?

variable "MULTI_TARGET" { default = true }

group "default" {
    targets = ["3_12", "3_11", "3_10", "edge"]
}

// ===
// latest
target "3_12" {
    inherits = ["base"]
    tags = genLatestTags("3", "${VERSION}")
    args = {
        VERSION = "${VERSION}"
        ALPINE_VERSION = "${ALPINE_VERSION}"
    }
}

target "3_11" {
    inherits = ["base"]
    tags = genTags("3.11")
    args = {
        VERSION = "3.11"
        ALPINE_VERSION = "${ALPINE_VERSION}"
    }
}

target "3_10" {
    inherits = ["base"]
    tags = genTags("3.10")
    args = {
        VERSION = "3.10"
        ALPINE_VERSION = "${ALPINE_VERSION}"
    }
}

target "edge" {
    inherits = ["base"]
    tags = genTags("edge")
    args = {
        VERSION = "${EDGE_VERSION}"
        ALPINE_VERSION = "${ALPINE_VERSION}"
    }
}

// NOTO: python2 勿改动
target "2" {
    dockerfile = "2/Dockerfile"
    tags = genTags("2")
}
