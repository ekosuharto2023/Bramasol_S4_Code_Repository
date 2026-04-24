*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZBC_MAP.........................................*
DATA:  BEGIN OF STATUS_ZBC_MAP                       .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZBC_MAP                       .
CONTROLS: TCTRL_ZBC_MAP
            TYPE TABLEVIEW USING SCREEN '9000'.
*.........table declarations:.................................*
TABLES: *ZBC_MAP                       .
TABLES: ZBC_MAP                        .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
