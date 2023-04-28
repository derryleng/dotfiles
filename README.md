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

Make sure packages are up to date

```bash
pacman -Syu
```

Update the system clock

```bash
timedatectl set-timezone "Europe/London"
timedatectl set-ntp true
```

## 2. Create and format partitions

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

## 3. Installation

Use reflector to update the fastest mirrors for pacman

```bash
reflector --country GB --protocol https --latest 20 --sort rate --save /etc/pacman.d/mirrorlist
```

Install some essential packages using pacstrap, here we're installing:

- Base packages
- Linux kernel
- Linux firmware for common hardware
- Basic text editor (vi and nano)
- Networking (using NetworkManager)

```bash
pacstrap /mnt base base-devel linux linux-firmware vi nano networkmanager
```

## 3. Configure the new system

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
sed -i 's/#en_GB.UTF-8 UTF-8/en_GB.UTF-8 UTF-8/' /etc/locale.gen
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
sed 's/#GRUB_DISABLE_OS_PROBER=false/GRUB_DISABLE_OS_PROBER=false/' /etc/default/grub
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
sed -i 's/# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers
```

We can also edit /etc/sudoers to allow no sudo use of shutdown and reboot.

```bash
sed -i 's/# %wheel ALL=(ALL:ALL) NOPASSWD:/%wheel ALL=(ALL:ALL) NOPASSWD: /usr/bin/shutdown,/usr/bin/reboot/' /etc/sudoers
```

Now we should have a minimal working system, we exit out of the system, unmount the partitions and then reboot.

```bash
exit
umount -R /mnt
reboot
```

## 4. Post installation

Assuming we have successfully booted into our new system, start up NetworkManager and connect to the internet.

```bash
sudo systemctl enable NetworkManager.service
sudo systemctl start NetworkManager.service

# Now configure the networking
nmtui
```

Update pacman mirror list

```bash
pacman -S reflector
reflector --country GB --protocol https --latest 20 --sort rate --save /etc/pacman.d/mirrorlist
pacman -Syy
```

Clone my dotfiles

```bash
pacman -S --needed git
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

## 5. Install additional software

```bash

# Install some pacman tools
pacman -S --needed pacman-contrib pkgfile rebuild-detector

# Install filesystem tools
pacman -S --needed btrfs-progs exfat-utils e2fsprogs ntfs-3g

# Install time and networking tools
pacman -S --needed ntp networkmanager dhclient ethtool dnsmasq dnsutils wireless_tools iwd usb_modeswitch whois nmap ndisc6

# Install fonts
pacman -S --needed adobe-source-han-sans-cn-fonts adobe-source-han-sans-jp-fonts adobe-source-han-sans-kr-fonts cantarell-fonts freetype2 noto-fonts ttf-bitstream-vera ttf-dejavu ttf-liberation ttf-opensans ttf-jetbrains-mono-nerd ttf-nerd-fonts-symbols-2048-em ttf-font-awesome noto-fonts noto-fonts-emoji

# Install some more utils and stuff
pacman -S --needed git flatpak fish htop gnome-keyring xclip xdotool fzf rsync wget duf fsarchiver glances hwinfo inxi meld nano-syntax-highlighting pv python-defusedxml python-packaging rtkit dmidecode dmraid hdparm hwdetect lsscsi mtools sg3_utils sof-firmware tlp bluez bluez-utils xdg-user-dirs xdg-user-dirs-gtk xdg-utils haveged bash-completion jq acpi sysstat findutils dialog smartmontools

# Install some documentation
pacman -S --needed man-db man-pages texinfo tldr

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
```
