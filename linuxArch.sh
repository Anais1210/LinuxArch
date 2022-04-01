
timedatectl set-ntp true
parted /dev/sda mklabel msdos
parted /dev/sda mkpart primary 1MiB 100%
