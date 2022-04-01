loadkeys fr-latin1
timedatectl set-ntp true
parted /dev/sda mklabel msdos
parted /dev/sda mkpart primary 1MiB 100%
