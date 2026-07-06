# Installation & Setup

The FANUC robot vision example is a KAREL library (`W_LIBRARY.pc`) together with a set of TP programs. Before running it, prepare the robot controller, the network connection to the Machine Vision Device, and the tool frame.

## Tested configuration

| Component | Value |
| --- | --- |
| Controller | FANUC R-30iB Mate Plus |
| Controller software | V9.40 (use the same version on your controller) |
| Robot arm | LR Mate 200iD |

## Files

Download the robot example from [www.wenglor.com/product/DNNF023](https://www.wenglor.com/product/DNNF023) → Downloads → Programming examples and configuration files → Examples_Robot_Vision. It consists of:

- `W_LIBRARY.pc` — the KAREL library containing all vision routines. See [User Configuration](../2_0_user_configuration/index.md).
- `W_SINGLE_DETECT.tp` — single object detection example.
- `W_MULTI_DETECT.tp` — multiple object detection example.
- `W_UPDATE_REFERENCE_FRAME.tp` — reference-frame update example.
- `W_MOVE.tp` — helper program that moves the robot to the exchange pose register (PTP or LIN).

## Network setup of robot controller

Adjust the network settings of the robot controller so it can reach the Machine Vision Device (by default `192.168.100.1`). Go to **Menu → (6) Setup → Setup 2 → (9) Host Comm.**

Select **TCP/IP** and enter the IP address of the robot controller (e.g. `192.168.100.11`).

<!-- PLACEHOLDER IMAGE: TCP/IP network settings screen on the FANUC teach pendant -->
![TODO: TCP/IP network settings](images/01_tcpip_network_settings.png)

## Socket messaging

To set the socket messaging client information, go to **Menu → (6) Setup → (9) Host Comm.** In this window, select **Show** (bottom bar) → **Clients**. Now select the client you want to use. In the example, we use **C1**. Set the IP address of the Machine Vision Device (by default `192.168.100.1`) and the port (by default `32006`).

For details, see socket messaging in the operating instructions of FANUC.

<!-- PLACEHOLDER IMAGE: Host Comm client (C1) configuration with device IP and port -->
![TODO: Socket messaging client C1](images/02_socket_messaging_client.png)

> NOTE
>
> The client tag configured here (e.g. `C1:`) must match the `w_client_tag` KAREL variable. See [User Configuration](../2_0_user_configuration/index.md).

## Tool setup

Go to **Menu → Setup → Frames → Other** (bottom bar) **→ Tool Frame**. In this window, select the tool ID. Select **Method** (bottom bar) and pick the method for setting the TCP (e.g. **Three Point**).

<!-- PLACEHOLDER IMAGE: Tool Frame setup with Three Point method -->
![TODO: Tool frame setup](images/03_tool_frame_setup.png)

## System variables

Check the system variables. Go to **Menu → Next → System → Variables**.

`$KAREL_ENB` needs to be set to `1` to enable working with KAREL files. `W_LIBRARY` is a KAREL file, so this is required.

<!-- PLACEHOLDER IMAGE: $KAREL_ENB system variable set to 1 -->
![TODO: $KAREL_ENB system variable](images/04_karel_enb_variable.png)

## Transfer files to the robot

To transfer the files to the robot, use **FTP** (set up similarly to socket messaging) or a **USB stick**.

For transferring the files via a USB stick:

1. Go to **Menu → File → File → UTIL** (bottom bar) **→ USB on TP** (or Teach Panel Slot) **/ USB Disk** (or Controller Slot).
2. Select and enter `*` (all files) **→ Copy** (bottom bar).
3. Select the target device **Mem Device (MD)** → select **DO_COPY** (bottom bar).

<!-- PLACEHOLDER IMAGE: File transfer from USB to Mem Device (MD) -->
![TODO: Transfer files via USB](images/05_transfer_files_usb.png)

> NOTE
>
> On the Machine Vision Device website (Tab `Jobs` → `Robot Server`), make sure the robot server is active and the robot manufacturer is set to **Generic** (string based). See [Settings on Device Website](https://wenglor.github.io/wenglor-robot-vision/4_0_robot_vision_server/4_2_0_settings_on_device_website/) in the wenglor robot vision manual.

## Initialize the KAREL variables

The KAREL program uses several variables that are uninitialized at first. To set the default values, run the KAREL program `W_LIBRARY` once. It will return a cam error, but that is expected in this case. After that you can adjust the variables to your use case in [User Configuration](../2_0_user_configuration/index.md).
