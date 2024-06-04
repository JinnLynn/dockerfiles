variable "ALPINE_VERSION" { default = "3.19" }
variable "VERSION" { default = "20" }

variable "PLATFORM" {
    default = "linux/amd64,linux/arm64"
}

group "default" {
    targets = ["latest", "edge", "18"]
}

target "latest" {
    inherits = ["${VERSION}"]
	tags = genLatestTags("20")
}


target "edge" {
    inherits = ["base"]
    tags = genTags("edge")
    args = {
        ALPINE_VERSION = "${ALPINE_VERSION}"
        VERSION = "current"
    }
}

// ===
target "18" {
    inherits = ["base"]
    tags = genTags("18")
    args = {
        ALPINE_VERSION = "${ALPINE_VERSION}"
        VERSION = "18"
    }
}

target "20" {
    inherits = ["base"]
    tags = genTags("20")
    args = {
        ALPINE_VERSION = "${ALPINE_VERSION}"
        VERSION = "20"
    }
}
