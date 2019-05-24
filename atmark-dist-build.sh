WORK_DIR="/opt/armadillo840-work"
DIST_VER="20180330"
DIST_SRC=${WORK_DIR}/atmark-dist-${DIST_VER}
LINUX_VER="at26"
TCL_VER="8.4.12"
TCL_SRC=${WORK_DIR}/tcl${TCL_VER}
OPENCV_DIR="/usr/opencv-*/lib"
BEFORE_MAKE="atmark-dist-before-make.sh"
SD_WRITE="atmark-dist-sd-write.sh"
NOW_DIR=$PWD

# download source
sudo mkdir ${WORK_DIR}
sudo chown -R $USER:$USER ${WORK_DIR}

if [ ! -d ${DIST_SRC} ]; then
  cd ${WORK_DIR}
  wget https://download.atmark-techno.com/armadillo-840/source/atmark-dist-${DIST_VER}.tar.gz
  wget https://download.atmark-techno.com/armadillo-840/source/linux-3.4-${LINUX_VER}.tar.gz
  tar zxf atmark-dist-${DIST_VER}.tar.gz
  tar zxf linux-3.4-${LINUX_VER}.tar.gz
  ln -s ../linux-3.4-${LINUX_VER} atmark-dist-${DIST_VER}/linux-3.x
fi

if [ ! -e ${NOW_DIR}/${BEFORE_MAKE} ]; then
  echo "Error: cannot find ${BEFORE_MAKE} in current directory."
  exit
else
   cp -f ${NOW_DIR}/${BEFORE_MAKE} ${DIST_SRC}
fi

if [ ! -e ${NOW_DIR}/${SD_WRITE} ]; then
  echo "Error: cannot find ${SD_WRITE} in current directory."
  exit
fi

# install libs
#sudo apt-get install virtualbox-guest-dkms virtualbox-guest-x11 linux-headers-$(uname -r) -y
#sudo apt-get update
#sudo apt-get upgrade -y
#sudo aptitude install gstreamer1.0-plugins-bad:armhf -y
#sudo apt-get install libasound2-dev:armhf -y
#sudo apt-get install libexpat1-dev:armhf -y
#sudo apt-get install libdaemon-dev:armhf -y
#sudo apt-get install bison -y
#sudo apt-get install flex -y
#sudo apt-get install libglib2.0-dev:armhf -y
#sudo apt-get install libjpeg-dev:armhf -y
#sudo apt-get install zlib1g-dev:armhf -y
#sudo apt-get install liblzo2-dev:armhf -y
#sudo apt-get install libssl-dev:armhf -y
#sudo apt-get install gstreamer1.0-alsa:armhf -y
#sudo apt-get install gstreamer1.0-libav:armhf -y
#sudo apt-get install gstreamer1.0-plugins-good:armhf -y
#sudo apt-get install qt5-qmake:armhf -y
#sudo apt-get install qt5-default:armhf -y
#sudo apt-get install qtbase5-private-dev:armhf -y
#sudo apt-get install qtdeclarative5-dev:armhf -y
#sudo apt-get install qttools5-dev:armhf -y
#sudo apt-get install qtxmlpatterns5-dev-tools:armhf -y
#sudo apt-get install qmlscene:armhf -y
#sudo apt-get install qml-module-qtquick2:armhf -y
#sudo apt-get install qml-module-qttest:armhf -y
#sudo apt-get install qml-module-qtquick-window2:armhf -y
#sudo apt-get install qml-module-qtmultimedia:armhf -y
#sudo apt-get install genext2fs -y

# fix qmake link
sudo rm /usr/bin/qmake
sudo ln -s /usr/lib/arm-linux-gnueabihf/qt5/bin/qmake /usr/bin/qmake
sudo cp -r /usr/lib/arm-linux-gnueabihf/qt5/mkspecs/linux-arm-gnueabi-g++ /usr/lib/arm-linux-gnueabihf/qt5/mkspecs/linux-arm-gnueabihf-g++
sudo sed -i "s/gnueabi-/gnueabihf-/" /usr/lib/arm-linux-gnueabihf/qt5/mkspecs/linux-arm-gnueabihf-g++/qmake.conf

