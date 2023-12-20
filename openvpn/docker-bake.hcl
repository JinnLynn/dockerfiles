// 从Alpine软件库直接安装，因此两者版本需匹配
// Alpine       OpenVPN
// 3.17     =>  2.5
target "default" {
    inherits = ["base"]
	tags = [
        "${latestTag()}",
        "${genTag("2.5")}"
    ]
    args = {
        ALPINE_VERSION = "3.17"
    }
}
