// ../build 命令会自动设置的变量
variable "BUILD_USER" { default = "" }
variable "BUILD_NAME" { default = "" }
variable "BUILD_IMAGE" {
    default = notequal("", BUILD_USER) ? "${BUILD_USER}/${BUILD_NAME}" : "${BUILD_NAME}"
}
variable "BUILD_PLATFORM" {
    default = "linux/amd64,linux/arm64,linux/arm/v7,linux/arm/v6"
}
// ===

// 相应的hcl文件可重写
// 最新的版本 image:latest安装的版本
variable "VERSION" { default = "" }
// 多架构平台使用的平台 不设置默认为 BUILD_PLATFORM
variable "PLATFORM" { default = "" }
variable "USE_DEFAULT_TARGET" { default = false }
variable "MULTI_TARGET" { default = false }

function "genImage" {
    params = [img, ver]
    result = "${notequal("", BUILD_USER) ? "${BUILD_USER}/": ""}${img}${notequal("", ver) ? ":${ver}": ""}"
}

function "latestImage" {
    params = [img]
    result = "${genImage(img, "")}"
}

function "latestImages" {
    params = [img, ver]
    result = [
        "${latestImage(img)}",
        "${genImage(img, ver)}"
    ]
}

function "testFunc" {
    params         = []
    variadic_params = items
    result = split(",", "${BUILD_IMAGE}:${join(",${BUILD_IMAGE}:", concat(["latest"], items))}")
}

function "_gen_tags" {
    params = [items]
    result = length(items) != 0 ? split(",", "${BUILD_IMAGE}:${join(",${BUILD_IMAGE}:", items)}") : [] #! 待优化
}

function "genTags" {
    params          = []
    variadic_params = items
    result          = _gen_tags(items)
}

function "genLatestTags" {
    params          = []
    variadic_params = items
    result          = concat(["${BUILD_IMAGE}"], _gen_tags(items))
}

// // 待删除
// function "genTag" {
//     params = [ver]
//     result = "${BUILD_IMAGE}:${ver}"
// }

// // 待删除
// function "latestTag" {
//     params = []
//     result = "${BUILD_IMAGE}"
// }

// // 待删除
// function "latestTags" {
//     params = [ver]
//     result = ver == null ? ["${latestTag()}", "${genTag(ver)}"] : ["${latestTag()}"]
// }

function "defaultPlatforms" {
    params = []
    result = split(",", BUILD_PLATFORM)
}

function "genPlatforms" {
    params = [plats]
    result = notequal("", plats) ? split(",", plats) : split(",", BUILD_PLATFORM)
}

function "validTargetName" {
    params = [str]
    result = replace(str, ".", "_")
}

// ===
target "base" {
    tags = genLatestTags(VERSION)
    platforms = genPlatforms(PLATFORM)
    args = notequal("", VERSION) ? { VERSION = "${VERSION}" } : {}
}

// 只是一个别名
// 当 MULTI_TARGET==false 继承自 default
// 当 MULTI_TARGET==true 且 VERSION 存在 继承自 VERSION TARGET (将版本号的.改为_)
// 否则 继承自 base
target "latest" {
    inherits = [MULTI_TARGET ? (notequal("", VERSION) ? validTargetName(VERSION) : "base") : "default"]
}
