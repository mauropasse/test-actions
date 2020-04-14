#!/usr/bin/env bash

THIS_DIR=$PWD

# Download our perf framework
git clone https://github.com/irobot-ros/ros2-performance

# Static Executor with waitable
cd $THIS_DIR/ros2-performance/cross-compiling
bash get_ros2_sources.sh master

cd $THIS_DIR/ros2_cc_ws/src/ros2

# Download our perf framework
cp $THIS_DIR/ros2-performance/performances .

# Use my own RCLCPP
rm -rf rclcpp
git clone https://github.com/mauropasse/rclcpp.git

# Ignore packages
# cd $THIS_DIR/ros2-performance/cross-compiling
# source env.sh raspbian
# bash ignore_pkgs.sh $THIS_DIR/ros2_cc_ws/ master

# Compile
cd $THIS_DIR/ros2_cc_ws

colcon \
    build \
    --merge-install \
    --cmake-force-configure \
    --cmake-args \
    -DCMAKE_VERBOSE_MAKEFILE:BOOL=ON \
    -DTHIRDPARTY=ON \
    -DBUILD_TESTING:BOOL=OFF

