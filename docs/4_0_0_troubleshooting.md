# 4. Troubleshooting

| Symptom | Likely cause | Jump to |
| --- | --- | --- |
| KAREL variables show unexpected values | Variables never initialized | [KAREL variables are uninitialized](#karel-variables-are-uninitialized) |
| Robot moves to the wrong pose or overwrites another program's register | Exchange or detection registers collide with existing usage | [Register conflicts](#register-conflicts) |
| Socket errors, no response from the device | Network / socket messaging misconfigured | [Communication errors](#communication-errors) |
| High reprojection error, inaccurate detections | Too few or too similar calibration poses | [Insufficient calibration accuracy](#insufficient-calibration-accuracy) |
| Object detected but robot stops at the wrong height | uniVision height offset or tool frame incorrect | [Height offset in detected poses](#height-offset-in-detected-poses) |
| Negative value in an exchange register | Vision device returned an error code | [Error codes returned by the device](#error-codes-returned-by-the-device) |
| Calibration hangs, no prompt shown | Program inactive or Deadman switch not held | [No user prompts during calibration](#no-user-prompts-during-calibration) |

## KAREL variables are uninitialized

- Run the KAREL program `W_LIBRARY` once to set the default values. It will return a cam error on the first run, but that is expected. After that, adjust the variables to your use case under **Data → Karel Vars**. See [Installation & Setup → Initialize the KAREL variables](1_0_0_installation.md#initialize-the-karel-variables).
- Make sure the system variable `$KAREL_ENB` is set to `1` (**Menu → Next → System → Variables**). Without it, KAREL files cannot be used.

## Register conflicts

- The KAREL library writes its results to exchange registers (`R[60]`–`R[62]`, `PR[60]`, `SR[60]` by default) and uses `PR[65]` for the detection pose and `R[63]` for the PTP/LIN switch. Check that these do not conflict with the registers used by your own programs and change them via the KAREL variables if required. See [Robot Program → Exchange registers](3_0_0_robot_program.md#exchange-registers).
- If you change the detection pose register, update **both** the TP programs and the `w_detect_pose_reg` KAREL variable.

## Communication errors

- Verify that the network configuration matches your setup: robot controller IP (e.g. `192.168.100.11`) under **Menu → (6) Setup → Setup 2 → (9) Host Comm.** → TCP/IP, and the Machine Vision Device (default `192.168.100.1`, port `32006`) under the Host Comm **Clients**.
- Make sure the client tag configured in Host Comm (e.g. `C1:`) matches the `w_client_tag` KAREL variable.
- Ensure the robot server on the vision device is active: device website → Jobs → Processing Instance → Robot Server, with **Generic** selected as the robot manufacturer.
- Check general network connectivity and firewall rules between the controller and the device.

## Insufficient calibration accuracy

- Use more than five calibration poses (seven to eleven give better results). Add them to the `W_CALIB_POSES` array (**Data → Karel Pos**).
- Increase the variation between poses — especially in the pose angles. The variance of the calibration *movements* matters more than the variance of the poses.
- Make sure the calibration target covers as much of the camera image as possible and is fully visible.
- Prefer a wenglor ZVZJ calibration target over a printed one.
- Check the reprojection error returned by `calc_calibration` — high values indicate a poor calibration.

For the general calibration guidelines, see the [Wenglor Robot Server overview](https://wenglor.github.io/robot-vision-generic-string/4_0_0_robot_vision_server/) in the wenglor robot vision manual.

## Height offset in detected poses

- Check that the uniVision job is set properly, especially the height offset from the calibration target to the object in **Device Robot Vision**.
- Ensure the correct tool frame (TCP) is active. See [Installation & Setup → Tool setup](1_0_0_installation.md#tool-setup).

## Error codes returned by the device

If the robot server returns a negative error code (`-5001` … `-5010`), the KAREL library passes it through unchanged into the exchange register (or string register) that the calling routine writes to. This indicates a problem on the vision-device side, not in the KAREL library itself. For the meaning of each code, see [Generic Robot Vision Interface → Error codes](https://wenglor.github.io/robot-vision-generic-string/4_7_0_generic_robot_vision_interface/#error-codes) in the wenglor robot vision manual.

## No user prompts during calibration

- The calibration process uses user prompts shown under **Menu → User**. Make sure the program is active so it can read the input.
- To answer a prompt, press **Deadman switch + SHIFT + F1** (`YES`) or **Deadman switch + SHIFT + F2** (`NO`) at the same time.
