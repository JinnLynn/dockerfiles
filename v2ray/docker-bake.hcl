variable "VERSION" { default = "5.7.0" }

target "default" {
    inherits = ["base"]
    args = {
        VERSION = "${VERSION}"
    }
}
