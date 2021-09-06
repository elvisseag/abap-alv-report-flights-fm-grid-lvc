*TYPE-POOLS: col.
TABLES: sflight.

TYPES: BEGIN OF gty_data.
        INCLUDE STRUCTURE sflight.
TYPES: style  TYPE lvc_t_styl.
TYPES: colors TYPE lvc_t_scol.
TYPES:  END OF gty_data.

DATA: gtd_sflight    TYPE STANDARD TABLE OF sflight,
      gtd_data       TYPE STANDARD TABLE OF gty_data,
      gtd_fieldcat   TYPE lvc_t_fcat,
      gwa_fcat       TYPE LINE OF lvc_t_fcat,
      gwa_layout     TYPE lvc_s_layo,
      gwa_style      TYPE LINE OF lvc_t_styl,
      gwa_colors     TYPE LINE OF lvc_t_scol.

FIELD-SYMBOLS: <fs_sflight> TYPE sflight,
               <fs_data> TYPE gty_data.