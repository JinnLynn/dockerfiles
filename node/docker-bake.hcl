variable "PLATFORM" {
    default = "linux/amd64,linux/arm64"
}

group "default" {
    targets = ["latest", "current", "18"]
}

target "latest" {
    inherits = ["20"]
	tags = genLatestTags("20")
}

target "current" {
    inherits = ["base"]
    tags = genTags("current")
    args = {
        ALPINE_VERSION = "3.19"
        NODEJS_VERSION = "current"
    }
}

// ===
target "18" {
    inherits = ["base"]
    tags = genTags("18")
    args = {
        ALPINE_VERSION = "3.19"
        NODEJS_VERSION = "18"
    }
}

target "20" {
    inherits = ["base"]
    tags = genTags("20")
    args = {
        ALPINE_VERSION = "3.19"
        NODEJS_VERSION = "20"
    }
}
