variable "VERSION" { default = "3.0.0" }

variable "PLATFORM" {
    default = "linux/amd64"
}

group "default" {
    targets = ["3"]
}

// =====
// latest
target "3" {
    inherits = ["base"]
    tags = genLatestTags("3", VERSION)
    args = {
        VERSION = "${VERSION}"
    }
}
