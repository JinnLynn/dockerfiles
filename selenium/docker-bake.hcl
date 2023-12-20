group "default" {
    targets = ["latest"]
}

target "latest" {
    inherits = ["base"]
	tags = [
        "${latestTag()}",
        "${genTag("py3")}"
    ]
    args = {
        PY_VERSION = "3"
    }
}

target "py2" {
	tags = [
        "${genTag("py2")}"
    ]
    args = {
        PY_VERSION = "2"
    }
}


