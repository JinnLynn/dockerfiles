group "default" {
    targets = ["py3_13", "py3_12"]
}

//
variable "PLATFORM" {
    default = "linux/amd64,linux/arm64"
}

// ===
// latest
target "py3_13" {
    inherits = ["base"]
    tags = genLatestTags("py3.13", "py3")
    args = {
        PYTHON_VERSION = "3.13"
    }
}

target "py3_12" {
    inherits = ["base"]
    tags = genTags("py3.12")
    args = {
        PYTHON_VERSION = "3.12"
    }
}

