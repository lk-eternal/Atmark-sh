# parameter eg: sdd
# IMG_DIR="/opt/armadillo-work/atmark-dist-20180330/images"
SD_DEV=/dev/$1
BOOT_VER="3.11.0"

if [ ! -e ${SD_DEV} ]; then
    echo "Error: can't found sd card device."
    exit
fi

if [ -d sd ]; then
    sudo umount sd
    rmdir sd
fi

mkdir sd
sudo mount -t vfat ${SD_DEV}1 sd
sudo cp loader-armadillo840-mmcsd-*.bin sd/sdboot.bin
sudo umount sd
rmdir sd
echo "loader done."

mkdir romfs
sudo mount -o loop romfs.img romfs
mkdir sd
sudo mount -t ext3 ${SD_DEV}2 sd
sudo cp -a romfs/* sd
#sudo rm sd/lib/libgcc_s.so.1
#sudo cp -a /usr/lib/arm-linux-gnueabihf/*.so* sd/lib
#sudo cp -a /lib/arm-linux-gnueabihf/*.so* sd/lib
sudo umount romfs
rmdir romfs
sudo sed -i "s/ram0/mmcblk0p2/" sd/etc/fstab
sudo sed -i "s/ext2/ext3/" sd/etc/fstab
sudo umount sd
rmdir sd
echo "romfs done."

mkdir sd
sudo mount -t ext3 ${SD_DEV}2 sd
sudo mkdir -p sd/boot
sudo cp linux.bin.gz sd/boot/Image.bin.gz
sleep 5
sudo umount -f sd
rmdir sd
echo "linux done."
