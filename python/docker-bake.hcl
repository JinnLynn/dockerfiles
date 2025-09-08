variable "VERSION" { default = "3.13" }
variable "ALPINE_VERSION" { default = "3.22" }
variable "EDGE_VERSION" { default = "3.14-rc" }

variable "MULTI_TARGET" { default = true }

group "default" {
    targets = ["latest", "3_12", "edge"]
}

// ===
// latest
target "3_13" {
    inherits = ["base"]
    tags = genLatestTags("3", "3.13")
    args = {
        VERSION = "3.13"
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

target "3_12" {
    inherits = ["base"]
    tags = genTags("3.12")
    args = {
        VERSION = "3.12"
        ALPINE_VERSION = "${ALPINE_VERSION}"
    }
}

// ===
target "3_11" {
    inherits = ["base"]
    tags = genTags("3.11")
    args = {
        VERSION = "3.11"
        ALPINE_VERSION = "3.20"
    }
}

target "3_10" {
    inherits = ["base"]
    tags = genTags("3.10")
    args = {
        VERSION = "3.10"
        ALPINE_VERSION = "3.20"
    }
}

// NOTO: python2 勿改动
target "2" {
    dockerfile = "2/Dockerfile"
    tags = genTags("2")
}
