# HoloISO Steamdeck additions
Adds some fixes for Steam Deck.  
**This is for HoloISO 3.2 that released sept 02 2022**
## What does it do
* Adds missing ``xf86-video-amdgpu`` that fixes tearing while scrolling in web browsers.
* Adds missing drivers that fixes missing audio.
  * The files used are extracted from ``steamdeck-recovery-4.img.bz2``, the official SteamOS image for Steam Deck that can be found here : https://store.steampowered.com/steamos/download/?ver=steamdeck&snr=
* Installation of WhiteSur theme.
* Enable ssh on boot
## How to use
```shell
git clone git@github.com:Abikebuk/holoiso-steamdeck-additions.git
cd holoiso-steamdeck-additions
sudo ./install.sh
```

