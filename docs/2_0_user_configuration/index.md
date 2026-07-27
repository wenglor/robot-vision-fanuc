# User Configuration

All parameters you need to adapt to your setup are KAREL variables of the `W_LIBRARY` program. Adjust them according to your needs before running the example.

To access the KAREL variables, select the corresponding PC file `W_LIBRARY`, then go to **Data → Type** (bottom bar) **→ Karel Vars**.

<!-- PLACEHOLDER IMAGE: Karel Vars list for W_LIBRARY -->
![TODO: Karel Vars for W_LIBRARY](images/01_karel_vars.png)

> NOTE
>
> The variables are uninitialized until you run `W_LIBRARY` once. See [Installation & Setup → Initialize the KAREL variables](../1_0_installation/index.md#initialize-the-karel-variables).

## User configurable KAREL variables

The following variables (prefix `w_`) can be adjusted under **Data → Karel Vars** after selecting the KAREL program `W_LIBRARY`.

| Variable | Default | Note |
| --- | --- | --- |
| `w_client_tag` | `C1:` | Host Comm client tag configured for the vision device (see [Socket messaging](../1_0_installation/index.md#socket-messaging)). |
| `w_use_case` | `camera_on_robot` | Either `camera_on_robot` or `camera_not_on_robot`. |
| `w_calib_target` | `zvzj002` | ID of calibration target (`zvzj001`, `zvzj002`, `zvzj003`, `zvzj004`). |
| `w_calib_job` | `calibration.u3p` | uniVision job for calibration. |
| `w_exch_reg_1` | `60` | Primary output register (R) for BOOLEAN / INTEGER / REAL. |
| `w_exch_reg_2` | `61` | Secondary output register (R). |
| `w_exch_reg_3` | `62` | Tertiary output register (R). |
| `w_pose_exch_reg` | `60` | Output pose register (PR). |
| `w_string_exch_reg` | `60` | Output string register (SR). |
| `w_detect_pose_reg` | `65` | Detection pose register (PR) — keep in sync with the PR referenced by the TP programs. |
| `w_use_ptp_reg` | `63` | Register (R) used to switch `W_MOVE` between PTP (`1`) and LIN (`0`). |
| `w_group_no` | `1` | Robot group number. |

> WARNING
>
> Variables with a `wi_` prefix are internal and **must not** be changed.

## Calibration poses (`W_CALIB_POSES`)

| Variable | Note |
| --- | --- |
| `w_calib_poses` | Array of up to eleven XYZWPR calibration poses (minimum five required). Set under **Data → Karel Pos**. |

The KAREL library exchanges registers to write the results of the commands. Please check whether these registers conflict with your own register usage and change them if required.

## Set the calibration and detection poses

Set up a maximum of eleven calibration poses (at least five). Depending on the use case, the detection pose is handled differently:

- **Camera on robot:** The detection pose is set during the calibration and also used for the validation.
- **Camera not on robot:** The detection pose needs to be set by the user. It is also used as a retreat pose after the calibration movement — in which you remove the calibration plate from the robot and place it on the object ground — and for the validation.
- **Both cases:** Set the detection pose in a global register. By default, pose register **65** (`PR[65]`) is used, as you can see in the provided example programs `W_SINGLE_DETECT` and `W_MULTI_DETECT`.

Select the KAREL file `W_LIBRARY` → **Data → Karel Pos → W_CALIB_POSES**.

<!-- PLACEHOLDER IMAGE: W_CALIB_POSES array under Karel Pos -->
![TODO: W_CALIB_POSES](images/02_calib_poses.png)

Set the detection pose. By default, pose register `PR[65]` is used. If `PR[65]` is used for other purposes, you can pick another PR, but then you need to update the TP programs accordingly. If you change the detection pose register, also update the `w_detect_pose_reg` KAREL variable.

<!-- PLACEHOLDER IMAGE: Detection pose in PR[65] -->
![TODO: Detection pose PR[65]](images/03_detection_pose.png)

> NOTE
>
> For the general calibration concepts — which calibration target to use, how to choose and vary the poses, and how to read the reprojection error — see the [Calibration Guidelines](https://wenglor.github.io/robot-vision-generic-string/4_0_robot_vision_server/4_1_calibration_guidelines/) in the wenglor robot vision manual. They are not repeated here.
