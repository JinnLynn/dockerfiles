variable "VERSION" { default = "3.13" }
variable "ALPINE_VERSION" { default = "3.22" }
variable "EDGE_VERSION" { default = "3.14-rc" }

variable "MULTI_TARGET" { default = true }

group "default" {
    targets = ["latest", "3_12", "edge"]
}

// ===
// latest
target "3_13" {
    inherits = ["base"]
    tags = genLatestTags("3", "3.13")
    args = {
        VERSION = "3.13"
        ALPINE_VERSION = "${ALPINE_VERSION}"
    }
}

target "3_12" {
    inherits = ["base"]
    tags = genTags("3.12")
    args = {
        VERSION = "3.12"
        ALPINE_VERSION = "${ALPINE_VERSION}"
    }
}

target "edge" {
    inherits = ["base"]
    tags = genTags("edge")
    args = {
        VERSION = "${EDGE_VERSION}"
        ALPINE_VERSION = "${ALPINE_VERSION}"
    }
}

// ===
target "3_11" {
    inherits = ["base"]
    tags = genTags("3.11")
    args = {
        VERSION = "3.11"
        ALPINE_VERSION = "3.20"
    }
}

target "3_10" {
    inherits = ["base"]
    tags = genTags("3.10")
    args = {
        VERSION = "3.10"
        ALPINE_VERSION = "3.20"
    }
}

// NOTO: python2 勿改动
# alpine 3.15后才没有python2 但3.10后很多包没有预编译
// pip最后支持python2的版本时20.3.4
// REF: https://pip.pypa.io/en/latest/development/release-process/#python-2-support
target "2" {
    tags = genTags("2")
    dockerfile-inline = <<EOF
        FROM jinnlynn/alpine:3.10
        LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"
        ENV PIP_INDEX_URL="https://pypi.doubanio.com/simple/"
        RUN set -ex && apk add --no-cache python2 && wget -O- https://github.com/pypa/get-pip/raw/refs/tags/20.3.4/get-pip.py | python - --disable-pip-version-check --no-cache-dir
        CMD ["python"]
    EOF
}
