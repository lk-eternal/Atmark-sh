# Atmark-sh https://users.atmark-techno.com/

### Requirement: 

`ATDE6` & `Armadillo 840`

`atmark-dist-build.sh`: Build the romfs & linux kernel using `ATDE6`.

`atmark-dist-sd-write.sh`: Write the romfs & kernel & boot images into SD card.

### How to use:

```
wget https://raw.githubusercontent.com/arkceajin/Atmark-sh/master/atmark-dist-build.sh
bash atmark-dist-build.sh
```
find the device name of SD card using `cat /proc/partitions`, eg: `sdd`.

```
cd [atmark-dist dir]/images
bash atmark-dist-sd-write.sh sdd
```
### Why I did this?
Because ATDE6 provide armhf gcc 4.9 and it support C++11!!!
