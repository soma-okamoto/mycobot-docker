![D.](https://github.com/soma-okamoto/mycobot-docker/blob/main/IMAGES/Screenshot%20from%202025-07-08%2017-04-01.png)

git clone https://github.com/soma-okamoto/mycobot-docker.git

cd mycobot-docker

docker build -t mycobot-moveit2 .

docker run --rm -it --network host -e DISPLAY=$DISPLAY   -v /tmp/.X11-unix:/tmp/.X11-unix   mycobot-moveit2   bash -lc "\
    source /opt/ros/humble/setup.bash && \
    source /workspace/install/setup.bash && \
    ros2 launch sixdofarm_moveit_config demo.launch.py"
    
GUIモード起動時の補足：
RViz2をコンテナ内で表示する場合は、Xサーバー側で以下を実行してください。

xhost +local:root
