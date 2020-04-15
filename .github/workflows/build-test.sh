#!/usr/bin/env bash

THIS_DIR=$PWD
HOME=/home/runner

# Download our perf framework
git clone https://github.com/irobot-ros/ros2-performance

# Static Executor with waitable
cd $THIS_DIR/ros2-performance/cross-compiling
bash get_ros2_sources.sh master

cd $HOME/ros2_cc_ws/src/ros2

# Download our perf framework
cp -r $THIS_DIR/ros2-performance/performances .

# Use my own RCLCPP
rm -rf rclcpp
git clone https://github.com/mauropasse/rclcpp.git -b mauro/master

# That didn't work, install dependencies manually
apt-get install -y \
  build-essential \
  cmake \
  git \
  python3-colcon-common-extensions \
  python3-pip \
  python3-rosdep \
  python3-vcstool \
  wget

# install python packages
pip3 install -U \
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

apt-get install --no-install-recommends -y \
  libasio-dev \
  libtinyxml2-dev

# install CycloneDDS dependencies
apt-get install --no-install-recommends -y \
  libcunit1-dev
  
pip3 install --upgrade pip

cd $HOME/ros2_cc_ws
rosdep init
rosdep update
apt-get update
rosdep install --from-paths src --ignore-src --rosdistro foxy -y --skip-keys "console_bridge fastcdr fastrtps libopensplice67 libopensplice69 rti-connext-dds-5.3.1 urdfdom_headers"


# Install ROS2 dependencies (colcon build fails otherwise)
# Or as temporary workaround: ignore packages
cd $THIS_DIR/ros2-performance/cross-compiling
source env.sh raspbian
bash ignore_pkgs.sh $HOME/ros2_cc_ws

# Compile
cd $HOME/ros2_cc_ws
colcon build --symlink-install --packages-up-to benchmark

source install/setup.bash
cd install/benchmark/lib/benchmark

./benchmark topology/cedar.json 

cat cedar_log/resources.txt

