QT_VER="5.3.2"
QT_PREFIX=/opt/Qt/Qt${QT_VER}

cd /opt
sudo wget https://download.qt.io/archive/qt/${QT_VER:0:3}/${QT_VER}/single/qt-everywhere-opensource-src-${QT_VER}.tar.xz
sudo tar Jxf qt-everywhere-opensource-src-${QT_VER}.tar.xz
sudo chown -R $USER:$USER qt-everywhere-opensource-src-${QT_VER}
cd qt-everywhere-opensource-src-${QT_VER}
cp -r qtbase/mkspecs/linux-arm-gnueabi-g++ qtbase/mkspecs/linux-arm-gnueabihf-g++
sed -i "s/gnueabi-/gnueabihf-/" qtbase/mkspecs/linux-arm-gnueabihf-g++/qmake.conf

./configure -v -xplatform linux-arm-gnueabihf-g++ -release -opensource -confirm-license -make libs \
-prefix ${QT_PREFIX} -arm -skip webkit -nomake examples -nomake tests \
-no-qml-debug -opengl es2 -no-xcb

make -j$(nproc)
sudo make install
sudo apt-get install qtcreator -y
