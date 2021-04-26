# ffmpeg (PTH Standard)

## x264 (DTS-MA -> DTS)

```
ffmpeg -y -c:a dca -core_only true -i $SRC -c:v libx264 -profile:v high -preset slower \
-x264-params 'ref=4:crf=15.0:qcomp=0.8:aq-mode=3:aq-strength=0.8:bframes=11:me=umh:subme=11\
:merange=48:no-fast-pskip=1:no-dct-decimate=1:direct=auto:psy-rd=1.00,0.00:vbv-bufsize=78125\
:vbv-maxrate=62500:deblock=-3,-3:b-adapt=2:keyint=240:min-keyint=1:no-mbtree=1:trellis=2:\
chroma-qp-offset=-1:rc-lookahead=72' -max_muxing_queue_size 1024 \
-bsf:a dca_core -c:a copy -c:s copy -max_muxing_queue_size 1024 -map 0 -map -v -map V \
-report $DST 2>&1 | tee x264.log
```

## x265 10bit (DTS-MA -> DTS)

```
ffmpeg -y -c:a dca -core_only true -i $SRC -pix_fmt yuv420p10le -c:v libx265 -profile:v main10 \
-preset slower -x265-params 'crf=15.0:qcomp=0.8:aq-mode=3:aq-strength=0.8:pools=36:numa=48:rd=4:\
psy-rd=2.0:psy-rdoq=1.0:rdoq-level=2:deblock=-1,-1:cbqpoffs=-1:crqpoffs=-3:ctu=32:qg-size=8:\
no-sao=1:no-sao-non-deblock=1:selective-sao=0:tu-intra-depth=4:tu-inter-depth=4:no-opt-qp-pps=1:\
no-opt-ref-list-length-pps=1:aud=1:repeat-headers=1:me=3:subme=5:merange=48:b-intra=1:limit-tu=0:\
no-rect=1:no-amp=1:no-open-gop=1:pools=+:keyint=240:min-keyint=1:bframes=8:max-merge=4:ref=4:\
weightb=1:rc-lookahead=72:scenecut=40:no-strong-intra-smoothing=1:vbv-bufsize=160000:\
vbv-maxrate=160000:input-depth=10' -max_muxing_queue_size 1024 -bsf:a dca_core -c:a copy -c:s copy \
-max_muxing_queue_size 1024 -map 0 -map -v -map V -report $DST 2>&1 | tee x265.log 
```

## x264 (TrueHD -> DTS)

```
ffmpeg -y -i $SRC -c:v libx264 -profile:v high -preset slower -x264-params 'ref=4:crf=15.0:\
qcomp=0.8:aq-mode=3:aq-strength=0.8:bframes=11:me=umh:subme=11:merange=48:no-fast-pskip=1:\
no-dct-decimate=1:direct=auto:psy-rd=1.00,0.00:vbv-bufsize=78125:vbv-maxrate=62500:deblock=-3,-3:\
b-adapt=2:keyint=240:min-keyint=1:no-mbtree=1:trellis=2:chroma-qp-offset=-1:rc-lookahead=72' \
-max_muxing_queue_size 1024 -bsf:a dca_core -c:a dts -c:s copy -max_muxing_queue_size 1024 \
-map 0 -map -v -map V -strict -2 -report $DST 2>&1 | tee x264.log
```

## x265 10bit (TrueHD -> DTS)

```
ffmpeg -y -i $SRC -pix_fmt yuv420p10le -c:v libx265 -profile:v main10  -preset slower \
-x265-params 'crf=15.0:qcomp=0.8:aq-mode=3:aq-strength=0.8:pools=36:numa=48:rd=4:psy-rd=2.0:\
psy-rdoq=1.0:rdoq-level=2:deblock=-1,-1:cbqpoffs=-1:crqpoffs=-3:ctu=32:qg-size=8:no-sao=1:\
no-sao-non-deblock=1:selective-sao=0:tu-intra-depth=4:tu-inter-depth=4:no-opt-qp-pps=1:\
no-opt-ref-list-length-pps=1:aud=1:repeat-headers=1:me=3:subme=5:merange=48:b-intra=1:\
limit-tu=0:no-rect=1:no-amp=1:no-open-gop=1:pools=+:keyint=240:min-keyint=1:bframes=8:max-merge=4:\
ref=4:weightb=1:rc-lookahead=72:scenecut=40:no-strong-intra-smoothing=1:vbv-bufsize=160000:\
vbv-maxrate=160000:input-depth=10' -max_muxing_queue_size 1024 \
-bsf:a dca_core -c:a dts -c:s copy -max_muxing_queue_size 1024 -map 0 -map -v -map V \
-strict -2 -report $DST 2>&1 | tee x265.log 
```

## mkv meta info repair

```
mkvpropedit $DST --add-track-statistics-tags
```


## build ffmpeg on aarch64 

```
sudo apt install nasm
sed -i 's#execute cmake -DCMAKE_INSTALL_PREFIX="${WORKSPACE}" -DENABLE_SHARED=off -DBUILD_SHARED_LIBS=OFF ../../source#execute cmake -DCMAKE_INSTALL_PREFIX="${WORKSPACE}" -DENABLE_SHARED=off -DBUILD_SHARED_LIBS=OFF -DHIGH_BIT_DEPTH=ON ../../source#g' build-ffmpeg

./build-ffmpeg -b --enable-gpl-and-non-free
```

# Vapoursynth (PTH Standard)

## build vapoursynth on ubuntu20.04 x64

Bash script: 

```
sudo apt install -y autoconf build-essential libtool python3.8-dev cython3
VS_INSTALL_DIR=$HOME/.installs
export MAKEFLAGS=-j
mkdir -p $VS_INSTALL_DIR

cd $VS_INSTALL_DIR
git -C l-smash pull || git clone https://github.com/l-smash/l-smash.git
cd l-smash
./configure  --prefix=/usr --enable-shared
make lib $MAKEFLAGS
sudo make install-lib

cd $VS_INSTALL_DIR
git -C zimg pull || git clone https://github.com/sekrit-twc/zimg.git
cd zimg
./autogen.sh
./configure --prefix=/usr
make $MAKEFLAGS
sudo make install

cd $VS_INSTALL_DIR
wget https://www.imagemagick.org/download/ImageMagick.tar.gz
tar xvzf ImageMagick.tar.gz
cd ImageMagick*/
./configure --prefix=/usr
make $MAKEFLAGS
sudo make install

git -C vapoursynth pull || git clone https://github.com/vapoursynth/vapoursynth.git
cd vapoursynth
./autogen.sh
./configure
make $MAKEFLAGS
sudo make install
sudo ldconfig
```

## build x264 on Ubuntu20.04

```
sudo apt install -y nasm
X264_INSTALL_DIR=$HOME/.installs
export MAKEFLAGS=-j
mkdir -p $X264_INSTALL_DIR

cd $X264_INSTALL_DIR
git -C x264 pull || git clone https://code.videolan.org/videolan/x264.git x264
cd x264
./configure
make $MAKEFLAGS
sudo make install
```

## build x265(Yuuki version) on Ubuntu20.04

```
sudo apt install -y nasm libnuma-dev cmake
X265_INSTALL_DIR=$HOME/.installs
mkdir -p $X265_INSTALL_DIR

cd $X265_INSTALL_DIR
git -C x265 pull || git clone https://github.com/msg7086/x265-Yuuki-Asuna.git x265
cd x265/build/linux
export MAKEFLAGS=-j
./multilib.sh
sudo ln -s $PWD/8bit/x265 /usr/local/bin/x265
```