/PROG  W_MULTI_DETECT
/ATTR
OWNER		= MNEDITOR;
COMMENT		= "";
PROG_SIZE	= 934;
CREATE		= DATE 26-02-04  TIME 11:37:28;
MODIFIED	= DATE 26-02-04  TIME 11:37:28;
FILE_NAME	= ;
VERSION		= 0;
LINE_COUNT	= 25;
MEMORY_SIZE	= 1214;
PROTECT		= READ_WRITE;
TCD:  STACK_SIZE	= 0,
      TASK_PRIORITY	= 50,
      TIME_SLICE	= 0,
      BUSY_LAMP_OFF	= 0,
      ABORT_REQUEST	= 0,
      PAUSE_REQUEST	= 0;
DEFAULT_GROUP	= 1,*,*,*,*;
CONTROL_CODE	= 00000000 00000000;
LOCAL_REGISTERS	= 2,0,0;
/MN
:  -- Version: 1.1.0;
:  -- Author: wenglor sensoric group;
:  ;
:  UFRAME_NUM=R[65] ;
:  -- Calibrate if no calibration is available;
:  CALL W_LIBRARY('calibrate_if_needed',10.0) ;
:  UTOOL_NUM=R[64] ;
:  -- Load detection job;
:  CALL W_LIBRARY('load_job','find_objects.u3p') ;
:  -- Move to detection pose;
:J PR[65:DetectionPose] 5% FINE    ;
:  CALL W_LIBRARY('detect_objects') ;
:  CALL W_LIBRARY('num_objects') ;
:  IF (R[60:NumKarel]=0) THEN ;
:       MESSAGE['No objects detected. Aborting!'] ;
:       ABORT ;
:  ENDIF ;
:  -- Save number of objects in R[10001],
:  -- so R[60] can be used again;
:  -- subtract 1, because the vision API
:  -- uses 0-based indexing;
:  R[10001:NumObjects]=R[60:NumKarel]-1;
:  FOR R[10002:Index]=0 TO R[10001:NumObjects] ;
:       CALL W_LIBRARY('pose_by_index',R[10002:Index]) ;
:       CALL W_LIBRARY('shape_by_index',R[10002:Index]) ;
:       -- Enable if linked in deviceRobotVision;
:       -- CALL W_LIBRARY('value_by_index',R[10002:Index]) ;
:       -- Add logic to separate objects;
:       -- based on shape R[60], or
:       -- value SR[60] if needed;
:       -- Move to object pose;
:       L PR[60:PoseKarel] 40mm/sec FINE;
:  ENDFOR ;
/POS
/END
