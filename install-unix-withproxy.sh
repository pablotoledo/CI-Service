#!/bin/bash
HTTP_PROXY="http://proxy:port" \
HTTPS_PROXY="http://proxy:port" \
VAGRANT_HTTP_PROXY="http://proxy:port" \
VAGRANT_HTTPS_PROXY="http://proxy:port" \
vagrant plugin install vagrant-proxyconf
vagrant up