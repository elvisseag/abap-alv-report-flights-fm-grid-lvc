*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_data .

  SELECT * UP TO 20 ROWS INTO TABLE gtd_sflight
  FROM sflight
  WHERE fldate IN s_fldate.

ENDFORM.                    " GET_DATA
*&---------------------------------------------------------------------*
*&      Form  PROCESS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM process .

  "Filling Cell Property of each row of internal table
  LOOP AT gtd_sflight ASSIGNING <fs_sflight>.

    APPEND INITIAL LINE TO gtd_data ASSIGNING <fs_data>.
    MOVE-CORRESPONDING <fs_sflight> TO <fs_data>.

    IF <fs_sflight>-fldate GE '20140101'.

      CLEAR: gwa_style.
      gwa_style-fieldname = 'FLDATE'.
      IF <fs_sflight>-price GT 100.
        gwa_style-style = cl_gui_alv_grid=>mc_style_enabled.
      ELSE.
        gwa_style-style = cl_gui_alv_grid=>mc_style_disabled.
      ENDIF.
      APPEND gwa_style TO <fs_data>-style.

      CLEAR gwa_colors.
      gwa_colors-fname = 'FLDATE'.

      IF <fs_sflight>-price = 100.
        gwa_colors-color-col = col_negative.
      ELSE.
        gwa_colors-color-col = col_positive.
      ENDIF.
      gwa_colors-color-int = 1.
      APPEND gwa_colors TO <fs_data>-colors.

    ENDIF.

  ENDLOOP.

ENDFORM.                    " PROCESS
*&---------------------------------------------------------------------*
*&      Form  ALV_DISPLAY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM alv_display .

**  build field catalog
  CLEAR gwa_fcat.
  gwa_fcat-fieldname = 'CARRID'.
  gwa_fcat-ref_table = 'SFLIGHT'.
  gwa_fcat-ref_field = 'CARRID'.
  APPEND gwa_fcat TO gtd_fieldcat.

  CLEAR gwa_fcat.
  gwa_fcat-fieldname = 'CONNID'.
  gwa_fcat-ref_table = 'SFLIGHT'.
  gwa_fcat-ref_field = 'CONNID'.
  APPEND gwa_fcat TO gtd_fieldcat.

  CLEAR gwa_fcat.
  gwa_fcat-fieldname = 'FLDATE'.
  gwa_fcat-ref_table = 'SFLIGHT'.
  gwa_fcat-ref_field = 'FLDATE'.
  gwa_fcat-edit      = 'X'.
  APPEND gwa_fcat TO gtd_fieldcat.

  CLEAR gwa_fcat.
  gwa_fcat-fieldname = 'PRICE'.
  gwa_fcat-ref_table = 'SFLIGHT'.
  gwa_fcat-ref_field = 'PRICE'.
  gwa_fcat-edit      = 'X'.
  APPEND gwa_fcat TO gtd_fieldcat.

** Passing Style and Color field names of internal table to layout
  gwa_layout-stylefname = 'STYLE'.
  gwa_layout-ctab_fname = 'COLORS'.

  IF gtd_sflight IS NOT INITIAL.

    CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY_LVC'
      EXPORTING
        i_callback_program = sy-cprog
        is_layout_lvc      = gwa_layout
        it_fieldcat_lvc    = gtd_fieldcat
      TABLES
        t_outtab           = gtd_data
      EXCEPTIONS
        program_error      = 1
        OTHERS             = 2.
    IF sy-subrc <> 0.
    ENDIF.

  ENDIF.

ENDFORM.                    " ALV_DISPLAY