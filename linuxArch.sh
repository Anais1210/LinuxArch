# Create a script that allows you to install the Archlinux distribution. The script should be hosted on GitHub and fetched from a virtual machine that is running the latest version of Archlinux. The user should be able to customize the following:
#
# The size of the root partition (in percentage or hardcoded)
# The size of the swap partition (in percentage or hardcoded)
# The packages installed
# The timezone
# The locale
# The console keymap
# The hostname
# The administrator
# The users to add with their password

timedatectl set-ntp true
parted /dev/sda mklabel msdos
read  -p "Storage parted in % : " $percent
parted /dev/sda mkpart primary 1MiB $percent
mkfs.ext4 /dev/sda1
mkswap /dev/sda2
mount /dev/sda1 /mnt
swapon /dev/sda2
pacman -Syy
pacman -S reflector
cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak
reflector -c "FR" -f 12 -l 10 -n 12 --save /etc/pacman.d/mirrorlist
pacstrap /mnt base linux linux-firmware
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt

#Timezone
read -p "Continent : " $CONTINENT
read -p "City : " $CITY
timedatectl set-timezone $CONTINENT/$CITY

#Locale name
read -p "Local name :" $localName
echo $localName > /etc/locale.conf

#Hostname
read "Nom d'utilisateur" $hostname
echo $hostname > /etc/hostname

#New users
echo "Ajout d'un nouveau utilisateur :" $newUser
useradd -m -s /usr/bin/zsh $newUser
echo "Mot de passe : " $newUser
passwd $newUser

#Keymap
localectl list-keymaps
read -p "Choose your keymap with the list above:" $keymap
loadkeys $keymap

systemctl enable dhcpcd
pacman -S grub os-prober
grub-install /dev/sdX
grub-mkconfig -o /boot/grub/grub.cfg
pacman -S grub efibootmgr
mkdir /boot/efi
mount /dev/sdX1 /boot/efi
grub-install --target=x86_64-efi --bootloader-id=GRUB --efi-directory=/boot/efi
grub-mkconfig -o /boot/grub/grub.cfg
exit
sudo reboot
