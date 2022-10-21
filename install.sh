#!/bin/sh

PACKAGES="\
xf86-video-amdgpu \
"
sudo echo ""
pacman -S "$PACKAGES" --noconfirm
rsync -avh ./lib/firmware/* /lib/firmware/