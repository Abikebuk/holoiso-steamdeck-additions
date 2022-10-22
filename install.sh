#!/bin/sh

if (( $EUID != 0 )); then
    echo "Please run as root"
    exit
fi

if [ $# -eq 0 ] ; then
  echo "Installation complete!"
  exit
fi
case $1 in
  "all")
    ./install.sh base drivers theme ssh kvm wallpaper-engine
    ;;
  "drivers")
    pacman -S xf86-video-amdgpu --noconfirm
    rsync -avh ./lib/firmware/* /lib/firmware/
    ;;
  "base")
    pacman -S --noconfirm p7zip protonup-qt-bin
    ;;
  "theme")
    # Doesn't delete folder yet. idk how to apply the theme trough script
    git clone https://github.com/vinceliuice/WhiteSur-kde.git
    WhiteSur-kde/install.sh
    pacman -S kvantum latte-dock --noconfirm
    ;;
  "ssh")
    systemctl enable --now sshd.service
  ;;
  "kvm")
    pacman -S virt-manager dnsmasq libvirt qemu edk2-ovmf --noconfirm
    systemctl enable --now libvirtd
    virsh net-autostart default
    virsh net-start default
    cp ./iommuls /usr/bin/
    usermod -aG libvirt "$(logname)"
    ;;
  "wallpaper-engine")
    # WGET this package because pgp signature key for this one is epxired on arch repo
    # Is required by packages used by wallpaper-engine
    wget https://ftp.sh.cvut.cz/arch/community/os/x86_64/luajit-2.1.0.beta3.r449.gdad04f17-1-x86_64.pkg.tar.zst
    pacman -U luajit-2.1.0.beta3.r449.gdad04f17-1-x86_64.pkg.tar.zst --noconfirm
    rm luajit-2.1.0.beta3.r449.gdad04f17-1-x86_64.pkg.tar.zst
    # end of dirty install
    sudo pacman -S --noconfirm extra-cmake-modules plasma-framework gst-libav base-devel mpv python-websockets qt5-declarative qt5-websockets qt5-webchannel vulkan-headers
    git clone https://github.com/catsout/wallpaper-engine-kde-plugin.git
    cd wallpaper-engine-kde-plugin
    git submodule update --init
    mkdir build && cd build
    cmake .. -DUSE_PLASMAPKG=ON
    make
    make install_pkg
    sudo make install
    cd ../..
    rm -rf wallpaper-engine-kde-plugin
    ;;
esac
shift 1
./install.sh "$@"
