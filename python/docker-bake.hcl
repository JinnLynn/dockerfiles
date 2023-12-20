
// 从Alpine软件库直接安装，因此两者版本需匹配
// Alpine       Python
// 3.13     =>  3.8
// 3.17     =>  3.10
// 3.19     =>  3.11
// edge     =>  3.11

// 当前
// latest => 3.11

group "default" {
    targets = ["latest", "3_10"]
}

target "latest" {
    inherits = ["3_11"]
	tags = genLatestTags("3", "3.11")
}

// ===
target "3_11" {
    inherits = ["base"]
    tags = genTags("3.11")
    args = {
        ALPINE_VERSION = "3.19"
        MIRROR = "https://pypi.tuna.tsinghua.edu.cn/simple"
    }
}

target "3_10" {
    inherits = ["base"]
    tags = genTags("3.10")
    args = {
        ALPINE_VERSION = "3.17"
        MIRROR = "https://pypi.tuna.tsinghua.edu.cn/simple"
    }
}

target "3_8" {
    inherits = ["base"]
    tags = genTags("3.8")
    args = {
        ALPINE_VERSION = "3.13"
    }
}

// ===
target "2" {
    dockerfile = "Dockerfile.2"
    tags = genTags("2")
}
