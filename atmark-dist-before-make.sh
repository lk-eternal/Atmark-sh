ROMFSDIR = $1
OPENCV_DIR = "/usr/opencv-*/lib"
MACHINE_ID = ${ROMFSDIR}/etc/machine-id

sudo rm -f ${ROMFSDIR}/lib/libgcc_s.so.1
sudo rm -f ${ROMFSDIR}/usr/lib/*.so.*
sudo cp -a /usr/lib/arm-linux-gnueabihf/*.so* ${ROMFSDIR}/lib
sudo cp -a /lib/arm-linux-gnueabihf/*.so*     ${ROMFSDIR}/lib

if [ -d ${OPENCV_DIR} ]; then
  sudo cp -a ${OPENCV_DIR}/*.so*                ${ROMFSDIR}/lib
else
  echo 'Error: cannot find opencv libs.'
fi

sudo rm             ${MACHINE_ID}
sudo touch          ${MACHINE_ID}
sudo dbus-uuidgen > ${MACHINE_ID}
