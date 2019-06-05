sudo apt-get install build-essential -y
sudo apt-get install curl -y
sudo apt-get install locales -y

sudo touch /etc/apt/sources.list.d/crosstools.list
sudo chmod a+rw /etc/apt/sources.list.d/crosstools.list
sudo echo 'deb http://emdebian.org/tools/debian/ jessie main' > /etc/apt/sources.list.d/crosstools.list
curl http://emdebian.org/tools/debian/emdebian-toolchain-archive.key | sudo apt-key add -
sudo dpkg --add-architecture armhf
sudo apt-get update

sudo apt-get install libc6-dev:armhf -y
sudo apt-get install libgcc-4.9-dev:armhf -y
sudo apt-get install dpkg-cross -y

apt-get download libgcc-4.9-dev:armhf
apt-get download binutils-arm-linux-gnueabihf
apt-get download cpp-4.9-arm-linux-gnueabihf
apt-get download gcc-4.9-arm-linux-gnueabihf
apt-get download g++-4.9-arm-linux-gnueabihf
apt-get download gcc-arm-linux-gnueabihf
apt-get download g++-arm-linux-gnueabihf
apt-get download crossbuild-essential-armhf
sudo dpkg --force-depends -i libgcc-4.9-dev_4.9.2-10+deb8u2_armhf.deb
sudo dpkg --force-depends -i binutils-arm-linux-gnueabihf*
sudo dpkg --force-depends -i cpp-4.9-arm-linux-gnueabihf*
sudo dpkg --force-depends -i gcc-4.9-arm-linux-gnueabihf*
sudo dpkg --force-depends -i g++-4.9-arm-linux-gnueabihf*
sudo dpkg --force-depends -i gcc-arm-linux-gnueabihf*
sudo dpkg --force-depends -i g++-arm-linux-gnueabihf*
sudo dpkg --force-depends -i crossbuild-essential-armhf*

sudo sed -i 's/libstdc++-4.9-dev:armhf (= 4.9.2-10)/libstdc++-4.9-dev:armhf (>= 4.9.2-10)/g' /var/lib/dpkg/status
sudo sed -i 's/libgcc-4.9-dev:armhf (= 4.9.2-10)/libgcc-4.9-dev:armhf (>= 4.9.2-10)/g'       /var/lib/dpkg/status

sudo apt-get install libstdc++-4.9-dev:armhf -y
sudo apt-get install libncurses5-dev -y
sudo apt-get install libncursesw5-dev -y
sudo apt-get install cpio -y

sudo touch /etc/mtab
touch ~/.bashrc
if grep -q "LIBGL_ALWAYS_INDIRECT" ~/.bashrc; then
  echo 'LIBGL_ALWAYS_INDIRECT added'
else
  echo 'export DISPLAY=:0.0' >> ~/.bashrc
  echo 'export LIBGL_ALWAYS_INDIRECT=1' >> ~/.bashrc
fi

sudo apt-get install xfce4-terminal -y
sudo apt-get install xfce4 -y
sudo apt-get upgrade gtk2-engines-pixbuf -y
