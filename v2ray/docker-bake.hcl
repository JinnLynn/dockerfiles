variable "VERSION" { default = "5.15.0" }

target "default" {
    inherits = ["base"]
    args = {
        VERSION = "${VERSION}"
    }
}