# install tcl
if [ ! -d ${TCL_SRC} ]; then
  cd ${WORK_DIR}
  wget --no-check-certificate https://master.dl.sourceforge.net/project/tcl/Tcl/${TCL_VER}/tcl${TCL_VER}-src.tar.gz
  tar xzf tcl${TCL_VER}-src.tar.gz
  cd ${TCL_SRC}/unix
  sed -i "s/relid'/relid/g" configure
  ./configure --prefix=/usr/arm-linux-gnueabihf --disable-shared
  make CC=arm-linux-gnueabihf-gcc
  sudo make install
  sudo ln -s ${TCL_SRC}/generic/tclInt.h /usr/arm-linux-gnueabihf/include
  sudo ln -s ${TCL_SRC}/generic/tclIntDecls.h /usr/arm-linux-gnueabihf/include
  sudo ln -s ${TCL_SRC}/generic/tclIntPlatDecls.h /usr/arm-linux-gnueabihf/include
  sudo ln -s ${TCL_SRC}/generic/tclPort.h /usr/arm-linux-gnueabihf/include
  sudo ln -s ${TCL_SRC}/unix/tclUnixPort.h /usr/arm-linux-gnueabihf/include
fi

# install gdbserver
GDB_DIR=/usr/share/gdb-arm-linux-gnueabihf
GDB_PATH=${GDB_DIR}/gdbserver
if [ ! -e ${GDB_PATH} ]; then
  sudo mkdir ${GDB_DIR}
  cd ${GDB_DIR}
  sudo wget --no-check-certificate https://download.atmark-techno.com/armadillo/cross-dev/debugger/gdbserver.gz
  sudo gunzip gdbserver.gz
fi

export PKG_CONFIG_PATH=/usr/lib/arm-linux-gnueabihf/pkgconfig

# fix dist source code
sed -i "/#include <sys\/types.h>/a\#include <sys\/resource.h>" ${DIST_SRC}/user/udev/udev-105/udev-105/udevd.c
# sed -i '/OPTINODES=/a\OPTBLOCKS=106131\nOPTINODES=1894'        ${DIST_SRC}/vendors/AtmarkTechno/Common/tools/genfs_ext2.sh
sed -i "/^int priv_gst_parse_yylex /s/ , yyscan_t yyscanner//" ${DIST_SRC}/user/gstreamer/gstreamer1.0/gstreamer1.0-1.0.8/gst/parse/grammar.y
sed -i "/#include <sys\/mman.h>/a\#include <sys\/resource.h>"  ${DIST_SRC}/user/busybox/busybox-1.20.2/include/libbb.h
sed -i "/^\techo 'static/d"                                    ${DIST_SRC}/user/gstreamer/gstreamer1.0/gstreamer1.0-1.0.8/gst/parse/Makefile.am
sed -i 's?/$(CROSS_COMPILE:-=)/lib?/lib/$(CROSS_COMPILE:-=)?'  ${DIST_SRC}/user/qt5/Makefile

ARMADILLO840_MAKEFILE=${DIST_SRC}/vendors/AtmarkTechno/Armadillo-840/Makefile
BEFORE_MAKE_CMD='bash $(ROOTDIR)/atmark-dist-before-make.sh $(ROMFSDIR)'
BEFORE_MAKE_PROCESS='/\t$(call do_depmod)/a\\t'
if grep -q "${BEFORE_MAKE_CMD}" ${ARMADILLO840_MAKEFILE}; then
  echo 'Before-make shell added into armadillo-840 makefile.'
else
  sed -i "${BEFORE_MAKE_PROCESS}${BEFORE_MAKE_CMD}" ${ARMADILLO840_MAKEFILE}
fi

sudo cp -rf /usr/lib/arm-linux-gnueabihf/gstreamer-1.0 /usr/arm-linux-gnueabihf/lib

cd ${DIST_SRC}
make menuconfig
make

# download boot image & copy images write script
cd ${DIST_SRC}/images
wget https://users.atmark-techno.com/files/downloads/armadillo-840/image/loader-armadillo840-mmcsd-v3.11.0.bin
cp ${NOW_DIR}/${SD_WRITE} ./
