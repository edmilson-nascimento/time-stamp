*&---------------------------------------------------------------------*
*& Report YTESTE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT yteste MESSAGE-ID >0 .



DATA:
  startstamp TYPE timestampl,
  endstamp   TYPE timestampl.

*" Inicial
*GET TIME STAMP FIELD startstamp.
*
*" Processamento
*DO 26504330 TIMES .
*  DATA(x) = ( 15  * 888888 ) / 1 .
*ENDDO .
*
*" Final
*GET TIME STAMP FIELD endstamp.
*
*" Diferenca de tempo
*DATA(lv_temp) = cl_abap_tstmp=>subtract( tstmp1 = endstamp
*                                         tstmp2 = startstamp ) .
*"Exibicao do valor
*WRITE / lv_temp TIME ZONE 'BRAZIL'.


DATA:
  lv_legend TYPE char20,
  lv_carrid TYPE sflight-carrid VALUE 'LH',
  lv_connid TYPE sflight-connid VALUE '0455',
  lv_fldate TYPE sflight-fldate VALUE '19950606'.

DO .

  GET TIME STAMP FIELD startstamp.

  CASE sy-index .

    WHEN 1 .

      " SINGLE (field)
      SELECT SINGLE carrid
        FROM sflight
        INTO @data(lt_single)
       WHERE carrid EQ @lv_carrid
         AND connid EQ @lv_connid
         AND fldate EQ @lv_fldate .

      lv_legend = |Single (field): | .

    WHEN 2 .

      SELECT SINGLE @abap_true
        FROM sflight
        INTO @data(exists_01)
       WHERE carrid EQ @lv_carrid
         AND connid EQ @lv_connid
         AND fldate EQ @lv_fldate .

      lv_legend = |Single-(abap_true): | .

    WHEN 3 .

      " COUNT
      SELECT COUNT(*)
        FROM sflight
        INTO @sy-dbcnt
       WHERE carrid EQ @lv_carrid
         AND connid EQ @lv_connid
         AND fldate EQ @lv_fldate .

      lv_legend = |COUNT: | .

    WHEN 4 .

      SELECT SINGLE @abap_true
        FROM sflight
       WHERE carrid EQ @lv_carrid
         AND connid EQ @lv_connid
         AND fldate EQ @lv_fldate
        INTO @data(exists_02) .

      lv_legend = |Single (abap_true): | .


    WHEN OTHERS .
      EXIT .

  ENDCASE .

  GET TIME STAMP FIELD endstamp.

  " Diferenca de tempo
  DATA(lv_temp) = cl_abap_tstmp=>subtract( tstmp1 = endstamp
                                           tstmp2 = startstamp ) .
  "Exibicao do valor
  WRITE:/ lv_legend, 20 lv_temp TIME ZONE 'BRAZIL'.

ENDDO .

*DATA   lr_vkorg   TYPE RANGE OF vkorg.
*TYPES: lr_range_t TYPE RANGE OF vkorg.
*
*lr_vkorg = VALUE lr_range_t(
*          LET s = 'I'
*              o = 'EQ'
*          IN sign   = s
*             option = o
*             ( low = '1100' )
*             ( low = '1200' )
*             ( low = '1300' )
*             ( low = '1400' )
*             ( low = '1500' )
*             ) .
*TABLES: pa0002.
*
*INCLUDE <icon>.
*
*TYPES: BEGIN OF  ty_outtab,
*         matnr type makt-matnr,
*         maktx type makt-maktx,
*         icon        TYPE icon_d,
*       END   OF ty_outtab.
*
*DATA: gt_outtab     TYPE STANDARD TABLE OF ty_outtab.
*DATA: gr_table      TYPE REF TO cl_salv_table.
*
*CONSTANTS: gc_true   TYPE sap_bool VALUE 'X',
*           gc_false  TYPE sap_bool VALUE ' '.
**----------------------------------------------------------------------*
** SELECTION-SCREEN                                                     *
**----------------------------------------------------------------------*
*SELECTION-SCREEN BEGIN OF BLOCK dsp WITH FRAME.
*SELECT-OPTIONS:s_pernr FOR pa0002-pernr.
*SELECTION-SCREEN END OF BLOCK dsp.
**----------------------------------------------------------------------*
** START-OF-SELECTION                                                   *
**----------------------------------------------------------------------*
*START-OF-SELECTION.
*
*  PERFORM select_data.
*  PERFORM display_data.
*
*END-OF-SELECTION.
**&---------------------------------------------------------------------*
**&      Form  select_data
**----------------------------------------------------------------------*
*FORM select_data .
*
*  SELECT matnr maktx
*   up to 200 rows
*    FROM makt
*    INTO CORRESPONDING FIELDS OF TABLE gt_outtab .
*
*  FIELD-SYMBOLS: <ls_outtab> TYPE ty_outtab.
*  DATA:       l_erg        TYPE i.
*
*  LOOP AT gt_outtab ASSIGNING <ls_outtab>.
*
*    l_erg = sy-tabix MOD 3.
*    CASE l_erg.
*      WHEN 1.
*        <ls_outtab>-icon     = icon_okay.
*      WHEN 2.
*        <ls_outtab>-icon     = icon_cancel.
*      WHEN 0.
*        <ls_outtab>-icon     = icon_display.
*    ENDCASE.
*  ENDLOOP.
*
*ENDFORM.                    " select_data
**&---------------------------------------------------------------------*
**&      Form  DISPLAY_DATA
**----------------------------------------------------------------------*
*FORM display_data .
*
*  cl_salv_table=>factory(
*    IMPORTING
*      r_salv_table = gr_table
*    CHANGING
*      t_table      = gt_outtab ).
*
*  DATA: lr_columns TYPE REF TO cl_salv_columns_table,
*        lr_column  TYPE REF TO cl_salv_column_table.
*
*  lr_columns = gr_table->get_columns( ).
*  lr_columns->set_optimize( gc_true ).
*
*  lr_column ?= lr_columns->get_column( 'ICON' ).
*  lr_column->set_icon( if_salv_c_bool_sap=>true ).
*  lr_column->set_long_text( 'ICON' ).
*
*  gr_table->display( ).
*
*ENDFORM.                    " DISPLAY_DATA
