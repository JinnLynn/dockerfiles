// 从Alpine软件库直接安装，因此两者版本需匹配
// Alpine       OpenVPN
// 3.17     =>  2.5
// 3.20     =>  2.6.10+
variable "VERSION" { default = "2.6" }
variable "ALPINE_VERSION" { default = "3.20" }

target "default" {
    inherits = ["base"]
    args = {
        ALPINE_VERSION = "${ALPINE_VERSION}"
    }
}
