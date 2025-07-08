from launch import LaunchDescription
from launch_ros.actions import Node
from launch.actions import RegisterEventHandler
from launch.event_handlers import OnProcessExit
from moveit_configs_utils import MoveItConfigsBuilder
from moveit_configs_utils.launches import (
    generate_rsp_launch,
    generate_spawn_controllers_launch,
    generate_move_group_launch,
    generate_moveit_rviz_launch,
)
import os

def generate_launch_description():
    # 1) MoveIt 設定読み込み
    moveit_config = MoveItConfigsBuilder("mycobot", package_name="sixdofarm_moveit_config").to_moveit_configs()

    ld = LaunchDescription()

    # 2) ros2_control_node の起動
    ros2_control_node = Node(
        package='controller_manager',
        executable='ros2_control_node',
        parameters=[
            {'robot_description': moveit_config.robot_description},
            os.path.join(moveit_config.package_path, 'config', 'ros2_controllers.yaml'),
        ],
        output='screen'
    )
    ld.add_action(ros2_control_node)

    # 3) robot_state_publisher (rsp) の起動
    ld.add_action(generate_rsp_launch(moveit_config))

    # 4) コントローラのスポーン (joint_state_broadcaster + sixdofarm_controller)
    ld.add_action(generate_spawn_controllers_launch(moveit_config))

    # 5) move_group ノード
    ld.add_action(generate_move_group_launch(moveit_config))

    # 6) RViz2
    ld.add_action(generate_moveit_rviz_launch(moveit_config))

    return ld
