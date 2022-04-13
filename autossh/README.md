## autossh

### ssh-agent 使用

docker run --rm -it \
    -v /run/host-services/ssh-auth.sock:/ssh-agent \
    -e SSH_AUTH_SOCK="/ssh-agent" \
    jinnlynn/autossh

REF: https://stackoverflow.com/questions/27036936/using-ssh-agent-with-docker-on-macos/60713369#comment122113570_60713369
