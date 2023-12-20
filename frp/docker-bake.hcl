variable "VERSION" { default="0.53.0" }

target "default" {
    inherits = ["base"]
    args = {
        VERSION = "${VERSION}"
    }
}
