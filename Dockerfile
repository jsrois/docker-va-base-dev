FROM ubuntu:16.04

# Multiverse
RUN echo "deb http://us.archive.ubuntu.com/ubuntu xenial main multiverse" >> /etc/apt/sources.list

# Use this to avoid prompts when installing and updating stuff
ENV DEBIAN_FRONTEND=noninteractive

MAINTAINER "Javier Sánchez Rois" <jsanchez@gradiant.org>

# Upgrade, install common pytons scripts (required for add-apt-repository)and other dependencies

RUN apt-get update && \
 	apt-get install -y curl \
    software-properties-common \
    # OpenCV deps
    build-essential wget git cmake pkg-config libtiff5-dev \
    libjpeg-dev libjasper-dev libpng12-dev libwebp-dev \
    libopenexr-dev libgdal-dev libavcodec-dev libavformat-dev \
    libmp3lame-dev libswscale-dev libdc1394-22-dev \
    libgstreamer0.10-dev libgstreamer-plugins-base0.10-dev \
    libv4l-dev v4l-utils libfaac-dev libopencore-amrnb-dev \
    libopencore-amrwb-dev libtheora-dev libvorbis-dev \
    libxvidcore-dev libx264-dev x264 \
    yasm libtbb-dev libeigen3-dev libgtk2.0-dev \
    libvtk6-dev unzip qt5-default \
    #Caffe deps
    libprotobuf-dev libleveldb-dev libsnappy-dev \
    libhdf5-serial-dev protobuf-compiler libboost-all-dev \
    libgflags-dev libgoogle-glog-dev liblmdb-dev libatlas-base-dev && \
    apt-get autoremove


RUN add-apt-repository ppa:openjdk-r/ppa && \
 	apt-get install -y openjdk-8-jdk


RUN \
  mkdir opencv && cd opencv && \
  wget --tries=0 --read-timeout=20 https://github.com/Itseez/opencv/archive/3.1.0.zip && \
  git clone https://github.com/opencv/opencv_contrib -b "3.1.0" && \
  cd /opencv && unzip 3.1.0.zip && cd opencv-3.1.0 && mkdir -p build && \
  cd /opencv/opencv-3.1.0/build && \
  cmake -DBUILD_DOCS=off -DBUILD_PERF_TESTS=OFF -DBUILD_TESTS=OFF \
  -DWITH_TBB=ON -DWITH_V4L=ON -DWITH_QT=ON -DWITH_OPENGL=ON -DWITH_EIGEN=ON -DFORCE_VTK=TRUE -DWITH_VTK=ON -DWITH_IPP=OFF \
  -DOPENCV_EXTRA_MODULES_PATH=../../opencv_contrib/modules \
	-DBUILD_DOCS=off \
        -DBUILD_PERF_TESTS=OFF -DBUILD_TESTS=OFF \
	-DBUILD_opencv_apps=OFF \
        -DBUILD_opencv_aruco=OFF \
        -DBUILD_opencv_bgsegm=ON \
        -DBUILD_opencv_bioinspired=OFF \
        -DBUILD_opencv_calib3d=ON \
        -DBUILD_opencv_ccalib=ON \
        -DBUILD_opencv_cnn_3dobj=OFF \
        -DBUILD_opencv_contrib_world=OFF \
        -DBUILD_opencv_core=ON \
        -DBUILD_opencv_cvv=OFF \
        -DBUILD_opencv_datasets=OFF \
        -DBUILD_opencv_dnn=OFF \
        -DBUILD_opencv_dpm=OFF \
        -DBUILD_opencv_face=OFF \
        -DBUILD_opencv_features2d=ON \
        -DBUILD_opencv_flann=ON \
        -DBUILD_opencv_freetype=OFF \
        -DBUILD_opencv_fuzzy=OFF \
        -DBUILD_opencv_hdf=OFF \
        -DBUILD_opencv_highgui=ON \
        -DBUILD_opencv_imgcodecs=ON \
        -DBUILD_opencv_imgproc=ON \
        -DBUILD_opencv_line_descriptor=OFF \
        -DBUILD_opencv_ml=ON \
        -DBUILD_opencv_objdetect=ON \
        -DBUILD_opencv_optflow=OFF \
        -DBUILD_opencv_phase_unwrapping=OFF \
        -DBUILD_opencv_photo=ON \
        -DBUILD_opencv_plot=OFF \
        -DBUILD_opencv_reg=OFF \
        -DBUILD_opencv_rgbd=OFF \
        -DBUILD_opencv_saliency=OFF \
        -DBUILD_opencv_sfm=OFF \
        -DBUILD_opencv_shape=OFF \
        -DBUILD_opencv_stereo=ON \
        -DBUILD_opencv_stitching=ON \
        -DBUILD_opencv_structured_light=OFF \
        -DBUILD_opencv_superres=ON \
        -DBUILD_opencv_surface_matching=OFF \
        -DBUILD_opencv_text=OFF \
        -DBUILD_opencv_tracking=OFF \
        -DBUILD_opencv_ts=OFF \
        -DBUILD_opencv_video=ON \
        -DBUILD_opencv_videoio=ON \
        -DBUILD_opencv_videostab=ON \
        -DBUILD_opencv_viz=OFF \
        -DBUILD_opencv_world=OFF \
        -DBUILD_opencv_xfeatures2d=OFF \
        -DBUILD_opencv_ximgproc=OFF \
        -DBUILD_opencv_xobjdetect=OFF \
        -DBUILD_opencv_xphoto=OFF .. && \
        make -j4 && make install && \
        ldconfig && \
        rm -rf /opencv

RUN git clone https://github.com/BVLC/caffe.git && \
    mkdir caffe/build && cd caffe/build && \
    cmake -D ALLOW_LMDB_NOLOCK:BOOL=ON -D CMAKE_INSTALL_PREFIX:PATH=/usr/local -D BUILD_python=OFF -D CPU_ONLY=ON .. &&\
    make -j4 && make install && ldconfig && rm -rf /caffe

ENTRYPOINT ["/bin/bash"]
