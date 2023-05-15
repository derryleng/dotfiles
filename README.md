- [My dotfiles](#my-dotfiles)
  - [Summary](#summary)
  - [Resources](#resources)
- [Install Instructions](#install-instructions)
  - [Arch](#arch)
    - [Configure keyboard layout](#configure-keyboard-layout)
    - [Connect to the internet](#connect-to-the-internet)
    - [Update system clock](#update-system-clock)
    - [Create partitions](#create-partitions)
    - [Format partitions](#format-partitions)
    - [Mount partitions](#mount-partitions)
    - [Update mirrors and package lists](#update-mirrors-and-package-lists)
    - [Install base packages](#install-base-packages)
    - [Generate fstab file](#generate-fstab-file)
    - [Change root into new system](#change-root-into-new-system)
    - [Update user account settings](#update-user-account-settings)
    - [Adjust clock, locale and keyboard layout](#adjust-clock-locale-and-keyboard-layout)
    - [Set the hostname](#set-the-hostname)
    - [Install bootloader (grub)](#install-bootloader-grub)
    - [Exit chroot and reboot](#exit-chroot-and-reboot)
    - [Connect to internet on new system](#connect-to-internet-on-new-system)
  - [AUR helper (yay)](#aur-helper-yay)
  - [Display manager (ly)](#display-manager-ly)
  - [Sound (pipewire)](#sound-pipewire)
  - [DE/WM](#dewm)
    - [awesome](#awesome)
    - [bspwm](#bspwm)
  - [Fonts](#fonts)
  - [Filesystem tools](#filesystem-tools)
  - [Nvidia graphics drivers](#nvidia-graphics-drivers)
  - [Cursors, icons and themes](#cursors-icons-and-themes)
  - [Documentation](#documentation)
  - [More useful stuff and enable some services](#more-useful-stuff-and-enable-some-services)
  - [Clone dotfiles](#clone-dotfiles)

# My dotfiles

## Summary

My dotfiles currently include configurations for:

- awesome-wm
- bspwm
- sxhkd
- polybar
- rofi
- alacritty
- neofetch
- picom
- redshift
- bash
- zsh
- fish
- gtk
- other misc configs

## Resources

Config templates used:

- AwesomeWM: https://github.com/suconakh/awesome-awesome-rc
- Rofi: https://github.com/adi1090x/rofi

# Install Instructions

> I'm using this section to keep track of the steps I have taken during install, this is not thoroughly tested so not guaranteed to work 100%!

## Arch

See the Arch wiki for more details: https://wiki.archlinux.org/title/Installation_guide

### Configure keyboard layout

```bash
loadkeys uk
```

### Connect to the internet

```bash
iwctl
# Then in the iwctl prompt do:
#   station wlan0 scan
#   station wlan0 get-networks
#   station wlan0 connect ...OUR_SSID...
```

### Update system clock

```bash
timedatectl set-timezone "Europe/London"
timedatectl set-ntp true
```

### Create partitions

First, we can view our current system partitions using:

```bash
lsblk
# OR
fdisk -l
```

Use the fdisk utility to create any required partition (here assuming we're using the disk **nvme1n1**):

```bash
fdisk /dev/nvme1n1
# Then follow instructions, don't write out using "w" until we are absolutely sure.
```

NB:

- If installing alongside another OS (e.g. Windows), we can just use the existing EFI partition.
- EFI partition size recommended between 512MB to 1GB.
- Swap partition is optional, size recommended between $\sqrt{\text{RAM Size}}$ to $2 \times \text{RAM Size}$.
- Root partition should take up rest of the disk (however much free space we want or have left).

### Format partitions

```bash
# Assuming we made a new partition nvme1n1p1 for EFI boot, format it.
# Otherwise, skip this step if using an existing EFI partition (e.g nvme0n1p1).
mkfs.fat -F32 /dev/nvme1n1p1

# Assuming we made a new partition nvme1n1p2 for swap, format it.
# Otherwise, skip this step if not using a swap (or have an existing swap partition).
mkswap /dev/nvme1n1p2

# Assuming our root partition is nvme1n1p3, format it.
# Commonly used filesystem is Ext4:
mkfs.ext4 /dev/nvme1n1p3
# Or we can use BTRFS:
mkfs.btrfs /dev/nvme1n1p3
```

### Mount partitions

```bash
# Mount the swap
swapon /dev/nvme1n1p2

# Mount the root partition to /mnt
mount /dev/nvme1n1p3 /mnt

# Mount the boot partition to /mnt/boot/efi
mkdir -p /mnt/boot/efi
mount /dev/nvme1n1p1 /mnt/boot/efi
```

### Update mirrors and package lists

Use reflector to update the fastest mirrors for pacman.

```bash
reflector --country GB --protocol https --latest 10 --sort rate --save /etc/pacman.d/mirrorlist
```

Make sure package lists are up to date.

```bash
pacman -Sy
```

### Install base packages

Install some essential packages using pacstrap, here we're installing:

- Base and base development packages
- Linux kernel and header files
- Linux firmware
- Intel microcode (for Intel CPU)
- Basic text editors (vi and nano)
- Networking (using NetworkManager)
- Git for cloning repos

```bash
pacstrap /mnt base base-devel linux linux-headers linux-firmware intel-ucode vi nano networkmanager git
```

### Generate fstab file

```bash
genfstab -U /mnt >> /mnt/etc/fstab

# Be sure to have a look and check for errors.
nano /mnt/etc/fstab
```

If we want to mount some windows disks on startup:

```bash
# Find the UUID of the partitions you need to mount
sudo blkid | grep ' UUID='

# Make some mount directories
sudo mkdir -p /mnt/windows/c
sudo mkdir -p /mnt/windows/d
# etc...

# Edit fstab
sudo /etc/fstab
# Add new lines e.g.
#
# UUID=OUR_C_DRIVE_UUID /mnt/windows/c ntfs-3g defaults,nls=utf8,umask=000,dmask=027,fmask=137,uid=1000,gid=1000,windows_names 0 0
#
# and etc for the other drives.
```

### Change root into new system

```bash
arch-chroot /mnt
```

**We should now be root user in the new system.**

### Update user account settings

Update the password for root user.

```bash
passwd
```

Create a new user account (replace newuser with name of our account) and then add them to sudoers.

```bash
useradd -m -G wheel -s /bin/bash newuser
passwd newuser
sed -i 's/# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/g' /etc/sudoers
```

We can also edit /etc/sudoers to allow non-sudo use of shutdown, reboot, mount, umount.

```bash
sed -i 's+# %wheel ALL=(ALL:ALL) NOPASSWD: ALL+%wheel ALL=(ALL:ALL) NOPASSWD: /usr/bin/shutdown,/usr/bin/reboot,/sbin/mount,/sbin/umount+g' /etc/sudoers
```

### Adjust clock, locale and keyboard layout

```bash
ln -sf /usr/share/zoneinfo/Europe/London /etc/localtime
hwclock --systohc
```

Uncomment the correct line in /etc/locale.gen and generate the locales.

```bash
sed -i 's/#en_GB.UTF-8 UTF-8/en_GB.UTF-8 UTF-8/g' /etc/locale.gen
locale-gen
```

```bash
echo "LANG=en_GB.UTF-8" > /etc/locale.conf
echo "KEYMAP=uk" > /etc/vconsole.conf
```

### Set the hostname

```bash
echo "myhostname" > /etc/hostname
```

### Install bootloader (grub)

Install the bootloader, here we are using Grub for EFI boot. We're also using os-prober so that we can detect other bootloaders - skip the last two steps if we don't need this.

```bash
pacman -S --needed grub os-prober efibootmgr
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=archlinux
grub-mkconfig -o /boot/grub/grub.cfg
sed 's/#GRUB_DISABLE_OS_PROBER=false/GRUB_DISABLE_OS_PROBER=false/g' /etc/default/grub
update-grub
# If the update-grub command doesn't exist:
# Write the following into /usr/sbin/update-grub:
#
# #!/bin/sh
# set -e
# exec grub-mkconfig -o /boot/grub/grub.cfg "$@"
#
# Then set file ownership to make it useable:
#
# chown root:root /usr/sbin/update-grub
# chmod 755 /usr/sbin/update-grub
```

### Exit chroot and reboot

Now we should have a minimal working system, we exit out of the system, unmount the partitions and then reboot.

```bash
exit
umount -R /mnt
reboot
```

### Connect to internet on new system

Assuming we have successfully booted into our new system as the new user, start up NetworkManager and connect to the internet.

```bash
sudo systemctl enable NetworkManager.service
sudo systemctl start NetworkManager.service

# Now configure the networking
nmtui
```

## AUR helper (yay)

```bash
mkdir repos
cd repos
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
yay -Y --gendb
yay -Syu --devel
yay -Y --devel --save
```

See more details here: https://github.com/Jguer/yay

## Display manager (ly)

```bash
yay -S ly
sudo systemctl enable ly.service
```

See more details here: https://github.com/fairyglade/ly

## Sound (pipewire)

| Package             | Description |
| ------------------- | ----------- |
| alsa-firmware       |             |
| alsa-plugins        |             |
| alsa-utils          |             |
| gst-plugin-pipewire |             |
| pavucontrol         |             |
| pipewire            |             |
| pipewire-alsa       |             |
| pipewire-jack       |             |
| pipewire-pulse      |             |
| wireplumber         |             |

```bash
yay -S alsa-firmware alsa-plugins alsa-utils gst-plugin-firmware pavucontrol \
pipewire pipewire-alsa pipewire-jack pipewire-pulse wireplumber
```

## DE/WM

### awesome

| Package                  | Description                         |
| ------------------------ | ----------------------------------- |
| xorg-server              | Display server for X11              |
| xbindkeys                |                                     |
| xclip                    |                                     |
| xdo                      |                                     |
| xorg-xbacklight          |                                     |
| xorg-xdpyinfo            |                                     |
| xorg-xinit               |                                     |
| xorg-xinput              |                                     |
| xorg-xkill               |                                     |
| xorg-xrandr              |                                     |
| xorg-xsetroot            |                                     |
| archlinux-xdg-menu       |                                     |
| picom                    |                                     |
| rofi                     |                                     |
| dunst                    |                                     |
| dmenu                    |                                     |
| (AUR) awesome-git        |                                     |
| luarocks                 |                                     |
| volumeicon               |                                     |
| network-manager-applet   |                                     |
| ibus                     | Keyboard layouts and input methods  |
| blueman                  |                                     |
| bluez                    |                                     |
| bluez-utils              |                                     |
| gvfs                     | File dialog                         |
| gvfs-afc                 | AFC (mobile devices) support        |
| gvfs-gphoto2             | PTP camera/MTP media player support |
| gvfs-mtp                 | MTP device support                  |
| gvfs-nfs                 | NFS support                         |
| gvfs-smb                 | SMB/CIFS (Windows client) support   |
| thunar                   | File browser                        |
| thunar-archive-plugin    |                                     |
| thunar-media-tags-plugin |                                     |
| thunar-volman            |                                     |
| tumbler                  |                                     |
| alacritty                | Terminal emulator                   |

```bash
yay -S --needed xorg-server xbindkeys xclip xdo xorg-xbacklight xorg-xdpyinfo  \
xorg-xinit xorg-xinput xorg-xkill xorg-xrandr xorg-xsetroot archlinux-xdg-menu \
picom rofi dmenu dunst \
awesome-git luarocks \
volumeicon network-manager-applet ibus \
blueman bluez bluez-utils \
gvfs gvfs-afc gvfs-gphoto2 gvfs-mtp gvfs-nfs gvfs-smb \
thunar thunar-archive-plugin thunar-media-tags-plugin thunar-volman tumbler \
alacritty
```

### bspwm

| Package                  | Description                         |
| ------------------------ | ----------------------------------- |
| xorg-server              | Display server for X11              |
| xbindkeys                |                                     |
| xclip                    |                                     |
| xdo                      |                                     |
| xorg-xbacklight          |                                     |
| xorg-xdpyinfo            |                                     |
| xorg-xinit               |                                     |
| xorg-xinput              |                                     |
| xorg-xkill               |                                     |
| xorg-xrandr              |                                     |
| xorg-xsetroot            |                                     |
| archlinux-xdg-menu       |                                     |
| picom                    |                                     |
| rofi                     |                                     |
| dmenu                    |                                     |
| dunst                    |                                     |
| bspwm                    |                                     |
| sxhkd                    |                                     |
| polybar                  |                                     |
| volumeicon               |                                     |
| network-manager-applet   |                                     |
| ibus                     | Keyboard layouts and input methods  |
| blueman                  |                                     |
| bluez                    |                                     |
| bluez-utils              |                                     |
| gvfs                     | File dialog                         |
| gvfs-afc                 | AFC (mobile devices) support        |
| gvfs-gphoto2             | PTP camera/MTP media player support |
| gvfs-mtp                 | MTP device support                  |
| gvfs-nfs                 | NFS support                         |
| gvfs-smb                 | SMB/CIFS (Windows client) support   |
| thunar                   | File browser                        |
| thunar-archive-plugin    |                                     |
| thunar-media-tags-plugin |                                     |
| thunar-volman            |                                     |
| tumbler                  |                                     |
| alacritty                | Terminal emulator                   |

```bash
yay -S --needed xorg-server xbindkeys xclip xdo xorg-xbacklight xorg-xdpyinfo  \
xorg-xinit xorg-xinput xorg-xkill xorg-xrandr xorg-xsetroot archlinux-xdg-menu \
picom rofi dmenu dunst \
bspwm sxhkd polybar \
volumeicon network-manager-applet ibus \
blueman bluez bluez-utils \
gvfs gvfs-afc gvfs-gphoto2 gvfs-mtp gvfs-nfs gvfs-smb \
thunar thunar-archive-plugin thunar-media-tags-plugin thunar-volman tumbler \
alacritty
```

| Package                                   | Description                                           |
| ----------------------------------------- | ----------------------------------------------------- |
| xorg-server                               | Display server for X11                                |
| xbindkeys                                 |                                                       |
| xclip                                     |                                                       |
| xdo                                       |                                                       |
| xorg-xbacklight                           |                                                       |
| xorg-xdpyinfo                             |                                                       |
| xorg-xinit                                |                                                       |
| xorg-xinput                               |                                                       |
| xorg-xkill                                |                                                       |
| xorg-xrandr                               |                                                       |
| xorg-xsetroot                             |                                                       |
| archlinux-xdg-menu                        |                                                       |
| gnome-shell                               |                                                       |
| gnome-bluetooth-3.0                       | Optional GNOME dependency for bluetooth support       |
| gnome-control-center                      | Optional GNOME dependency for system settings         |
| gnome-disk-utility                        | Optional GNOME dependency for mount with keyfiles     |
| gst-plugin-pipewire                       | Optional GNOME dependency for screen recording        |
| gst-plugins-good                          | Optional GNOME dependency for screen recording        |
| power-profiles-daemon                     | Optional GNOME dependency for power profile switching |
| (AUR) extension-manager                   | Browsing, installing, managing GNOME shell extensions |
| gnome-tweaks                              |                                                       |
| dconf-editor                              |                                                       |
| (AUR) gnome-shell-extension-pop-shell-git | GNOME shell extension for tiling windows              |
| gvfs                                      | File dialog                                           |
| gvfs-afc                                  | AFC (mobile devices) support                          |
| gvfs-gphoto2                              | PTP camera/MTP media player support                   |
| gvfs-mtp                                  | MTP device support                                    |
| gvfs-nfs                                  | NFS support                                           |
| gvfs-smb                                  | SMB/CIFS (Windows client) support                     |
| nautilus                                  | Native GNOME file browser                             |
| alacritty                                 | Terminal emulator                                     |

```bash
yay -S --needed xorg-server xbindkeys xclip xdo xorg-xbacklight xorg-xdpyinfo \
xorg-xinit xorg-xinput xorg-xkill xorg-xrandr xorg-xsetroot archlinux-xdg-menu \
gnome-shell gnome-bluetooth-3.0 gnome-control-center gnome-disk-utility \
gst-plugin-pipewire gst-plugins-good power-profiles-daemon \
extension-manager gnome-tweaks dconf-editor gnome-shell-extension-pop-shell-git \
gvfs gvfs-afc gvfs-gphoto2 gvfs-mtp gvfs-nfs gvfs-smb \
nautilus alacritty
```

## Fonts

```bash
yay -S adobe-source-code-pro-fonts adobe-source-han-sans-cn-fonts  \
adobe-source-han-sans-jp-fonts adobe-source-han-sans-kr-fonts      \
cantarell-fonts freetype2 ttf-bitstream-vera ttf-dejavu            \
ttf-liberation ttf-opensans ttf-jetbrains-mono-nerd                \
ttf-nerd-fonts-symbols-2048-em ttf-font-awesome noto-fonts         \
noto-fonts-emoji
```

## Filesystem tools

```bash
yay -S --needed e2fsprogs btrfs-progs exfat-utils ntfs-3g smartmontools
```

## Nvidia graphics drivers

```bash
yay -S --needed nvidia nvidia-utils nvidia-settings
```

## Cursors, icons and themes

```bash
yay -S bibata-cursor-theme-bin qogir-gtk-theme arc-gtk-theme-git papirus-icon-theme
```

## Documentation

```bash
yay -S --needed man-db man-pages texinfo tldr
```

## More useful stuff and enable some services

```bash
yay -S --needed acpi acpid baobab bash-completion discord firewalld \
firefox fish flatpak fzf gnome-disk-utility gnome-font-viewer       \
gnome-keyring gnome-logs htop hwinfo inxi lxappearance              \
nano-syntax-highlighting neovim polkit reflector rsync rtkit scrot  \
sysstat tlp vlc wget xdg-user-dirs xdg-user-dirs-gtk                \
visual-studio-code-bin octopi spotify

flatpak install flathub com.github.tchx84.Flatseal com.usebottles.bottles

sudo systemctl enable acipd.service
sudo systemctl enable bluetooth.service
sudo systemctl enable firewalld
sudo systemctl enable tlp
sudo systemctl enable reflector.service
```

## Clone dotfiles

```bash
git clone --bare https://github.com/derryleng/dotfiles.git /home/derry/.dotfiles

# Set dotfiles alias if not done already
# alias dotfiles='/usr/bin/git --git-dir=/home/derry/.dotfiles/ --work-tree=/home/derry'

dotfiles config --local status.showUntrackedFiles no
dotfiles checkout
```
