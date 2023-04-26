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
sudo pacman -Sy

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

# Install the base system and all relevant software
pacstrap /mnt base base-devel linux linux-firmware btrfs-progs exfat-utils e2fsprogs ntfs-3g intel-ucode nvidia nvidia-utils nvidia-settings networkmanager vi nano neovim git seahorse alacritty firefox ttf-jetbrains-mono-nerd bspwm sxhkd xdo rofi polybar picom flatpak fish htop pavucontrol thunar redshift-minimal

# Generate an fstab file
genfstab -U /mnt >> /mnt/etc/fstab

# Chroot into the system
arch-chroot /mnt

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
pacman -S grub os-prober efibootmgr
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

# Connect to the internet
sudo systemctl enable NetworkManager.service
sudo systemctl start NetworkManager.service
nmtui

# Update package lists
sudo pacman -Syy
sudo reflector --country GB --protocol https --latest 10 --sort rate --save /etc/pacman.d/mirrorlist
sudo pacman -Syy

# Install and setup yay (https://github.com/Jguer/yay)
mkdir ~/repos
cd ~/repos
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
yay -Y --gendb
yay -Syu --devel
yay -Y --devel --save

# Install and enable ly
yay -S ly
sudo systemctl enable ly.service

# Clone dotfiles
git clone --bare https://USERNAME:PASSWORD@github.com/derryleng/dotfiles.git /home/derry/.dotfiles
alias dotfiles='/usr/bin/git --git-dir=/home/derry/.dotfiles/ --work-tree=/home/derry'
dotfiles config --local status.showUntrackedFiles no
dotfiles checkout

# Exit chroot and reboot
exit
umount -R /mnt
reboot
```
