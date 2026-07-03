#!/usr/bin/env bash
set -e

sudo apt update
sudo apt install -y software-properties-common curl

sudo add-apt-repository -y universe

ROS_APT_SOURCE_VERSION=$(
    curl -s https://api.github.com/repos/ros-infrastructure/ros-apt-source/releases/latest \
    | grep -F '"tag_name"' \
    | awk -F'"' '{print $4}'
)

curl -L \
    -o /tmp/ros2-apt-source.deb \
    "https://github.com/ros-infrastructure/ros-apt-source/releases/download/${ROS_APT_SOURCE_VERSION}/ros2-apt-source_${ROS_APT_SOURCE_VERSION}.$(. /etc/os-release && echo ${UBUNTU_CODENAME:-${VERSION_CODENAME}})_all.deb"

sudo dpkg -i /tmp/ros2-apt-source.deb

sudo apt update

sudo apt install -y \
    ros-jazzy-ros-base \
    build-essential \
    python3-colcon-common-extensions \
    python3-rosdep

grep -qxF 'source /opt/ros/jazzy/setup.bash' ~/.bashrc || \
    echo 'source /opt/ros/jazzy/setup.bash' >> ~/.bashrc

source /opt/ros/jazzy/setup.bash

sudo rosdep init 2>/dev/null || true
rosdep update
