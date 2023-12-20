variable "VERSION" { default="0.52.3" }

target "default" {
    inherits = ["base"]
    args = {
        VERSION = "${VERSION}"
    }
}
