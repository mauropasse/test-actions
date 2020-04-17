FROM ubuntu:18.04

# working directory
ENV HOME /root
WORKDIR $HOME

# general utilities
RUN apt-get update && apt-get install -y \
    curl \
    vim \
    nano

# Set timezone otherwise tz will ask for it
RUN echo 'Etc/UTC' > /etc/timezone && \
    ln -s /usr/share/zoneinfo/Etc/UTC /etc/localtime && \
    apt-get update && apt-get install -q -y tzdata

# Locale options
RUN apt-get install -y locales
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

# Setup sources
RUN apt-get update && apt-get install -y curl gnupg2 lsb-release dirmngr bash-completion
RUN curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | apt-key add -
RUN sh -c 'echo "deb [arch=amd64,arm64] http://packages.ros.org/ros2/ubuntu `lsb_release -cs` main" > /etc/apt/sources.list.d/ros2-latest.list'
RUN apt-get update

# install development tools and ROS tools
RUN apt-get install -y \
  build-essential \
  cmake \
  git \
  python3-colcon-common-extensions \
  python3-pip \
  python3-rosdep \
  python3-vcstool \
  wget

# install python packages
RUN pip3 install -U \
  argcomplete \
  flake8 \
  flake8-blind-except \
  flake8-builtins \
  flake8-class-newline \
  flake8-comprehensions \
  flake8-deprecated \
  flake8-docstrings \
  flake8-import-order \
  flake8-quotes \
  pytest-repeat \
  pytest-rerunfailures \
  pytest \
  pytest-cov \
  pytest-runner \
  setuptools

# install Fast-RTPS dependencies
RUN apt-get install --no-install-recommends -y \
  libasio-dev \
  libtinyxml2-dev

# install CycloneDDS dependencies
RUN apt-get install --no-install-recommends -y \
  libcunit1-dev

# pip
RUN pip3 install --upgrade pip

# Install debug tools
RUN apt-get update && apt-get install -y \
  gdb \
  netcat \
  valgrind

WORKDIR $HOME

# get ROS2 code
RUN mkdir -p $HOME/ros2_ws/src
WORKDIR $HOME/ros2_ws
RUN wget https://raw.githubusercontent.com/ros2/ros2/master/ros2.repos
RUN vcs-import src < ros2.repos

# install dependencies using rosdep
RUN rosdep init
RUN rosdep update
RUN apt-get update
RUN rosdep install --from-paths src --ignore-src --rosdistro foxy -y --skip-keys "console_bridge fastcdr fastrtps libopensplice67 libopensplice69 rti-connext-dds-5.3.1 urdfdom_headers"

# build ros2 sdk workspace
RUN /bin/bash -c 'source /root/.bashrc; \
  colcon build --cmake-args --no-warn-unused-cli --symlink-install'

WORKDIR $HOME

# source everything when opening new bash
RUN echo ' \n\
echo "Sourcing ROS2 packages..." \n\
source /root/ros2_ws/install/setup.sh ' >> $HOME/.bashrc
