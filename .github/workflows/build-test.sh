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

