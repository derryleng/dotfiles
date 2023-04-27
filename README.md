# My dotfiles

> Very WIP.

What I currently use:

| Type              | Software                                                                                                                                                                                                                                                  |
| ----------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Display Manager   | [ly](https://github.com/fairyglade/ly)                                                                                                                                                                                                                    |
| DE/WM             | [bspwm](https://github.com/baskerville/bspwm) ([sxhkd](https://github.com/baskerville/sxhkd), [polybar](https://github.com/polybar/polybar))<br />[awesome-wm](https://awesomewm.org/)                                                                    |
| Terminal Emulator | [alacritty](https://github.com/alacritty/alacritty)                                                                                                                                                                                                       |
| Shell             | [zsh](https://www.zsh.org) ([oh-my-zsh](https://ohmyz.sh/), [powerlevel10k](https://github.com/romkatv/powerlevel10k))<br />[fish](https://fishshell.com/) ([fisher](https://github.com/jorgebucaran/fisher), [tide](https://github.com/IlanCosman/tide)) |
| Browser           | [firefox](https://www.mozilla.org/en-US/firefox/browsers/)                                                                                                                                                                                                |
| Editor/IDE        | [neovim](https://github.com/neovim/neovim), [vscode](https://code.visualstudio.com/)                                                                                                                                                                      |
| File Manager      | [thunar](https://docs.xfce.org/xfce/thunar/start)                                                                                                                                                                                                         |
| Launcher          | [rofi](https://github.com/davatorium/rofi)                                                                                                                                                                                                                |

Config templates used:

- AwesomeWM: https://github.com/suconakh/awesome-awesome-rc
- Rofi: https://github.com/adi1090x/rofi

## Installation

### 1. Arch install
More details: https://wiki.archlinux.org/title/Installation_guide

```bash
#!/bin/bash

# Set the keyboard layout
loadkeys uk

# Connect to the internet
iwctl
# station wlan0 scan
# station wlan0 get-networks
# station wlan0 connect ...SSID...

# Update package list
pacman -Sy

# Update the system clock
timedatectl set-timezone "Europe/London"
timedatectl set-ntp true

# Partition the disk
fdisk /dev/nvme1n1

# Format the partitions
mkfs.fat -F32 /dev/nvme1n1p1 # EFI
mkswap /dev/nvme1n1p2 # swap
mkfs.btrfs /dev/nvme1n1p3 # root

# Mount the partitions
swapon /dev/nvme1n1p2
mount /dev/nvme1n1p3 /mnt
mkdir -p /mnt/boot/efi
mount /dev/nvme1n1p1 /mnt/boot/efi

# Install the base system, linux kernel, text editors
pacstrap /mnt base base-devel linux linux-firmware vi nano

# Generate an fstab file
genfstab -U /mnt >> /mnt/etc/fstab

# Chroot into the system
arch-chroot /mnt

# Update root password
passwd

# Set the time zone
ln -sf /usr/share/zoneinfo/Europe/London /etc/localtime
hwclock --systohc

# Uncomment en_GB.UTF-8 UTF-8 in /etc/locale.gen and generate the locales
sed -i 's/#en_GB.UTF-8 UTF-8/en_GB.UTF-8 UTF-8/' /etc/locale.gen
locale-gen

# Set the language and keyboard layout
echo "LANG=en_GB.UTF-8" > /etc/locale.conf
echo "KEYMAP=uk" > /etc/vconsole.conf

# Set the hostname
echo "myhostname" > /etc/hostname

# Install bootloader (GRUB and EFI)
pacman -S --needed grub os-prober efibootmgr
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=archlinux
grub-mkconfig -o /boot/grub/grub.cfg
sed 's/#GRUB_DISABLE_OS_PROBER=false/GRUB_DISABLE_OS_PROBER=false/' /etc/default/grub
update-grub
# If update-grub doesn't exist:
# Write the following into /usr/sbin/update-grub
#
# #!/bin/sh
# set -e
# exec grub-mkconfig -o /boot/grub/grub.cfg "$@"
#
# Then set ownership:
#
# chown root:root /usr/sbin/update-grub
# chmod 755 /usr/sbin/update-grub

# Create a new user and add to sudoers
useradd -m -G wheel -s /bin/bash newuser
passwd newuser
sed -i 's/# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers

# Update mirror list
pacman -S reflector
reflector --country GB --protocol https --latest 10 --sort rate --save /etc/pacman.d/mirrorlist
pacman -Syy

# Install some pacman tools
pacman -S --needed pacman-contrib pkgfile rebuild-detector

# Install filesystem tools
pacman -S --needed btrfs-progs exfat-utils e2fsprogs ntfs-3g efitools

# Install time and networking tools
pacman -S --needed ntp networkmanager dhclient ethtool dnsmasq dnsutils wireless_tools iwd usb_modeswitch whois nmap ndisc6

# Install fonts
pacman -S --needed adobe-source-han-sans-cn-fonts adobe-source-han-sans-jp-fonts adobe-source-han-sans-kr-fonts cantarell-fonts freetype2 noto-fonts ttf-bitstream-vera ttf-dejavu ttf-liberation ttf-opensans ttf-jetbrains-mono-nerd ttf-nerd-fonts-symbols-2048-em ttf-font-awesome noto-fonts noto-fonts-emoji

# Install some more utils and stuff
pacman -S --needed git flatpak fish htop gnome-keyring man-db xclip xdotool fzf rsync wget duf fsarchiver glances hwinfo inxi meld nano-syntax-highlighting pv python-defusedxml python-packaging tldr rtkit dmidecode dmraid hdparm hwdetect lsscsi mtools sg3_utils sof-firmware tlp bluez bluez-utils xdg-user-dirs xdg-user-dirs-gtk xdg-utils haveged bash-completion jq acpi sysstat findutils dialog smartmontools

# Install pipewire for sound
pacman -S --needed alsa-firmware alsa-plugins alsa-utils pipewire pipewire-alsa pipewire-jack pipewire-pulse  wireplumber pavucontrol gst-plugin-pipewire

# Install intel microcode and nvidia graphics drivers
pacman -S --needed intel-ucode nvidia nvidia-utils nvidia-settings

# Install X11 tools and desktop (bspwm)
pacman -S --needed libwnck3 mesa-utils xorg-xinput xorg-xkill xorg-xrandr xf86-video-intel xorg-xwininfo xorg-xdpyinfo xorg-xinit xorg-xbacklight xbindkeys xorg-xsetroot arandr bspwm sxhkd xdo picom polybar rofi dunst archlinux-xdg-menu scrot i3lock gtk-engine-murrine lxappearance-gtk3

# Install file dialog (gvfs) and file explorer (thunar)
pacman -S --needed gvfs gvfs-afc gvfs-gphoto2 gvfs-mtp gvfs-nfs gvfs-smb tumbler thunar thunar-archive-plugin thunar-media-tags-plugin thunar-volman

# Install some apps
pacman -S --needed alacritty firefox neovim

# Exit chroot and reboot
exit
umount -R /mnt
reboot
```

### 2. Post install

```bash
#!/bin/bash

# Enable some services
sudo systemctl enable NetworkManager.service
sudo systemctl start NetworkManager.service
nmtui
sudo systemctl enable ntpd
sudo systemctl start ntpd

# Clone dotfiles
git clone --bare https://USERNAME:PASSWORD@github.com/derryleng/dotfiles.git /home/derry/.dotfiles
alias dotfiles='/usr/bin/git --git-dir=/home/derry/.dotfiles/ --work-tree=/home/derry'
dotfiles config --local status.showUntrackedFiles no
dotfiles checkout

# Install and setup yay (https://github.com/Jguer/yay)
su derry
cd
mkdir repos
cd repos
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
yay -Y --gendb
yay -Syu --devel
yay -Y --devel --save

# Install and enable ly
yay -S ly
sudo systemctl enable ly.service
```
