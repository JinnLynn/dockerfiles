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

function "_v_fmt" {
    params = [fmt, value]
    result = value != "" ? format(fmt, value) : ""
}

function "genImage" {
    params = [img, ver]
    result = "${_v_fmt("%s/", BUILD_USER)}${img}${_v_fmt(":%s", ver)}"
}

function "latestImage" {
    params = [img]
    result = genImage(img, "")
}

function "latestImages" {
    params = [img]
    variadic_params = vers
    result = concat([latestImage(img)], [for v in vers: genImage(img, v) if v != ""])
}

function "_gen_tags" {
    params = [items]
    result = formatlist("${BUILD_IMAGE}:%s", [for s in items : s if s != ""])
}

function "genTags" {
    params          = []
    variadic_params = items
    result          = _gen_tags(items)
}

function "genLatestTags" {
    params          = []
    variadic_params = items
    result          = concat([BUILD_IMAGE], _gen_tags(items))
}

function "defaultPlatforms" {
    params = []
    result = split(",", BUILD_PLATFORM)
}

function "genPlatforms" {
    params = [plats]
    result = split(",", plats != "" ? plats : BUILD_PLATFORM)
}

function "validTargetName" {
    params = [str]
    result = replace(str, ".", "_")
}

// ===
target "base" {
    tags = genLatestTags(VERSION)
    platforms = genPlatforms(PLATFORM)
    args = VERSION != "" ? { VERSION = "${VERSION}" } : {}
}

// 只是一个别名
// 当 MULTI_TARGET==false 继承自 default
// 当 MULTI_TARGET==true 且 VERSION 存在 继承自 VERSION TARGET (将版本号的.改为_)
// 否则 继承自 base
target "latest" {
    inherits = [MULTI_TARGET ? (VERSION != "" ? validTargetName(VERSION) : "base") : "default"]
}
