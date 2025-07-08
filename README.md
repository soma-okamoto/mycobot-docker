

git clone https://github.com/soma-okamoto/mycobot-docker.git


# MyCobot MoveIt!2 Docker 環境

## 📖 概要

本リポジトリは、Elephant Robotics MyCobot（6自由度アーム）のパラメータCSVからURDFを自動生成し、ROS2 Humble + MoveIt!2環境をDockerコンテナでワンステップで構築・起動できる開発ワークスペースを提供します。

* ローカルにROSやMoveIt!2を直接インストール不要
* CSV編集だけで機構パラメータを変更可能
* GUI（RViz2）デモ起動対応
* GitHubにそのままプッシュできる構成

## 📂 ディレクトリ構成

```
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
```

## 🚀 動作環境

* **ホストOS**: 任意（Docker対応）
* **Docker**: 20.10以上
* **ROS2**: Humble Hawksbill
* **MoveIt!2**: 2.5.x
* **Python**: 3.10

### GUIモード起動時の補足

RViz2をコンテナ内で表示する場合は、Xサーバー側で以下を実行してください。

```bash
xhost +local:root
```

## 🛠️ Dockerイメージのビルド

リポジトリのルートディレクトリで以下を実行します。

```bash
cd mycobot-docker

docker build -t mycobot-moveit2 .
```

## ⚙️ コンテナ起動方法

### 1. 非GUIモード: URDF生成＋ワークスペースビルド

```bash
docker run --rm -v "$(pwd)":/workspace mycobot-moveit2 bash -lc \
  "cd src/csv2urdf && \
   python3 create_robot_csv.py /workspace/mycobot_params.csv mycobot && \
   mkdir -p ../sixdofarm_moveit_config/urdf && \
   cp mycobot.urdf ../sixdofarm_moveit_config/urdf/mycobot.urdf && \
   source /opt/ros/humble/setup.bash && \
   colcon build --cmake-args -DCMAKE_BUILD_TYPE=Release"
```

### 2. GUIモード: MoveIt!2 + RViz2デモ起動

```bash
# ホスト側でX11アクセス許可
xhost +local:root

# コンテナ起動
docker run -it --rm \
  --network host \
  -e DISPLAY=$DISPLAY \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  --device /dev/dri:/dev/dri \
  mycobot-moveit2 bash -lc "\
    source /opt/ros/humble/setup.bash && \
    source /workspace/install/setup.bash && \
    ros2 launch sixdofarm_moveit_config demo.launch.py"
```

![D.](https://github.com/soma-okamoto/mycobot-docker/blob/main/IMAGES/Screenshot%20from%202025-07-08%2017-04-01.png)



---

*最終更新: 2025-07-08*
