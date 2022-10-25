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
    pacman -Rdd linux-firmware && sudo pacman -S linux-firmware-neptune && sudo mkinitcpio -P
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
    # VFIO is WIP...
    # Basic VMs thing work fine though
    pacman -S --noconfirm virt-manager dnsmasq libvirt qemu edk2-ovmf socat gnu-netcat
    yay -S --noconfirm linux-vfio --mflag --skipinteg
    systemctl enable --now libvirtd
    virsh net-autostart default
    virsh net-start default
    cp ./lsiommu /usr/bin/
    usermod -aG libvirt "$(logname)" # doesn't work but is not needed?
    ;;
  "wallpaper-engine")
    # WGET this package because pgp signature key for this one is epxired on Holoiso's arch repo
    # Is required by packages used by wallpaper-engine
    wget https://ftp.sh.cvut.cz/arch/community/os/x86_64/luajit-2.1.0.beta3.r449.gdad04f17-1-x86_64.pkg.tar.zst
    pacman -U luajit-2.1.0.beta3.r449.gdad04f17-1-x86_64.pkg.tar.zst --noconfirm
    rm luajit-2.1.0.beta3.r449.gdad04f17-1-x86_64.pkg.tar.zst
    # end of dirty install
    sudo pacman -S --noconfirm plasma5-wallpapers-wallpaper-engine
    ;;
esac
shift 1
./install.sh "$@"
