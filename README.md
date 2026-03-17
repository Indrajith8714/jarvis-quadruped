# J.A.R.V.I.S. Quadruped Robot
**Just A Rather Very Intelligent System** — A ROS2-powered 4-legged robotics platform with a Flutter-based HUD controller.

---

## 🛠 Project Architecture
This project is managed as a monorepo, separating the high-level control interface from the low-level robotics logic.

* **/firmware**: The "Brain" — ROS2 Jazzy packages running on a Raspberry Pi 5.
* **/ui**: The "Eyes/Hands" — A Flutter-based HUD for real-time telemetry and movement control.



---

## 🚀 Getting Started

### 1. The Brain (Raspberry Pi)
The Pi handles the ROS2 node graph, including the WebSocket bridge for remote communication.

**Prerequisites:** ROS2 Jazzy, Rosbridge Suite.

```bash
cd ~/ros2_ws
# Build the workspace
colcon build --base-paths firmware/src --packages-select jarvis_core
source install/setup.bash

# Launch the System (Starts Rosbridge + Status Node)
ros2 launch jarvis_core jarvis_launch.py
