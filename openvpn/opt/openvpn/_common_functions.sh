print_info() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') $@" 1>&2
}

# $1 CONFIG_NAME ENV prefix
multi_config() {
    set | \
        awk '/^'$1'[0-9_]*=/ {sub (/^[^=]*=/, "", $0); print}' | \
        sed "s/^['\"]//; s/['\"]$//g"
}

# Convert 1.2.3.4/24 -> 255.255.255.0
cidr2mask()
{
    local i
    local subnetmask=""
    local cidr=${1#*/}
    local full_octets=$(($cidr/8))
    local partial_octet=$(($cidr%8))

    for ((i=0;i<4;i+=1)); do
        if [ $i -lt $full_octets ]; then
            subnetmask+=255
        elif [ $i -eq $full_octets ]; then
            subnetmask+=$((256 - 2**(8-$partial_octet)))
        else
            subnetmask+=0
        fi
        [ $i -lt 3 ] && subnetmask+=.
    done
    echo $subnetmask
}


trim() {
    echo $@ | xargs
}


# $1=1 $2=foo => "foo"
# $1= $2=foo => ""
cfg_on() {
    [[ "$1" != "1" ]] && return
    echo "$2" | xargs
}

# $1=bar $2=foo => "foo bar"
# $1=bar $2==> "bar"
# $1= $2=foo => ""
cfg_value() {
    [[ -z "$1" ]] && return
    echo "$2 $1" | xargs
}

cfg_info() {
    local info="$@"
    echo -en "\n${info:+# $info\n}"
}

# REF: https://stackoverflow.com/a/14525326
is_array() {
    declare -p "$1" 2>/dev/null | grep -q "^declare \-a"
}

is_array_empty() {
    is_array $1 && [[ $(eval "echo \${#${1}[@]}") -le 0 ]]
}
