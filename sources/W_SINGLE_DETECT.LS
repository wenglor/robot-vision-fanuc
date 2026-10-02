/PROG  W_SINGLE_DETECT
/ATTR
OWNER		= MNEDITOR;
COMMENT		= "";
PROG_SIZE	= 388;
CREATE		= DATE 26-02-04  TIME 10:15:46;
MODIFIED	= DATE 26-02-04  TIME 10:15:46;
FILE_NAME	= ;
VERSION		= 0;
LINE_COUNT	= 8;
MEMORY_SIZE	= 736;
PROTECT		= READ_WRITE;
TCD:  STACK_SIZE	= 0,
      TASK_PRIORITY	= 50,
      TIME_SLICE	= 0,
      BUSY_LAMP_OFF	= 0,
      ABORT_REQUEST	= 0,
      PAUSE_REQUEST	= 0;
DEFAULT_GROUP	= 1,*,*,*,*;
CONTROL_CODE	= 00000000 00000000;
LOCAL_REGISTERS	= 0,0,0;
/MN
:  -- Version: 1.1.0;
:  -- Author: wenglor sensoric group;
:  ;
:  UFRAME_NUM=R[65] ;
:  -- Calibrate if no calibration is available;
:  CALL W_LIBRARY('calibrate_if_needed',10.0) ;
:  UTOOL_NUM=R[64] ;
:  -- Load detection job;
:  CALL W_LIBRARY('load_job','find_objects.u3p');
:  -- Move to detection pose;
:J PR[65:DetectionPose] 5% FINE;
:  CALL W_LIBRARY('detect_objects');
:  CALL W_LIBRARY('shape_by_index',0) ;
:  -- Enable if linked in deviceRobotVision;
:  -- CALL W_LIBRARY('value_by_index',0) ;
:  -- Add logic to separate objects;
:  -- based on shape R[60] or
:  -- value SR[60] if needed;
:  -- Move to object pose;
:L PR[60:PoseKarel] 40mm/sec FINE;
/POS
/END
