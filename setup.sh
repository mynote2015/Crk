#!/bin/sh

CURRENTPATH=$(pwd)

# 1. Install Binutils/Essentials/wget/git

sudo apt-get install -y gcc gdb build-essential binutils binutils-powerpc-linux-gnu binutils-multiarch wget git

# 2. Install other dependencies

sudo apt-get install -y libpcap-dev uml-utilities libelf-dev libelf1 zlib1g zlib1g-dev

# 3. Install hex editor

sudo apt-get install -y ht hexedit

# 4. Install dynamips & gdb stub

git clone https://github.com/Groundworkstech/dynamips-gdb-mod
cd dynamips-gdb-mod/src
# Path to libelf is wrong, we need to change it
cat Makefile | sed -e 's#/usr/lib/libelf.a#-lz -lelf /usr/lib/x86_64-linux-gnu/libelf.a#g' >Makefile.1
mv Makefile Makefile.bak
mv Makefile.1 Makefile
# Complie it!
DYNAMIPS_ARCH=amd64 make
cd ../../

# 5. Install pcalc(Programmer Caculator)

git clone https://github.com/vapier/pcalc
# This software depends on bison and flex, you need to install them first
sudo apt-get install -y bison flex
cd pcalc
make
sudo make install
cd ../

# 6. Install QEMU

sudo apt-get install -y qemu qemu-system qemuctl qemu-system-mips qemu-system-misc qemu-system-ppc qemu-system-x86

# Get other components for qemu

cd /usr/share/qemu
sudo mkdir ../openbios/
sudo mkdir ../slof/
sudo mkdir ../openhackware/
cd ../openbios
sudo wget https://github.com/qemu/qemu/raw/master/pc-bios/openbios-ppc
sudo wget https://github.com/qemu/qemu/raw/master/pc-bios/openbios-sparc32
sudo wget https://github.com/qemu/qemu/raw/master/pc-bios/openbios-sparc64
cd ../openhackware
sudo wget https://github.com/qemu/qemu/raw/master/pc-bios/ppc_rom.bin
cd ../slof
sudo wget https://github.com/qemu/qemu/raw/master/pc-bios/slof.bin
sudo wget https://github.com/qemu/qemu/raw/master/pc-bios/spapr-rtas.bin

# Switch to the setup directory
cd $CURRENTPATH

# 7. Get Debian PowerPC Image

wget https://people.debian.org/~aurel32/qemu/powerpc/debian_wheezy_powerpc_standard.qcow2
wget https://people.debian.org/~aurel32/qemu/mips/debian_wheezy_mips_standard.qcow2
