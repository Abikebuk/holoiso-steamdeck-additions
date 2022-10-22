#!/bin/sh

if (( $EUID != 0 )); then
    echo "Please run as root"
    exit
fi

if [ $# -eq 0 ] ; then
  PACKAGES="xf86-video-amdgpu"
  pacman -S "$PACKAGES" --noconfirm
  rsync -avh ./lib/firmware/* /lib/firmware/
  exit
fi
case $1 in
  "theme")
  PACKAGES="kvantum latte-dock"
  git clone https://github.com/vinceliuice/WhiteSur-kde.git
  WhiteSur-kde/install.sh
  pacman -S "$PACKAGES" --noconfirm
  ;;
  "ssh")
  systemctl enable --now sshd.service
  ;;
esac
shift 1
./install.sh "$@"
echo "Installation complete!"
