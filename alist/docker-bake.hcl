// alist
// https://github.com/alist-org/alist
variable "VERSION" { default = "3.35.0" }

// alist-proxy
// https://github.com/alist-org/alist-proxy
variable "PROXY_VERSION" { default = "0.0.6" }

target "default" {
    inherits = ["base"]
}

target "proxy" {
    dockerfile = "proxy.Dockerfile"
    tags = latestImages("alist-proxy", PROXY_VERSION)
    args = {
        VERSION = "${PROXY_VERSION}"
    }
    platforms = [
        "linux/amd64",
        "linux/arm64"
    ]
}
