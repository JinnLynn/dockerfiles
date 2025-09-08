
group "default" {
    targets = ["latest", "ubuntu"]
}

// =====
// latest
target "default" {
    inherits = ["base"]
    args = {
        BASE_IMAGE = "jinnlynn/alpine"
    }
    tags = genLatestTags("alpine")
}

target "ubuntu" {
    inherits = ["base"]
    args = {
        BASE_IMAGE = "jinnlynn/ubuntu"
    }
    tags = genTags("ubuntu")
    platforms = [ "linux/amd64", "linux/arm64", "linux/arm/v7" ]
}

