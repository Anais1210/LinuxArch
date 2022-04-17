timedatectl set-ntp true
parted /dev/sda mklabel msdos
parted /dev/sda mkpart primary 1MiB 100%
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
timedatectl set-timezone Europe/Paris
echo [your_hostname] > /etc/hostname
touch /etc/hosts
systemctl enable dhcpcd
passwd
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
