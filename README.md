# mycobot-docker
git clone https://github.com/soma-okamoto/mycobot-docker.git

cd mycobot-docker
docker build -t mycobot-moveit2 .

docker run -it --rm \
  --network host \
  -e DISPLAY=$DISPLAY \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  mycobot-moveit2 \
  bash -lc "\
    source /opt/ros/humble/setup.bash && \
    source /workspace/install/setup.bash && \
    ros2 launch sixdofarm_moveit_config demo.launch.py"
