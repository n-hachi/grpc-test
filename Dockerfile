FROM ubuntu:20.04

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y \
    autoconf \
    autotools-dev \
    bash \
    build-essential \
    cmake \
    gdb \
    git \
    libtool \
    pkg-config \
    sudo \
    vim \
    && rm -rf /var/lib/apt/lists/*

ENV HOME /user
ENV MY_INSTALL_DIR $HOME/.local
ENV PATH $PATH:$MY_INSTALL_DIR
WORKDIR /user
RUN echo 'export PS1="[\u@docker] \W # "' >> /root/.bash_profile

RUN bash -xc " \
    git clone --recurse-submodules -b v1.37.1 https://github.com/grpc/grpc.git; \
    cd grpc; \
    mkdir -p cmake/build; \
    pushd cmake/build; \
    cmake -DgRPC_INSTALL=ON \
     -DgRPC_BUILD_TESTS=OFF \
     -DCMAKE_INSTALL_PREFIX=$MY_INSTALL_DIR \
     ../..; \
    make -j; \
    sudo make install; \
    popd; \
    "
RUN bash -xc " \
    cd grpc; \
    mkdir -p third_party/abseil-cpp/cmake/build; \
    pushd third_party/abseil-cpp/cmake/build; \
    cmake -DCMAKE_INSTALL_PREFIX=$MY_INSTALL_DIR \
     -DCMAKE_POSITION_INDEPENDENT_CODE=TRUE \
     ../..; \
    make -j; \
    sudo make install; \
    popd; \
    "
RUN bash -xc "\
    cd grpc; \
    pushd examples/cpp/route_guide; \
    mkdir -p cmake/build; \
    pushd cmake/build; \
    cmake ../..; \
    make; \
    "
RUN cp grpc/examples/cpp/route_guide/route_guide_db.json /user
RUN cp grpc/examples/cpp/route_guide/cmake/build/route_guide_server /user
RUN cp grpc/examples/cpp/route_guide/cmake/build/route_guide_client /user

CMD /bin/bash
