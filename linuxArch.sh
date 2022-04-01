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
