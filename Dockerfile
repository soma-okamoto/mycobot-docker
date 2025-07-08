FROM ros:humble

# 必要パッケージ
RUN apt-get update && \
    apt-get install -y git python3-pip python3-colcon-common-extensions \
      ros-humble-moveit ros-humble-joint-state-publisher \
      ros-humble-joint-state-publisher-gui ros-humble-controller-manager \
    && rm -rf /var/lib/apt/lists/*

# Python ライブラリ
RUN pip3 install numpy jinja2

WORKDIR /workspace

# CSV とソースをコピー
COPY mycobot_params.csv /workspace/
COPY src /workspace/src

# 1) CSV→URDF を生成して MoveIt!2 コンフィグに配置
RUN cd src/csv2urdf && \
    python3 create_robot_csv.py /workspace/mycobot_params.csv mycobot && \
    mkdir -p ../sixdofarm_moveit_config/urdf && \
    cp mycobot.urdf ../sixdofarm_moveit_config/urdf/mycobot.urdf

# 2) ee_link の <link> 定義を URDF の末尾に追加
RUN sed -i '/<\/robot>/i \
<link name="ee_link">\
  <collision>\
    <origin rpy="0 0 0" xyz="0 0 0.100"/>\
    <geometry><box size="0.05 0.05 0.02"/></geometry>\
  </collision>\
  <visual>\
    <origin rpy="0 0 0" xyz="0 0 0.100"/>\
    <geometry><box size="0.05 0.05 0.02"/></geometry>\
    <material name="gray"/>\
  </visual>\
  <inertial>\
    <origin rpy="0 0 0" xyz="0 0 0.100"/>\
    <mass value="0.02"/>\
    <inertia ixx="0.00001" ixy="0" ixz="0" iyy="0.00001" iyz="0" izz="0.00001"/>\
  </inertial>\
</link>' \
    src/sixdofarm_moveit_config/urdf/mycobot.urdf

# 3) デフォルトの moveit_setup_assistant が探すパスにもコピー
RUN mkdir -p /opt/ros/humble/share/moveit_setup_assistant && \
    cp src/sixdofarm_moveit_config/urdf/mycobot.urdf \
       /opt/ros/humble/share/moveit_setup_assistant/sixdofarm.urdf

# 4) Bash でソース→ビルド
SHELL ["/bin/bash","-lc"]
RUN source /opt/ros/humble/setup.bash && \
    colcon build --cmake-args -DCMAKE_BUILD_TYPE=Release
