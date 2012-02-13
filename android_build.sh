 NDKROOT="/home/indal.choi/bin/android-ndk-r7" \
 AR="$NDKROOT/toolchains/arm-linux-androideabi-4.4.3/prebuilt/linux-x86/bin/arm-linux-androideabi-ar" \
 LD="$NDKROOT/toolchains/arm-linux-androideabi-4.4.3/prebuilt/linux-x86/bin/arm-linux-androideabi-ld" \
 CC="$NDKROOT/toolchains/arm-linux-androideabi-4.4.3/prebuilt/linux-x86/bin/arm-linux-androideabi-gcc" \
 CPPFLAGS="--sysroot=$NDKROOT/platforms/android-9/arch-arm" \
 CFLAGS="--sysroot=$NDKROOT/platforms/android-9/arch-arm" \
 LDFLAGS="" \
   ./configure \
   --host=armv7-unknown-linux
