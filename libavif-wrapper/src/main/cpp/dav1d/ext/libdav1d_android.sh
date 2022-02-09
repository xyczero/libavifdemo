#!/bin/bash

# This script will build libgav1 for the default ABI targets supported by
# android. You must pass the path to the android NDK as a parameter to this
# script.
#
# Android NDK: https://developer.android.com/ndk/downloads
#
# The git tag below is known to work, and will occasionally be updated. Feel
# free to use a more recent commit.

#0. clone dav1d
#1. checkout tag version from dav1d
#2. make abi build
#3. copy：../cpp/dav1d/dav1d/include => ../cpp/dav1d/include

# run cmd: bash ./libdav1d_android.sh(bash对declare -A的支持>=version 4.1.2)

echo "input dav1d tag version, such as 0.9.2 :"
read tag
#/Users/xyczero/Desktop/company/android-sdk-macosx/ndk/21.3.6528147/
echo "input ndk path, such as xxxxx/android-sdk-macosx/ndk/21.3.6528147 :"
read ndkPath

cd ..
if [ ! -d "dav1d" ]; then
  git clone https://code.videolan.org/videolan/dav1d.git
  echo "git clone dav1d repository"
fi
cd dav1d

if git rev-parse --verify feature/${tag};then
  echo "the local feature/${tag} has been existed"
else
  git checkout -b feature/${tag} ${tag}
fi

## set environment variables
export NDK_BUILD=${ndkPath}/toolchains/llvm/prebuilt/darwin-x86_64/bin/
export PATH=$PATH:$NDK_BUILD
cd ..

## make abi build
declare -A ABI_MAP=()
ABI_MAP["armeabi-v7a"]="package/crossfiles/arm-android.meson"
ABI_MAP["arm64-v8a"]="package/crossfiles/aarch64-android.meson"
ABI_MAP["x86"]="../ext/crossfiles/x86-android.meson"
ABI_MAP["x86_64"]="../ext/crossfiles/x86_64-android.meson"
for abi in ${!ABI_MAP[*]}; do
  mkdir "${abi}"
  cd dav1d
  rm -rf build
  meson build --buildtype release --werror --libdir lib --prefix "$(pwd)/build/dav1d_install" --cross-file="${ABI_MAP[$abi]}" -Ddefault_library=both
  ninja -C build
  cp -v build/src/libdav1d.a ../${abi}/libdav1d.a
  cd ..
  # copy include content
  if [ ! -d "include" ]; then
    mkdir "include"
    cd dav1d
    cp -a include ../
    cp build/include/dav1d/version.h ../include/dav1d/version.h
    rm -f ../include/dav1d/version.h.in
    cp build/include/vcs_version.h ../include/vcs_version.h
    rm -f ../include/dav1d/vcs_version.h.in
    rm -f ../include/meson.build
    rm -f ../include/dav1d/meson.build
    echo "copy include success"
    cd ..
  fi
done

cd ../..