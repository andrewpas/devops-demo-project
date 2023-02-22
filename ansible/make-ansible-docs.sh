#!/bin/sh
echo "Create documentation for Ansible role"
ansible-autodoc -C ./autodoc.conf.yaml
