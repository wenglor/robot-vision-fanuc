# Troubleshooting

## KAREL variables are uninitialized

- Run the KAREL program `W_LIBRARY` once to set the default values. It will return a cam error on the first run, but that is expected. After that, adjust the variables to your use case under **Data → Karel Vars**. See [Installation & Setup → Initialize the KAREL variables](../1_0_installation/index.md#initialize-the-karel-variables).
- Make sure the system variable `$KAREL_ENB` is set to `1` (**Menu → Next → System → Variables**). Without it, KAREL files cannot be used.

## Register conflicts

- The KAREL library writes its results to exchange registers (`R[60]`–`R[62]`, `PR[60]`, `SR[60]` by default) and uses `PR[65]` for the detection pose and `R[63]` for the PTP/LIN switch. Check that these do not conflict with the registers used by your own programs and change them via the KAREL variables if required. See [Robot Program → Exchange registers](../3_0_robot_program/index.md#exchange-registers).
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

For the general calibration guidelines, see the [Calibration Guidelines](https://wenglor.github.io/wenglor-robot-vision/4_0_robot_vision_server/4_1_calibration_guidelines/) in the wenglor robot vision manual.

## Height offset in detected poses

- Check that the uniVision job is set properly, especially the height offset from the calibration target to the object in **Device Robot Vision**.
- Ensure the correct tool frame (TCP) is active. See [Installation & Setup → Tool setup](../1_0_installation/index.md#tool-setup).

## Error codes returned by the device

If the robot server returns a negative error code (`-5001` … `-5010`), it indicates a problem on the vision-device side. For the meaning of each code, see the [Generic Robot Vision Interface → Error codes](https://wenglor.github.io/wenglor-robot-vision/4_0_robot_vision_server/4_5_0_generic_robot_vision_interface/#error-codes) in the wenglor robot vision manual.

| Code | Error message |
| --- | --- |
| `-5001` | General Error |
| `-5002` | Badly formatted request |
| `-5003` | No connection to uniVision |
| `-5004` | Unknown uniVision job name |
| `-5005` | Badly configured uniVision job |
| `-5006` | Calibration failed |
| `-5007` | No calibration data |
| `-5008` | No object found |
| `-5009` | Bad or empty device robot vision message |
| `-5010` | Index error |

## No user prompts during calibration

- The calibration process uses user prompts shown under **Menu → User**. Make sure the program is active so it can read the input.
- To answer a prompt, press **Deadman switch + SHIFT + F1** (`YES`) or **Deadman switch + SHIFT + F2** (`FALSE`) at the same time.
