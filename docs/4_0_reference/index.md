# KAREL Reference

Look-up reference for the `W_LIBRARY` KAREL backend: the exchange registers it writes to, the routines you can call, and the unit conventions it maps between the generic robot vision API and FANUC.

For the workflow that uses these routines, see [Robot Program](../3_0_robot_program/index.md). For the variables that configure them, see [User Configuration](../2_0_user_configuration/index.md).

## Exchange registers

These are the default registers used to return values from the KAREL routines. They are editable via the KAREL variables (select the `W_LIBRARY` program). See [User Configuration](../2_0_user_configuration/index.md).

| Register | KAREL variable | Note |
| --- | --- | --- |
| `R[60]` | `w_exch_reg_1` | Used for single and multiple output routines. Can contain BOOLEAN, INTEGER and REAL. |
| `R[61]` | `w_exch_reg_2` | Only used if two or more outputs are required. Can contain BOOLEAN, INTEGER and REAL. |
| `R[62]` | `w_exch_reg_3` | Placeholder for routines with more than two outputs. Can contain BOOLEAN, INTEGER and REAL. |
| `PR[60]` | `w_pose_exch_reg` | Output pose, e.g. object pose or calibration target pose (validation). |
| `SR[60]` | `w_string_exch_reg` | Output string, e.g. additional value or current uniVision job name. |

## Callable KAREL routines

Call a routine with `CALL W_LIBRARY('<routine>' [, <arg>])`. The results are written to the exchange registers above.

| Routine | Input | Example | Output |
| --- | --- | --- | --- |
| `cam_status` | — | `CALL W_LIBRARY('cam_status')` | `w_exch_reg_1`: `1` (calibration data found) or `0` (no calibration data). |
| `load_job` | 1. job name | `CALL W_LIBRARY('load_job','find_objects.u3p')` | — |
| `get_job` | — | `CALL W_LIBRARY('get_job')` | `w_string_exch_reg`: name of active uniVision job. |
| `clear_calib_buffer` | — | `CALL W_LIBRARY('clear_calib_buffer')` | — |
| `add_calib_pose` | — | `CALL W_LIBRARY('add_calib_pose')` | — |
| `calc_calibration` | — | `CALL W_LIBRARY('calc_calibration')` | `w_exch_reg_1`: reprojection error / accuracy of the intrinsic camera calibration. |
| `calib_to_ground` | — | `CALL W_LIBRARY('calib_to_ground')` | — |
| `calib_to_target` | — | `CALL W_LIBRARY('calib_to_target')` | — |
| `run_calibration` | — | `CALL W_LIBRARY('run_calibration')` | — |
| `validate_calibration` | 1. safety offset in mm (REAL) | `CALL W_LIBRARY('validate_calibration', 10.5)` | Moves robot to the target for visual validation. |
| `calibrate_if_needed` | 1. safety offset in mm (REAL) | `CALL W_LIBRARY('calibrate_if_needed', 10.5)` | Runs a calibration only if no calibration data is present. |
| `detect_objects` | — | `CALL W_LIBRARY('detect_objects')` | `w_pose_exch_reg`: object pose linked to uniVision `Device Robot Vision` Result List Index 0. |
| `detect_target` | — | `CALL W_LIBRARY('detect_target')` | `w_pose_exch_reg`: calibration target pose. |
| `num_objects` | — | `CALL W_LIBRARY('num_objects')` | `w_exch_reg_1`: number of found objects. |
| `pose_by_index` | 1. index of object | `CALL W_LIBRARY('pose_by_index',R[11])` | `w_pose_exch_reg`: object pose for the given index. |
| `shape_by_index` | 1. index of object | `CALL W_LIBRARY('shape_by_index',R[11])` | `w_exch_reg_1`: shape model ID for the object with the given index. |
| `value_by_index` | 1. index of object | `CALL W_LIBRARY('value_by_index',R[11])` | `w_string_exch_reg`: additional value for the object with the given index. |

!!! note

    The KAREL routines are thin wrappers around the generic string based robot vision API. For the underlying commands, return values, and error codes, see the [Generic Robot Vision Interface](https://wenglor.github.io/wenglor-robot-vision/4_0_robot_vision_server/4_5_0_generic_robot_vision_interface/) in the wenglor robot vision manual.

## Units and conventions

The generic robot vision API uses the following conventions, which the KAREL library maps to the FANUC representation:

- Positions `x, y, z` are exchanged in **meters**; FANUC works in **millimeters**.
- Orientations `rx, ry, rz` are exchanged as a **rotation vector** (Rodrigues convention, in radians); FANUC uses **W, P, R** Euler angles.

See the command tables in the [Generic Robot Vision Interface](https://wenglor.github.io/wenglor-robot-vision/4_0_robot_vision_server/4_5_0_generic_robot_vision_interface/) in the wenglor robot vision manual.
