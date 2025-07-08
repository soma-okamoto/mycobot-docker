# mycobot-docker
/動作環境
ホストOS: 任意（Docker対応）
Docker: 20.10以上
ROS2: Humble Hawksbill
MoveIt!2: 2.5.x
Python: 3.10/

git clone https://github.com/soma-okamoto/mycobot-docker.git

cd mycobot-docker

GUIモード起動時の補足
RViz2をコンテナ内で表示する場合は、Xサーバー側で以下を実行してください。
xhost +local:root

docker build -t mycobot-moveit2 .

docker run --rm -it --network host -e DISPLAY=$DISPLAY   -v /tmp/.X11-unix:/tmp/.X11-unix   mycobot-moveit2   bash -lc "\
    source /opt/ros/humble/setup.bash && \
    source /workspace/install/setup.bash && \
    ros2 launch sixdofarm_moveit_config demo.launch.py"



構成
├── Dockerfile                       # Dockerイメージ定義
├── mycobot_params.csv               # パラメータCSV（関節・リンク設定）
├── README.md                        # 本ドキュメント
└── src/
    ├── csv2urdf/                    # CSV→URDF生成スクリプト
    └── sixdofarm_moveit_config/     # MoveIt!2設定パッケージ
        ├── urdf/
        │   └── mycobot.urdf         # 自動生成URDF
        ├── config/                   # コントローラ設定など
        ├── launch/
        │   └── demo.launch.py       # デモ起動Launchファイル
        └── ...
