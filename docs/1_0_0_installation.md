# 1. Installation & Setup

The FANUC robot vision example is a KAREL library (`W_LIBRARY`) together with a set of TP programs. Before running it, prepare the robot controller, the network connection to the Machine Vision Device, and the tool frame.

## Tested configuration

/// html | div.col-widths
    attrs: {style: "--w1: 30%; --w2: 70%;"}
| Component | Value |
| --- | --- |
| Controller | FANUC R-30iB Mate Plus |
| Controller software | **V9** (9.10, 9.30 and 9.40) and **V10** (10.10) |
| Robot arm | LR Mate 200iD |
///

!!! warning

    Make sure your FANUC robot controller runs one of the supported software versions, and use the file set that matches it. See [Files](#files).

## Files

The example files are in the [`sources`](https://github.com/wenglor/robot-vision-fanuc/tree/main/sources) directory of this repository. They are provided once per controller software generation, in the folders `V9` and `V10`. **Transfer only the set that matches your controller software.**

/// html | div.col-widths
    attrs: {style: "--w1: 35%; --w2: 65%;"}
| File | Description |
| --- | --- |
| `V9/`, `V10/` | One complete file set per controller software generation: `V9` for the software versions 9.10, 9.30 and 9.40, `V10` for 10.10. |
| `w_library.pc` | The KAREL library containing all vision routines. See [User Configuration](2_0_0_user_configuration.md). |
| `w_library.kl` | KAREL source code of the library, for reference and for recompiling it yourself. |
| `w_single_detect.tp` | Single object detection example. |
| `w_multi_detect.tp` | Multiple object detection example. |
| `w_update_reference_frame.tp` | Reference-frame update example. |
| `w_move.tp` | Helper program that moves the robot to the exchange pose register (PTP or LIN). |
///

The two library variants differ only in how they read and write the active tool frame through the controller's system variables; the routines, the KAREL variables, and the exchange registers are identical.

For reading the TP programs without a teach pendant, the `sources` directory also contains the plain-text listings `W_SINGLE_DETECT.LS`, `W_MULTI_DETECT.LS`, `W_UPDATE_REFERENCE_FRAME.LS` and `W_MOVE.LS`. They are documentation only — transfer the `.tp` files from the `V9` or `V10` folder to the controller.

## Commissioning steps

```mermaid
graph LR
    A[Network setup] --> B[Socket messaging]
    B --> C[Tool setup]
    C --> D["System variables<br>$KAREL_ENB = 1"]
    D --> E["Transfer files<br>(V9 or V10 set)"]
    E --> F["Initialize KAREL vars<br>(run W_LIBRARY once)"]
    F --> G[User Configuration]
```

## Network setup of robot controller

Adjust the network settings of the robot controller so it can reach the Machine Vision Device (by default `192.168.100.1`). Go to **Menu → (6) Setup → Setup 2 → (9) Host Comm.**

Select **TCP/IP** and enter the IP address of the robot controller (e.g. `192.168.100.11`).

<table>
<tr>
<td>
<figure>
<img src="images/host_com.png" alt="Select Host Com" class="uniform-width-400"/>
</figure>
</td>
<td>
<figure>
<img src="images/robot_ip_setup.png" alt="Robot IP address" class="uniform-width-400"/>
</figure>
</td>
</tr>
</table>

## Socket messaging

To set the socket messaging client information, go to **Menu → (6) Setup → Setup 2 → (9) Host Comm.** In this window, select **Show** (bottom bar) → **Clients**. Select the client you want to use — in this example, **C1**. Set the IP address of the Machine Vision Device (by default `192.168.100.1`) and the port (by default `32006`).

For details, see the Socket Messaging section in the FANUC operating instructions.

Connect the Machine Vision Device to **port 1 or port 2** of the FANUC controller. Port 3 of the FANUC controller is not supported.

<figure class="align-left">
<img src="images/socket_messaging.png" alt="Socket messaging client C1" class="uniform-width-400"/>
</figure>

!!! warning

    The client tag configured here (e.g. `C1:`) must match the `w_client_tag` KAREL variable. See [User Configuration](2_0_0_user_configuration.md).

## Tool setup

Go to **Menu → Setup → Frames → Other** (bottom bar) **→ Tool Frame**. In this window, select the tool ID. Select **Method** (bottom bar) and pick the method for setting the TCP (e.g. **Three Point**).

<figure class="align-left">
<img src="images/set_tcp_three_point.png" alt="Tool frame setup via the three point method" class="uniform-width-200"/>
</figure>

Note the tool frame number you selected and enter it in the KAREL variable `w_tool_no`. The library writes it to `R[64]` on start-up, and the TP programs activate it with `UTOOL_NUM=R[64]`. Do the same for the user frame number in `w_frame_no`, which is passed to `R[65]` and activated with `UFRAME_NUM=R[65]`. See [User Configuration](2_0_0_user_configuration.md).

## System variables

Check the system variables. Go to **Menu → Next → System → Variables**.

`$KAREL_ENB` needs to be set to `1` to enable working with KAREL files. `W_LIBRARY` is a KAREL file, so this is required.

## Transfer files to the robot

To transfer the files to the robot, use **FTP** (set up similarly to socket messaging) or a **USB stick**. Copy the files from the `V9` or `V10` folder that matches your controller software — do not mix the two sets.

For transferring the files via a USB stick:

1. Go to **Menu → File → UTIL** (bottom bar) **→ USB on TP** (or Teach Panel Slot) **/ USB Disk** (or Controller Slot).
2. Select and enter `*` (all files) **→ Copy** (bottom bar).
3. Select the target device **Mem Device (MD)** → select **DO_COPY** (bottom bar).

<figure class="align-left">
<img src="images/transfer_files.png" alt="Transfer files via USB" class="uniform-width-400"/>
</figure>

!!! note

    On the Machine Vision Device website (**Jobs → Processing Instance → Robot Server**), make sure the robot server is active and the robot manufacturer is set to **Generic** (string based). See [Settings on Device Website](https://wenglor.github.io/robot-vision-generic-string/5_2_0_settings_on_device_website/) in the wenglor robot vision manual.

## Initialize the KAREL variables

The KAREL program uses several variables that are uninitialized at first. To set the default values, run the KAREL program `W_LIBRARY` once. It will return a cam error, but that is expected in this case. After that you can adjust the variables to your use case in [User Configuration](2_0_0_user_configuration.md).
