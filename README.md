# My dotfiles

- [My dotfiles](#my-dotfiles)
  - [Introduction](#introduction)
  - [Arch Installation](#arch-installation)
    - [1. Configure keyboard, internet and time](#1-configure-keyboard-internet-and-time)
    - [2. Create and format partitions](#2-create-and-format-partitions)
    - [3. Installation](#3-installation)
    - [4. Configure the new system](#4-configure-the-new-system)
    - [5. Post installation](#5-post-installation)
    - [6. Install additional software](#6-install-additional-software)
  - [Resources](#resources)

## Introduction

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

## Arch Installation

See the Arch wiki for more details: https://wiki.archlinux.org/title/Installation_guide

### 1. Configure keyboard, internet and time

Set the keyboard layout

```bash
loadkeys uk
```

Connect to the internet

```bash
iwctl
# Then in the iwctl prompt write:
#   station wlan0 scan
#   station wlan0 get-networks
#   station wlan0 connect ...OUR_SSID...
```

Update the system clock

```bash
timedatectl set-timezone "Europe/London"
timedatectl set-ntp true
```

### 2. Create and format partitions

First, we can view our current system partitions using:

```bash
lsblk
# OR
fdisk -l
```

Use the fdisk utility to create any required partition (here assuming we're using the disk nvme1n1):

```bash
fdisk /dev/nvme1n1
# Then follow instructions, don't write out using "w" until we are absolutely sure.
```

Note:

- If installing alongside another OS (e.g. Windows), we can just use the existing EFI partition.
- EFI partition size recommended between 512MB to 1GB.
- Swap partition is optional, size recommended between $\sqrt{\text{RAM Size}}$ to $2 \times \text{RAM Size}$.
- Root partition should take up rest of the disk (however much free space we want or have left).

Once, any new partitions are created, we format the new partitions.

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

Mount the partitions

```bash
# Mount the swap
swapon /dev/nvme1n1p2

# Mount the root partition to /mnt
mount /dev/nvme1n1p3 /mnt

# Mount the boot partition to /mnt/boot/efi
mkdir -p /mnt/boot/efi
mount /dev/nvme1n1p1 /mnt/boot/efi
```

### 3. Installation

Use reflector to update the fastest mirrors for pacman

```bash
reflector --country GB --protocol https --latest 10 --sort rate --save /etc/pacman.d/mirrorlist
```

Make sure package lists are up to date

```bash
pacman -Sy
```

Install some essential packages using pacstrap, here we're installing:

- Base and base development packages
- Linux kernel
- Linux firmware for common hardware
- Basic text editor (vi and nano)
- Networking (using NetworkManager)

```bash
pacstrap /mnt base base-devel linux linux-firmware vi nano networkmanager
```

### 4. Configure the new system

After all that is done, generate an fstab file

```bash
genfstab -U /mnt >> /mnt/etc/fstab

# Be sure to have a look and check for errors.
nano /mnt/etc/fstab
```

Now we can change root into the new system

```bash
arch-chroot /mnt
```

**We should now be in the new system as root**

Update the password for root user

```bash
passwd
```

Adjust clock and time zone

```bash
ln -sf /usr/share/zoneinfo/Europe/London /etc/localtime
hwclock --systohc
```

Uncomment the correct line in /etc/locale.gen and generate the locales

```bash
sed -i 's/#en_GB.UTF-8 UTF-8/en_GB.UTF-8 UTF-8/g' /etc/locale.gen
locale-gen
```

Set the language and keyboard layout

```bash
echo "LANG=en_GB.UTF-8" > /etc/locale.conf
echo "KEYMAP=uk" > /etc/vconsole.conf
```

Set the hostname

```bash
echo "myhostname" > /etc/hostname
```

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

Now we should have a minimal working system, we exit out of the system, unmount the partitions and then reboot.

```bash
exit
umount -R /mnt
reboot
```

### 5. Post installation

Assuming we have successfully booted into our new system as the new user, start up NetworkManager and connect to the internet.

```bash
sudo systemctl enable NetworkManager.service
sudo systemctl start NetworkManager.service

# Now configure the networking
nmtui
```

Clone my dotfiles

```bash
sudo pacman -S --needed git
git clone --bare https://github.com/derryleng/dotfiles.git /home/derry/.dotfiles
alias dotfiles='/usr/bin/git --git-dir=/home/derry/.dotfiles/ --work-tree=/home/derry'
dotfiles config --local status.showUntrackedFiles no
dotfiles checkout
```

Install and setup yay (https://github.com/Jguer/yay)

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

Install and enable ly

```bash
yay -S ly
sudo systemctl enable ly.service
```

### 6. Install additional software

Install intel microcode

```bash
sudo pacman -S --needed intel-ucode
```

Install filesystem tools

```bash
sudo pacman -S --needed e2fsprogs btrfs-progs exfat-utils ntfs-3g smartmontools
```

Install fonts

```bash
sudo pacman -S --needed adobe-source-code-pro-fonts adobe-source-han-sans-cn-fonts adobe-source-han-sans-jp-fonts adobe-source-han-sans-kr-fonts cantarell-fonts freetype2 noto-fonts ttf-bitstream-vera ttf-dejavu ttf-liberation ttf-opensans ttf-jetbrains-mono-nerd ttf-nerd-fonts-symbols-2048-em ttf-font-awesome noto-fonts noto-fonts-emoji
```

Install X display server

```bash
sudo pacman -S --needed xorg-server
```

Install desktop packages

```bash
sudo pacman -S --needed alacritty archlinux-xdg-menu bspwm picom polybar rofi sxhkd xbindkeys xclip xdo xorg-xbacklight xorg-xdpyinfo xorg-xinit xorg-xinput xorg-xkill xorg-xrandr xorg-xsetroot
```

Install pipewire for sound

```bash
sudo pacman -S --needed alsa-firmware alsa-plugins alsa-utils gst-plugin-pipewire pavucontrol pipewire pipewire-alsa pipewire-jack pipewire-pulse wireplumber
```

Install nvidia graphics drivers

```bash
pacman -S --needed nvidia nvidia-utils nvidia-settings
```

Install cursors, icons and themes

```bash
yay -S bibata-cursor-theme-bin qogir-gtk-theme arc-gtk-theme-git

sudo pacman -S papirus-icon-theme
```

Install some documentation

```bash
sudo pacman -S --needed man-db man-pages texinfo tldr
```

Install file dialog (gvfs) and file explorer (thunar)

```bash
sudo pacman -S --needed gvfs gvfs-afc gvfs-gphoto2 gvfs-mtp gvfs-nfs gvfs-smb thunar thunar-archive-plugin thunar-media-tags-plugin thunar-volman tumbler
```

Install some more useful stuff and enable some services

```bash
pacman -S --needed acpi acpid baobab bash-completion blueman bluez bluez-utils dconf-editor firewalld fish flatpak fzf gnome-disk-utility gnome-font-viewer gnome-keyring gnome-logs gtk-engine-murrine htop hwinfo inxi lxappearance nano-syntax-highlighting neovim reflector rsync rtkit scrot sysstat tlp wget xdg-user-dirs xdg-user-dirs-gtk

yay -S visual-studio-code-bin octopi awesome-git

flatpak install org.mozilla.firefox com.discordapp.Discord com.spotify.Client org.videolan.VLC com.github.tchx84.Flatseal com.usebottles.bottles org.qbittorrent.qBittorrent org.openrgb.OpenGRB

sudo systemctl enable acipd.service
sudo systemctl enable bluetooth.service
sudo systemctl enable firewalld
sudo systemctl enable tlp
sudo systemctl enable reflector.service
```

If we want to mount some windows disks on startup

```bash
# Find the UUID of the partitions you need to mount
sudo blkid | grep ' UUID='

# Make some mount directories
sudo mkdir -p /mnt/windows/c
sudo mkdir -p /mnt/windows/d
sudo mkdir -p /mnt/windows/e

# Edit fstab
sudo /etc/fstab
# Add new lines e.g.
#
# UUID=OUR_C_DRIVE_UUID /mnt/windows/c ntfs-3g defaults,nls=utf8,umask=000,dmask=027,fmask=137,uid=1000,gid=1000,windows_names 0 0
#
# and etc for the other drives.
```

## Resources

Config templates used:

- AwesomeWM: https://github.com/suconakh/awesome-awesome-rc
- Rofi: https://github.com/adi1090x/rofi
