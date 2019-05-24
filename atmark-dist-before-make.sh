ROMFSDIR=$1
QT_DIR="/opt/Qt/Qt5.3.2-arm"
OPENCV_DIR="/usr/opencv-*/lib"
MACHINE_ID=${ROMFSDIR}/etc/machine-id

sudo rm -f ${ROMFSDIR}/lib/libgcc_s.so.1
sudo rm -f ${ROMFSDIR}/usr/lib/*.so.*
sudo cp -a /usr/lib/arm-linux-gnueabihf/*.so*             ${ROMFSDIR}/lib
sudo cp -a /usr/lib/arm-linux-gnueabihf/pulseaudio/*.so*  ${ROMFSDIR}/lib
sudo cp -a /lib/arm-linux-gnueabihf/*.so*                 ${ROMFSDIR}/lib
sudo cp -r /usr/lib/arm-linux-gnueabihf/gstreamer0.10     ${ROMFSDIR}/lib
sudo cp -r /usr/lib/arm-linux-gnueabihf/gstreamer-0.10    ${ROMFSDIR}/lib
if [ -d ${QT_DIR} ]; then
  #sudo cp -a ${QT_DIR}/lib/*.so*     ${ROMFSDIR}/lib
  #sudo cp -rf ${QT_DIR}/plugins      ${ROMFSDIR}/lib/qt5
  #sudo cp -rf ${QT_DIR}/qml          ${ROMFSDIR}/lib/qt5
  sudo mkdir ${ROMFSDIR}/opt/Qt
  sudo cp -rf ${QT_DIR}/qml           ${ROMFSDIR}/opt/Qt
fi

if [ -d ${OPENCV_DIR} ]; then
  sudo cp -a ${OPENCV_DIR}/*.so*              ${ROMFSDIR}/lib
else
  echo 'Error: cannot find opencv libs.'
fi

sudo rm        ${MACHINE_ID}
touch          ${MACHINE_ID}
dbus-uuidgen > ${MACHINE_ID}

if grep -q "QPA" ${ROMFSDIR}/etc/profile; then
    echo "QPA already added."
else
    PROFILE=${ROMFSDIR}/etc/profile
# EGLFS not work at armdillo840!!!
#     sudo echo "export QT_QPA_PLATFORM=eglfs" >> $PROFILE
#     sudo echo "export QT_QPA_EGLFS_DISPLAY=1" >> $PROFILE
#     sudo echo "export QT_QPA_EGLFS_WIDTH=800" >> $PROFILE
#     sudo echo "export QT_QPA_EGLFS_HEIGHT=480" >> $PROFILE
#     sudo echo "export QT_QPA_EGLFS_FB=/dev/fb1" >> $PROFILE
    sudo echo "export QT_QPA_PLATFORM=linuxfb:fb=/dev/fb1" >> $PROFILE
    echo "QPA add into profile."
fi
