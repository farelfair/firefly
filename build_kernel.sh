#!/bin/bash

# setup color
red='\033[0;31m'
green='\e[0;32m'
white='\033[0m'
yellow='\033[0;33m'

# setup dir
WORK_DIR=$(pwd)
KERN_IMG="${WORK_DIR}/out/arch/arm64/boot/Image"
KERN_IMG2="${WORK_DIR}/out/arch/arm64/boot/Image.gz"

# clone clang
if [ ! -d "toolchain/clang-14" ]; then
    echo -e "\n"
    echo -e "$red << clone clang 14 version >> \n$white"
    echo -e "\n"
    git clone https://gitlab.com/mcdofrenchfreis/android-clang-14.0.7.git toolchain/clang-14
else
    echo -e "$red << clang found skipping clone >> \n$white"
fi

# anykernel3
if [ ! -d "AnyKernel3" ]; then
    echo -e "\n"
    echo -e "$yellow << clone AnyKernel3 >> \n$white"
    echo -e "\n"
    git clone https://github.com/Teg1715/AnyKernel3.git
else
    echo -e "$red << Anykernel3 found skipping clone >> \n$white"
fi

export PATH=${WORK_DIR}/toolchain/clang-14/bin:$PATH
export CROSS_COMPILE=${WORK_DIR}/toolchain/clang-14/bin/aarch64-linux-gnu-
export CC=${WORK_DIR}/toolchain/clang-14/bin/clang
export CLANG_TRIPLE=aarch64-linux-gnu-
export ARCH=arm64
export ANDROID_MAJOR_VERSION=r

make -C $(pwd) O=$(pwd)/out KCFLAGS=-w CONFIG_SECTION_MISMATCH_WARN_ONLY=y LLVM=1 LLVM_IAS=1 a05m_defconfig
make -C $(pwd) O=$(pwd)/out KCFLAGS=-w CONFIG_SECTION_MISMATCH_WARN_ONLY=y LLVM=1 LLVM_IAS=1 -j16

if [ -e "$KERN_IMG" ] || [ -e "$KERN_IMG2" ]; then
        echo -e "\n"
        echo -e "$green << compile kernel success! >> \n$white"
        echo -e "\n"
else
        echo -e "\n"
        echo -e "$red << compile kernel failed! >> \n$white"
        echo -e "\n"
fi

cp out/arch/arm64/boot/Image $(pwd)/arch/arm64/boot/Image
cp out/arch/arm64/boot/Image $(pwd)/AnyKernel3/