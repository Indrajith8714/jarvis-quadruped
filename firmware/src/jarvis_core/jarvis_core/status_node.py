import rclpy
from rclpy.node import Node
from std_msgs.msg import String
import json

class StatusNode(Node):
    def __init__(self):
        super().__init__('status_node')
        self.publisher_ = self.create_publisher(String, 'robot_status', 10)
        self.timer = self.create_timer(1.0, self.timer_callback)
        self.get_logger().info("J.A.R.V.I.S. Status Node started (Hardware Disconnected Mode)")

    def timer_callback(self):
        # Mock data for now since hardware isn't plugged in
        status_data = {
            "battery_voltage": 0.0,
            "gyro_pitch": 0.0,
            "hardware_status": "Disconnected"
        }
        msg = String()
        msg.data = json.dumps(status_data)
        self.publisher_.publish(msg)

def main(args=None):
    rclpy.init(args=args)
    node = StatusNode()
    rclpy.spin(node)
    rclpy.shutdown()

if __name__ == '__main__':
    main()
