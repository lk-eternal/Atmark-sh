ROMFSDIR=$1
QT_DIR="/opt/Qt/Qt5.3.2-arm"
OPENCV_DIR="/usr/opencv-*/lib"
MACHINE_ID=${ROMFSDIR}/etc/machine-id
QT_QPA="QT_QPA_EGLFS_DISPLAY=1
export QT_QPA_EGLFS_DISPLAY
QT_QPA_PLATFORM=linuxfb:fb=/dev/fb1
export QT_QPA_PLATFORM
QT_QPA_EGLFS_WIDTH=800
QT_QPA_EGLFS_HEIGHT=480
export QT_QPA_EGLFS_WIDTH
export QT_QPA_EGLFS_HEIGHT"

sudo rm -f ${ROMFSDIR}/lib/libgcc_s.so.1
sudo rm -f ${ROMFSDIR}/usr/lib/*.so.*
sudo cp -a /usr/lib/arm-linux-gnueabihf/*.so*             ${ROMFSDIR}/lib
sudo cp -a /usr/lib/arm-linux-gnueabihf/pulseaudio/*.so*  ${ROMFSDIR}/lib
sudo cp -a /lib/arm-linux-gnueabihf/*.so*                 ${ROMFSDIR}/lib
sudo cp -a ${QT_DIR}/lib/*.so*                            ${ROMFSDIR}/lib
sudo cp -rf ${QT_DIR}/plugins                             ${ROMFSDIR}/lib/qt5
sudo cp -rf ${QT_DIR}/qml                                 ${ROMFSDIR}/lib/qt5

if [ -d ${OPENCV_DIR} ]; then
  sudo cp -a ${OPENCV_DIR}/*.so*              ${ROMFSDIR}/lib
else
  echo 'Error: cannot find opencv libs.'
fi

sudo rm             ${MACHINE_ID}
sudo touch          ${MACHINE_ID}
sudo dbus-uuidgen > ${MACHINE_ID}

if grep -q "QPA" /etc/profile; then
    echo "QPA already added."
else
    sudo echo ${QT_QPA} >> /etc/profile
    echo "QPA add into profile."
fi
