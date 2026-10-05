/PROG  W_MOVE
/ATTR
OWNER		= MNEDITOR;
COMMENT		= "";
PROG_SIZE	= 276;
CREATE		= DATE 25-12-05  TIME 14:58:02;
MODIFIED	= DATE 25-12-05  TIME 15:15:22;
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
LOCAL_REGISTERS	= 0,0,0;
/MN
:  -- Version: 1.1.0;
:  -- Author: wenglor sensoric group;
:  ;
:  UFRAME_NUM=R[65] ;
:  UTOOL_NUM=R[64] ;
:  -- Is PTP enabled?;
:  IF (R[63]) THEN;
:     -- Move robot to exchange register;
:     J PR[60] 5% FINE;
:  ELSE;
:     -- Move robot to exchange register;
:     L PR[60] 40mm/sec FINE;
:  ENDIF;
/POS
/END
