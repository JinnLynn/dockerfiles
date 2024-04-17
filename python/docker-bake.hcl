variable "ALPINE_VERSION" { default="3.19" }

group "default" {
    targets = ["latest", "3_11", "3_10"]
}

target "latest" {
    inherits = ["3_12"]
	tags = genLatestTags("3", "3.12")
}

// ===
target "3_12" {
    inherits = ["_base"]
    tags = genTags("3.12")
    args = {
        PYTHON_VERSION = "3.12"
    }
}

target "3_11" {
    inherits = ["_base"]
    tags = genTags("3.11")
    args = {
        PYTHON_VERSION = "3.11"
    }
}

target "3_10" {
    inherits = ["_base"]
    tags = genTags("3.10")
    args = {
        PYTHON_VERSION = "3.10"
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
