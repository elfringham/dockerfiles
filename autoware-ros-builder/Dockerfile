FROM ubuntu:xenial

ENV DEBIAN_FRONTEND=noninteractive

ENV BASE_DEPS="\
    build-essential \
    curl \
    python-catkin-pkg \
    python-rosdep \
    python-wstool \
    python3-colcon-common-extensions \
    ros-kinetic-catkin \
"

ENV ROSDEP_DEPS="\
    freeglut3-dev \
    gstreamer0.10-plugins-good \
    libarmadillo-dev \
    libcurl4-openssl-dev \
    libeigen3-dev \
    libgflags-dev \
    libgl1-mesa-dev \
    libglew-dev \
    libglu1-mesa-dev \
    libgoogle-glog-dev \
    libnlopt-dev \
    libopencv-dev \
    libpcap0.8-dev \
    libpcl-dev \
    libqt5opengl5-dev \
    libtinyxml-dev \
    libx11-dev \
    libxi-dev \
    libxml2-dev \
    libxmu-dev \
    libyaml-cpp-dev \
    python-flask \
    python-serial \
    qtbase5-dev \
    ros-kinetic-angles \
    ros-kinetic-automotive-platform-msgs \
    ros-kinetic-camera-info-manager \
    ros-kinetic-cmake-modules \
    ros-kinetic-cv-bridge \
    ros-kinetic-diagnostic-aggregator \
    ros-kinetic-diagnostic-msgs \
    ros-kinetic-diagnostic-updater \
    ros-kinetic-dynamic-reconfigure \
    ros-kinetic-eigen-conversions \
    ros-kinetic-geometry-msgs \
    ros-kinetic-gps-common \
    ros-kinetic-grid-map-cv \
    ros-kinetic-grid-map-msgs \
    ros-kinetic-grid-map-ros \
    ros-kinetic-grid-map-visualization \
    ros-kinetic-gscam \
    ros-kinetic-image-geometry \
    ros-kinetic-image-transport \
    ros-kinetic-imu-filter-madgwick \
    ros-kinetic-imu-tools \
    ros-kinetic-jsk-recognition-msgs \
    ros-kinetic-jsk-recognition-utils \
    ros-kinetic-jsk-rviz-plugins \
    ros-kinetic-jsk-topic-tools \
    ros-kinetic-message-filters \
    ros-kinetic-message-generation \
    ros-kinetic-message-runtime \
    ros-kinetic-nav-msgs \
    ros-kinetic-nlopt \
    ros-kinetic-nmea-msgs \
    ros-kinetic-nodelet \
    ros-kinetic-pcl-conversions \
    ros-kinetic-pcl-msgs \
    ros-kinetic-pcl-ros \
    ros-kinetic-pluginlib \
    ros-kinetic-robot-state-publisher \
    ros-kinetic-rosbag \
    ros-kinetic-rosbridge-server \
    ros-kinetic-rosconsole \
    ros-kinetic-roscpp \
    ros-kinetic-roslaunch \
    ros-kinetic-roslib \
    ros-kinetic-roslint \
    ros-kinetic-rospy \
    ros-kinetic-rostest \
    ros-kinetic-rosunit \
    ros-kinetic-rqt-plot \
    ros-kinetic-rviz \
    ros-kinetic-sensor-msgs \
    ros-kinetic-sound-play \
    ros-kinetic-std-msgs \
    ros-kinetic-std-srvs \
    ros-kinetic-stereo-msgs \
    ros-kinetic-tf \
    ros-kinetic-tf-conversions \
    ros-kinetic-tf2 \
    ros-kinetic-tf2-geometry-msgs \
    ros-kinetic-tf2-ros \
    ros-kinetic-visualization-msgs \
    ros-kinetic-xacro \
    v4l-utils \
"

ENV JENKINS_DEPS="\
    default-jdk-headless \
    openssh-server \
    sudo \
"

RUN echo "deb http://packages.ros.org/ros/ubuntu xenial main" > /etc/apt/sources.list.d/ros-latest.list ;\
    apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-key 421C365BD9FF1F717815A3895523BAEEB01FA116 ;\
    apt update -q=2 ;\
    apt upgrade -q=2 ;\
    apt install -q=2 -y --no-install-recommends ${BASE_DEPS} ${ROSDEP_DEPS} ${JENKINS_DEPS};\
    # Install setuptools from PyPI. The version shipped in Ubuntu is too old.
    curl -sLS https://bootstrap.pypa.io/get-pip.py -o /tmp/get-pip.py ;\
    python3 /tmp/get-pip.py ;\
    pip install --upgrade --no-cache-dir setuptools==40.8.0 ;\
    # Install lcov from source.
    git clone https://github.com/linux-test-project/lcov.git /tmp/lcov-1.14 ;\
    cd /tmp/lcov-1.14 && git checkout v1.14 && make install ;\
    # Setup buildslave user for Jenkins
    useradd -m buildslave ;\
    echo 'buildslave ALL = NOPASSWD: ALL' > /etc/sudoers.d/jenkins ;\
    chmod 0440 /etc/sudoers.d/jenkins ;\
    mkdir -p /var/run/sshd /home/buildslave/bin ;\
    # Cleanup
    apt clean ;\
    rm -rf /var/lib/apt/lists/* /tmp/get-pip.py /tmp/lcov-1.14

EXPOSE 22
COPY entrypoint.sh /root/
ENTRYPOINT ["/root/entrypoint.sh"]
