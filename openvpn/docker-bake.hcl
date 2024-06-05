// 从Alpine软件库直接安装，因此两者版本需匹配
// Alpine       OpenVPN
// 3.17     =>  2.5
variable "VERSION" { default = "2.5" }
variable "ALPINE_VERSION" { default = "3.17" }

target "default" {
    inherits = ["base"]
    args = {
        ALPINE_VERSION = "3.17"
    }
}
