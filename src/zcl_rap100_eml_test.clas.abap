CLASS zcl_rap100_eml_test DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.

  PRIVATE SECTION.
    CLASS-DATA:
      console_output TYPE REF TO if_oo_adt_classrun_out.

ENDCLASS.



CLASS zcl_rap100_eml_test IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    "set console output instance
    console_output = out.

    READ ENTITIES OF zr_rap_atrav_sat000
    ENTITY ZrRapAtravSat000
    ALL FIELDS WITH VALUE #( ( %key-TravelID = '000010'

    ) )

    RESULT FINAL(lt_result)
    FAILED FINAL(lt_failed).

    "console output
    console_output->write( |Exercise 9.2: READ a Travel BO entity instance | ).
    console_output->write( lt_result ).
    IF lt_failed IS NOT INITIAL.
      console_output->write( |- Cause for failed read = { lt_failed-ZrRapAtravSat000[ 1 ]-%fail-cause } | ).
    ENDIF.
    console_output->write( |--------------------------------------------- | ).

  ENDMETHOD.
ENDCLASS.
