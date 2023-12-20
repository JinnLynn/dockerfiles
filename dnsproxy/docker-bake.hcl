variable "VERSION" { default="0.61.0" }

target "default" {
    inherits = ["base"]
    args = {
        VERSION = "${VERSION}"
    }
}
