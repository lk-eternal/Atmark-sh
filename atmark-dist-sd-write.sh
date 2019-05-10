# parameter eg: sdd
# IMG_DIR="/opt/armadillo-work/atmark-dist-20180330/images"
SD_DEV=/dev/$1

if [ ! -d ${SD_DEV} ]; then
    echo "Error: can't found sd card device."
    exit
fi

mkdir sd
sudo mount -t vfat ${SD_DEV}1 sd
sudo cp loader-armadillo840-mmcsd-*.bin sd/sdboot.bin
sudo umount sd
rmdir sd

mkdir romfs
sudo mount -o loop romfs*.img romfs
mkdir sd
sudo mount -t ext3 ${SD_DEV}2 sd
sudo cp -a romfs/* sd
sudo umount romfs
rmdir romfs
sed -i "s/ram0/mmcblk0p2/" sd/etc/fstab
sed -i "s/ext2/ext3/" sd/etc/fstab
sudo umount sd
rmdir sd

mkdir sd
sudo mount -t ext3 ${SD_DEV}2 sd
sudo mkdir -p sd/boot
sudo cp linux*.bin.gz sd/boot/Image.bin.gz
sudo umount sd
rmdir sd
