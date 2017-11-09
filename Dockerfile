FROM ubuntu:latest

# Upgrade all the things
RUN apt update && apt upgrade -y

# normal dependencies
RUN apt install git curl wget software-properties-common build-essential cmake -y

# use repo with modern nodejs versions
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt update && apt install nodejs -y

# use repo with openfoam
RUN add-apt-repository "http://dl.openfoam.org/ubuntu dev" && \
    sh -c "wget -O - http://dl.openfoam.org/gpg.key | apt-key add -" && \
    add-apt-repository http://dl.openfoam.org/ubuntu
RUN apt update && apt install openfoam-dev -y

# source openfoam files
RUN /bin/bash -c "source /opt/openfoam-dev/etc/bashrc"

# gmsh specific dependencies
RUN apt install -y libvtk6-dev libproj-dev libcgns-dev libmetis-dev \
                   libhdf5-dev libfltk1.3-dev liblapack-dev libgmp-dev \
                   libjpeg-dev libsm-dev libice-dev gfortran


# install latest gmsh from repo
RUN git clone http://gitlab.onelab.info/gmsh/gmsh.git
RUN mkdir gmsh/build && cd gmsh/build && \
    CMAKE_PREFIX_PATH=/usr cmake .. && \
    make -j8 && \
    make install

CMD ["/bin/bash"]

