FROM ubuntu:latest

MAINTAINER harry@doverobinson.me

ENV GOESDUMP_WEB_URL https://github.com/opensatelliteproject/goesdump/releases/download/1.0.2-beta/goesdump-web.zip

RUN \
BUILD_PACKAGES='build-essential \
ca-certificates \
ca-certificates-mono \
cmake \
git \
nuget \
software-properties-common \
unzip \
wget' && \
RUN_PACKAGES='libaec0 \
libaec-dev \
libairspy-dev \
libhackrf0 \
libhackrf-dev \
libmono-corlib4.5-cil \
libmono-system4.0-cil \
libmono-system-core4.0-cil \
libusb-1.0-0-dev \
mono-devel \
monodevelop \
screen \
tzdata' && \
apt-get update && \
apt-get --no-install-recommends -y install $BUILD_PACKAGES && \
add-apt-repository ppa:myriadrf/drivers -y && \
add-apt-repository ppa:myriadrf/gnuradio -y && \
apt-get update && \
apt-get --no-install-recommends -y install $RUN_PACKAGES && \
rm -r /var/lib/apt/lists/* && \
mkdir /usr/src/osp-build/ && \
cd /usr/src/osp-build/ && \
git clone https://github.com/opensatelliteproject/xritdemod.git && \
cd xritdemod/ && \
make libcorrect && \
make libcorrect-install && \
make libSatHelper && \
make libSatHelper-install && \
make librtlsdr && \
make librtlsdr-install && \
make && \
make test && \
cd /usr/src/osp-build/ && \
git clone https://github.com/opensatelliteproject/goesdump.git && \
cd goesdump && \
git clone https://github.com/opensatelliteproject/decompressor.git && \
cd decompressor && \
mkdir build && \
cd build && \
cmake .. && \
make && \
make install && \
ldconfig && \
cd /usr/src/osp-build/goesdump/ && \
cert-sync /etc/ssl/certs/ca-certificates.crt && \
nuget restore goesdump.sln && \
mdtool build goesdump.sln -c:"Release|x86" && \
cd /root/ && \
mkdir goesdump && \
cd goesdump && \
cp -r /usr/src/osp-build/goesdump/goesdump/bin/Release/* . && \
chmod +x goesdump.exe && \
wget "$GOESDUMP_WEB_URL" && \
unzip goesdump-web.zip && \
rm goesdump-web.zip && \
mv build web && \
cd /root/ && \
mkdir xritdemod && \
cd xritdemod && \
cp /usr/src/osp-build/xritdemod/decoder/build/xritDecoder . && \
cp /usr/src/osp-build/xritdemod/demodulator/build/xritDemodulator . && \
chmod +x * && \
rm -r /usr/src/osp-build/ && \
apt-get purge -y --auto-remove $BUILD_PACKAGES

WORKDIR /root/run/

CMD ["/bin/bash", "run.sh"]
