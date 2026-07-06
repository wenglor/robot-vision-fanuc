# FANUC Robots Vision Manual

> NOTE
>
> This manual focuses exclusively on FANUC Robots-specific topics. For general robot vision information, please refer to the [wenglor robot vision manual](https://wenglor.github.io/wenglor-robot-vision/).

This repository contains an example FANUC program to set up and start the generic vision interface to wenglor Machine Vision Devices on your FANUC robot.

The robot vision example for FANUC consists of the following files:

- `W_LIBRARY.pc` — KAREL library with all vision routines (socket communication, calibration, detection, conversions).
- `W_SINGLE_DETECT.tp` — single object detection TP program.
- `W_MULTI_DETECT.tp` — multiple object detection TP program.
- `W_UPDATE_REFERENCE_FRAME.tp` — reference-frame update TP program.
- `W_MOVE.tp` — helper TP program that moves the robot to a pose register (PTP or LIN).

> NOTE
>
> The robot example is available on [www.wenglor.com/product/DNNF023](https://www.wenglor.com/product/DNNF023) → Downloads → Programming examples and configuration files → Examples_Robot_Vision.
>
> - It was tested with the **FANUC R-30iB Mate Plus** robot controller with software **V9.40** and the **LR Mate 200iD** robot arm. Make sure to use the same software version on the FANUC robot controller.
> - Working with KAREL files requires the system variable `$KAREL_ENB` to be set to `1`.

---

## Table of Contents

1. [Installation & Setup](1_0_installation/index.md)
2. [User Configuration](2_0_user_configuration/index.md)
3. [Robot Program](3_0_robot_program/index.md)
4. [Troubleshooting](4_0_troubleshooting/index.md)
5. [Support & Feedback](5_0_support_and_feedback/index.md)

> NOTE
>
> The generic robot vision API (commands, return values, error codes), the calibration guidelines, and the uniVision job setup are documented once in the [wenglor robot vision manual](https://wenglor.github.io/wenglor-robot-vision/4_0_robot_vision_server/) and are **not** repeated here. This manual only describes how the FANUC example uses them.
