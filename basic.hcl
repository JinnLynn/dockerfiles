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
variable "VERSION" { default = "" }
variable "PLATFORM" { default = "" }

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

// ===
target "base" {
    tags = genLatestTags(VERSION)
    platforms = genPlatforms(PLATFORM)
}
