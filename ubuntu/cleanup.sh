#!/usr/bin/env bash
apt-get autoremove -qy
apt-get clean -qy
rm -rf /var/lib/apt
rm -rf /tmp/*
