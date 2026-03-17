from launch import LaunchDescription
from launch_ros.actions import Node

def generate_launch_description():
    return LaunchDescription([
        # 1. Your Custom Status Node
        Node(
            package='jarvis_core',
            executable='status_node',
            name='status_node'
        ),
        # 2. The Rosbridge WebSocket Server
        Node(
            package='rosbridge_server',
            executable='rosbridge_websocket',
            name='rosbridge_websocket',
            parameters=[{'port': 9090}]
        )
    ])
