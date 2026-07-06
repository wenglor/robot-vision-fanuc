# Example FANUC program files for the generic vision interface

**Version:** 1.0.0

This repository demonstrates how to use the Generic Vision Interface with wenglor vision devices on a FANUC controller. The included KAREL library (`W_LIBRARY.pc`) and TP programs form a working sample program that you can adopt and customize for your application.

> NOTE
>
> This repository focuses exclusively on FANUC Robots-specific topics. For general robot vision information, please refer to the [wenglor robot vision manual](https://wenglor.github.io/wenglor-robot-vision/).

📖 **Full documentation** is available in the [online manual](https://wenglor.github.io/wenglor-fanuc-robots-vision/)

---

## Table of Contents

- [Prerequisites](#prerequisites)
- [Files](#files)
- [Installation](#installation)
- [Running the Sample Program](#running-the-sample-program)
- [Configuration (`W_LIBRARY` KAREL variables)](#configuration-w_library-karel-variables)
  - [Network & Socket Setup](#network--socket-setup)
  - [Adjusting Parameters](#adjusting-parameters)
  - [Teaching Poses](#teaching-poses)
- [Troubleshooting](#troubleshooting)
- [Support & Feedback](#support--feedback)

---

## Prerequisites

> Tested with a FANUC R-30iB Mate Plus controller (software V9.40) and an LR Mate 200iD robot arm.

- Basic knowledge of **TP** and **KAREL** programming.
- A FANUC controller with the system variable `$KAREL_ENB` set to `1`.
- **Socket Messaging** (Host Comm client) configured for the vision device.
- A [B60](https://www.wenglor.com/en/Machine-Vision/Smart-Cameras-and-Vision-Sensors/Smart-Camera-B60/c/cxmCID221375) or [Machine Vision Controller (MVC)](https://www.wenglor.com/en/Machine-Vision/Machine-Vision-Controllers/c/cxmCID221381).
- A [uniVision](https://www.wenglor.com/en/Machine-Vision/Machine-Vision-Software/Image-Processing-Software-uniVision-3/c/cxmCID222459) job for calibration and object detection.

---

## Files

| File | Description |
| --- | --- |
| `W_LIBRARY.pc` | KAREL library with all vision routines and user-adjustable variables. |
| `W_SINGLE_DETECT.tp` | Single object detection example. |
| `W_MULTI_DETECT.tp` | Multiple object detection example. |
| `W_UPDATE_REFERENCE_FRAME.tp` | Reference-frame update example. |
| `W_MOVE.tp` | Helper program that moves the robot to the exchange pose register (PTP or LIN). |

---

## Installation

1. Get the files from the [sources](sources) directory.
2. Transfer them to the robot controller via **FTP** or a **USB stick** (target device **Mem Device (MD)**).
3. Make sure `$KAREL_ENB` is set to `1`.
4. Run `W_LIBRARY` once to initialize the KAREL variables (it returns a cam error on the first run — that is expected).
5. Follow the [configuration](#configuration-w_library-karel-variables) steps.

---

## Running the Sample Program

1. Select `W_SINGLE_DETECT`, `W_MULTI_DETECT` or `W_UPDATE_REFERENCE_FRAME`.
2. If no calibration data is present on the device, the calibration process starts automatically. Answer the prompts under **Menu → User** using **Deadman + SHIFT + F1/F2**.
3. Execute the program and monitor the messages on the teach pendant.

---

## Configuration (`W_LIBRARY` KAREL variables)

Adjust the variables under **Data → Karel Vars** after selecting the `W_LIBRARY` program.

### Network & Socket Setup

- Set the robot controller IP under **Menu → (6) Setup → Setup 2 → (9) Host Comm → TCP/IP** (e.g. `192.168.100.11`).
- Configure the Host Comm client (e.g. `C1`) with the device IP (default `192.168.100.1`) and port (default `32006`).
- Make sure the client tag matches the `w_client_tag` KAREL variable (default `C1:`).

### Adjusting Parameters

| Variable | Default | Note |
| --- | --- | --- |
| `w_client_tag` | `C1:` | Host Comm client tag. |
| `w_use_case` | `camera_on_robot` | `camera_on_robot` or `camera_not_on_robot`. |
| `w_calib_target` | `zvzj002` | Calibration target (`zvzj001`–`zvzj004`). |
| `w_calib_job` | `calibration.u3p` | uniVision calibration job. |
| `w_detect_pose_reg` | `65` | Detection pose register (PR). Keep in sync with the TP programs. |

See the [User Configuration](https://wenglor.github.io/wenglor-fanuc-robots-vision/2_0_user_configuration/) page for the full list.

### Teaching Poses

Set up to eleven calibration poses (minimum five) in the `W_CALIB_POSES` array under **Data → Karel Pos**. Set the detection pose in `PR[65]` (or another PR, if you also update `w_detect_pose_reg` and the TP programs).

---

## Troubleshooting

- **Communication errors:** verify the controller IP, the Host Comm client (IP/port), and that the robot server on the device is active with **Generic** selected.
- **KAREL variables uninitialized:** run `W_LIBRARY` once and check that `$KAREL_ENB = 1`.
- **Insufficient calibration accuracy:** use more, more-varied poses and a wenglor ZVZJ target.

See the [Troubleshooting](https://wenglor.github.io/wenglor-fanuc-robots-vision/4_0_troubleshooting/) page for more.

---

## Support & Feedback

- **Bugs:** Please open a new Issue in the [GitHub Issues section](../../issues) if needed.
- **Feature Requests & Ideas:** Discuss suggestions in the Discussions → Ideas category under [GitHub Discussions](../../discussions).
