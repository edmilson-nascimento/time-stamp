*&---------------------------------------------------------------------*
*& Report YTESTE
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
