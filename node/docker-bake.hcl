variable "ALPINE_VERSION" { default = "3.19" }
variable "VERSION" { default = "20" }

variable "MULTI_TARGET" { default = true }
variable "PLATFORM" {
    default = "linux/amd64,linux/arm64"
}

group "default" {
    targets = ["20", "18", "edge"]
}

// ===
// latest
target "20" {
    inherits = ["base"]
    args = {
        ALPINE_VERSION = "${ALPINE_VERSION}"
        VERSION = "20"
    }
}

target "18" {
    inherits = ["base"]
    tags = genTags("18")
    args = {
        ALPINE_VERSION = "${ALPINE_VERSION}"
        VERSION = "18"
    }
}

target "edge" {
    inherits = ["base"]
    tags = genTags("edge")
    args = {
        ALPINE_VERSION = "${ALPINE_VERSION}"
        VERSION = "current"
    }
}
