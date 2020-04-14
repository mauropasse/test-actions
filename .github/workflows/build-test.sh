#!/usr/bin/env bash

ls
THIS_DIR=$PWD

# Static Executor with waitable
cd ros2-performance/cross-compiling
bash get_ros2_sources.sh master

cd $THIS_DIR/ros2_cc_ws/src/ros2

# Download our perf framework
git clone https://github.com/irobot-ros/ros2-performance

# Use my own RCLCPP
rm -rf rclcpp
git clone https://github.com/mauropasse/rclcpp.git

# Ignore packages
cd ~/ROS/doc/cross-compiling-irobot-platforms/ros2-performance/cross-compiling
source env.sh raspbian
bash ignore_pkgs.sh $THIS_DIR/ros2_cc_ws/ master

# Compile
colcon \
    build \
    --merge-install \
    --cmake-force-configure \
    --cmake-args \
    -DCMAKE_VERBOSE_MAKEFILE:BOOL=ON \
    -DTHIRDPARTY=ON \
    -DBUILD_TESTING:BOOL=OFF

