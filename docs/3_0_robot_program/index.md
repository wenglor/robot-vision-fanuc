# Robot Program

The example program implements a complete robot vision workflow: calibrating the camera to the robot, detecting objects, and moving to them. It is split into a KAREL backend (`W_LIBRARY`) that does the socket communication with the wenglor robot server, and TP programs that orchestrate the workflow.

## Program structure

| File | Responsibility |
| --- | --- |
| `W_LIBRARY.pc` | KAREL library. Socket communication with the robot server, calibration, detection, pose conversions, error handling, and all user-adjustable variables. See [User Configuration](../2_0_user_configuration/index.md). |
| `W_SINGLE_DETECT.tp` | Calibrates if needed, loads the detection job, moves to the detection pose, detects a single object and moves to it. |
| `W_MULTI_DETECT.tp` | Fills the buffer, reads the number of objects, and iterates over all detected objects. |
| `W_UPDATE_REFERENCE_FRAME.tp` | Detects the calibration target and updates a reference frame (e.g. for mobile platforms). |
| `W_MOVE.tp` | Helper that moves the robot to the exchange pose register, PTP or LIN depending on `w_use_ptp_reg`. |

The KAREL backend takes TP call parameters as **inputs** and returns its values to **global registers**. The exchange registers and the full list of callable routines are documented in [KAREL Reference](../4_0_reference/index.md).

## Calibration and validation process

If there is no calibration file available on the Machine Vision Device, the calibration process is started automatically by the example program. Select either `W_SINGLE_DETECT`, `W_MULTI_DETECT` or `W_UPDATE_REFERENCE_FRAME` to run it.

The calibration process uses **user prompts**. To see them, go to **Menu → User**.

<!-- PLACEHOLDER IMAGE: User prompt during calibration (Menu -> User) -->
![TODO: Calibration user prompts](images/01_user_prompts.png)

Use **SHIFT + F1** to answer `YES` and **SHIFT + F2** to answer `FALSE`. The program needs to be active so it can read the user input, so in total the **Deadman switch + SHIFT + F1 (or F2)** need to be pressed at the same time.

The program returns the registered user input. After this, the calibration movement starts. When the calibration is done, the reprojection error is returned.

<!-- PLACEHOLDER IMAGE: Reprojection error returned after calibration -->
![TODO: Reprojection error](images/02_reprojection_error.png)

For the optional validation, the robot will first move to the detection pose as a safe retreat pose, and then move to the bottom-left corner of the calibration plate. By default, a safety offset is applied (adjustable in the KAREL variable), so the robot moves *above* the calibration plate.

<!-- PLACEHOLDER IMAGE: Validation - robot above bottom-left corner of the plate -->
![TODO: Validation move](images/03_validation.png)

!!! note

    For what a good calibration looks like (Z-axis orientation, expected reprojection error values), see the [Calibration Guidelines](https://wenglor.github.io/wenglor-robot-vision/4_0_robot_vision_server/4_1_calibration_guidelines/) in the wenglor robot vision manual.

### Camera on robot

The detection pose is set during the calibration and is also used for the validation. Teach a minimum of five calibration poses (seven to eleven for better accuracy).

### Camera not on robot

The detection pose must be set by the user (see [User Configuration](../2_0_user_configuration/index.md#set-the-calibration-and-detection-poses)). It is used as a retreat pose after the calibration movement — where you remove the calibration plate from the robot and place it on the object ground — and for the validation.

## TP programs

Set up your TP program with the KAREL routines described in [KAREL Reference](../4_0_reference/index.md). You can also use the provided example programs `W_SINGLE_DETECT`, `W_MULTI_DETECT` or `W_UPDATE_REFERENCE_FRAME`.

<!-- PLACEHOLDER IMAGE: W_SINGLE_DETECT TP program listing on the teach pendant -->
![TODO: W_SINGLE_DETECT TP program](images/04_w_single_detect.png)

### `W_SINGLE_DETECT`

Calibrates if no calibration data is available, loads the detection job, moves to the detection pose, requests a single object pose, and moves to it:

```
  ! Calibrate if no calibration data is available
  CALL W_LIBRARY('calibrate_if_needed', 10.5)
  ! Load detection job
  CALL W_LIBRARY('load_job','find_objs.u3p')
  ! Move to detection pose PR[65]
  ...
  ! Detect a single object; the pose is returned in PR[60]
  CALL W_LIBRARY('detect_objects')
  ! Move to the detected object
  CALL W_MOVE
```

### `W_MULTI_DETECT`

Calibrates if needed, loads the detection job, moves to the detection pose, fills the camera-side buffer, reads the number of objects, and iterates over all detected objects:

```
  CALL W_LIBRARY('calibrate_if_needed', 10.5)
  CALL W_LIBRARY('load_job','find_objs.u3p')
  ...
  ! Fill the buffer with a detection
  CALL W_LIBRARY('detect_objects')
  ! Read the number of objects into R[60]
  CALL W_LIBRARY('num_objects')
  ! Abort if no object was found
  IF R[60]=0, JMP LBL[...]
  ! Iterate over all objects (the vision API index is 0-based)
  FOR R[2]=0 TO (R[60]-1)
    CALL W_LIBRARY('pose_by_index',R[2])
    ! Optionally read the shape model / additional value
    CALL W_LIBRARY('shape_by_index',R[2])
    CALL W_LIBRARY('value_by_index',R[2])
    CALL W_MOVE
  ENDFOR
```

You can extend this with conditional checks on the shape model or the additional value (link the additional value in the uniVision `Device Robot Vision` before using `value_by_index`).

### `W_UPDATE_REFERENCE_FRAME`

Used for mobile platforms and similar use cases (e.g. correcting positional deviations of a mobile platform in front of a machine or shelf). It calibrates if needed, loads the target-detection job, detects the calibration target, and updates a user frame that your machine poses are taught relative to.

```
  CALL W_LIBRARY('calibrate_if_needed', 10.5)
  ! Load find_target job, as it detects the reference frame
  CALL W_LIBRARY('load_job','find_target.u3p')
  ! Detect the calibration target; the pose is returned in PR[60]
  CALL W_LIBRARY('detect_target')
  ! Update the user frame with the detected pose, then move to the taught machine poses
  ...
```

On the first run, set/teach the machine poses relative to the updated reference frame, then re-run the program.

!!! note

    You may want to use a dedicated user frame for this use case. Replace the placeholder machine poses with your own.

### `W_MOVE`

Helper program that moves the robot to the exchange pose register (`PR[60]` by default). It checks whether PTP is enabled via the register configured in `w_use_ptp_reg` (default `R[63]`): `1` → PTP (joint) motion, `0` → LIN (linear) motion.
