#0. Prerequisites
    a. cmake
    b. messon
    c. ninja
#1. pull and make dav1d
##  a. auto make
       cd ./main/cpp/dav1d/ext
       bash ./libdav1d_android.sh
##  b. manual make(such as arm64)
       dav1d repository：https://code.videolan.org/videolan/dav1d/-/tree/master
       git clone https://code.videolan.org/videolan/dav1d.git
       export NDK_BUILD=/Users/xyczero/Desktop/company/android-sdk-macosx/ndk/21.3.6528147/toolchains/llvm/prebuilt/darwin-x86_64/bin/
       export PATH=$PATH:$NDK_BUILD(https://developer.android.com/ndk/guides/other_build_systems)
       //target for arm64
       meson build --buildtype release --werror --libdir lib --prefix "$(pwd)/build/dav1d_install" --cross-file=package/crossfiles/aarch64-android.meson -Ddefault_library=both
       ninja -C build
       ninja -C build install
#2. make libavif  
    https://github.com/AOMediaCodec/libavif
