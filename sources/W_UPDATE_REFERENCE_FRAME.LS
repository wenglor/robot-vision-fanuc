/PROG  W_UPDATE_REFERENCE_FRAME
/ATTR
OWNER		= MNEDITOR;
COMMENT		= "";
PROG_SIZE	= 276;
CREATE		= DATE 26-04-01  TIME 15:12:02;
MODIFIED	= DATE 26-04-02  TIME 09:17:22;
FILE_NAME	= ;
VERSION		= 0;
LINE_COUNT	= 6;
MEMORY_SIZE	= 624;
PROTECT		= READ_WRITE;
TCD:  STACK_SIZE	= 0,
      TASK_PRIORITY	= 50,
      TIME_SLICE	= 0,
      BUSY_LAMP_OFF	= 0,
      ABORT_REQUEST	= 0,
      PAUSE_REQUEST	= 0;
DEFAULT_GROUP	= 1,*,*,*,*;
CONTROL_CODE	= 00000000 00000000;
LOCAL_REGISTERS	= 1,0,0;
/MN
:  -- Version: 1.1.0;
:  -- Author: wenglor sensoric group;
:  ;
: -- You may want to use another UFRAME or calibration;
: UFRAME_NUM=R[65] ;
: R[10001:ArePosesTaught] = 0;
:  -- Calibrate if no calibration is available;
: CALL W_LIBRARY('calibrate_if_needed',10.0) ;
:  UTOOL_NUM=R[64] ;
: -- Load the find_target job, as it defines the reference frame;
: CALL W_LIBRARY('load_job','find_target.u3p') ;
: -- Move to a pose where the target is visible to the vision system;
:J PR[65:DetectionPose] 5% FINE    ;
: -- Get the reference frame pose;
: CALL W_LIBRARY('detect_target') ;
: UFRAME[5:RefFrame]=PR[60:PoseKarel] ;
: UFRAME_NUM = 5 ;
: IF (R[10001:ArePosesTaught]=0) THEN ;
:   Message[UFRAME set. Teach poses.] ;
:   Message[Set R[10001] to 1 when done.] ;
:   ABORT ;
: ENDIF ;
: -- Reference frame updated. Related poses are updated; machine poses can be approached now;
: -- Move to a machine pose; replace with your own poses;
: L PR[66:PoseInMachine] 40mm/sec FINE ;
/POS
/END
