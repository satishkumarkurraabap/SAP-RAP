"!@testing ZSAT_DMO_I_FLIGHT_R
CLASS ltc_zsat_dmo_i_flight_r DEFINITION FINAL
  FOR TESTING RISK LEVEL HARMLESS DURATION SHORT.

  PRIVATE SECTION.
    CLASS-DATA environment TYPE REF TO if_cds_test_environment.

    DATA td_/dmo/flight TYPE STANDARD TABLE OF /dmo/flight WITH EMPTY KEY.
    DATA act_results TYPE STANDARD TABLE OF zsat_dmo_i_flight_r WITH EMPTY KEY.

    "! In CLASS_SETUP, corresponding doubles and clone(s) for the CDS view under test and its dependencies are created.
    CLASS-METHODS class_setup RAISING cx_static_check.
    "! In CLASS_TEARDOWN, Generated database entities (doubles & clones) should be deleted at the end of test class execution.
    CLASS-METHODS class_teardown.

    "! SETUP method creates a common start state for each test method,
    "! clear_doubles clears the test data for all the doubles used in the test method before each test method execution.
    METHODS setup RAISING cx_static_check.
    METHODS prepare_testdata.
    "! In this method test data is inserted into the generated double(s) and the test is executed and
    "! the results should be asserted with the actuals.
    METHODS aunit_for_cds_method FOR TESTING RAISING cx_static_check.
    METHODS : above_threshold FOR TESTING,
      below_threshold         FOR TESTING,
      initial_value           FOR TESTING,
      equal_to_threshold      FOR TESTING.
ENDCLASS.


CLASS ltc_zsat_dmo_i_flight_r IMPLEMENTATION.

  METHOD class_setup.
    environment = cl_cds_test_environment=>create( i_for_entity = 'ZSAT_DMO_I_FLIGHT_R' ).
  ENDMETHOD.

  METHOD setup.
    environment->clear_doubles( ).
  ENDMETHOD.

  METHOD class_teardown.
    environment->destroy( ).
  ENDMETHOD.

  METHOD aunit_for_cds_method.
    prepare_testdata( ).
    SELECT * FROM zsat_dmo_i_flight_r INTO TABLE @act_results.
* cl_abap_unit_assert=>fail( msg = 'Place your assertions here' ).
  ENDMETHOD.

  METHOD prepare_testdata.
    " Prepare test data for '/dmo/flight'
    td_/dmo/flight = VALUE #(
      (
        client = '100'
      ) ).
    environment->insert_test_data( i_data = td_/dmo/flight ).
  ENDMETHOD.

  METHOD above_threshold.

    DATA Flight_mock_data TYPE STANDARD TABLE OF /dmo/flight WITH EMPTY KEY.
    flight_mock_data = VALUE #( ( price = '1500' ) ).

    environment->insert_test_data( i_data = flight_mock_data ).

    SELECT SINGLE PriceWithDiscount FROM zsat_dmo_i_flight_r INTO @DATA(act_result).
    cl_abap_unit_assert=>assert_equals( act = act_result exp = 1450 msg = 'PriceWithDiscount' ).

  ENDMETHOD.

  METHOD below_threshold.
    DATA Flight_mock_data TYPE STANDARD TABLE OF /dmo/flight WITH EMPTY KEY.
    flight_mock_data = VALUE #( ( price = '500' ) ).

    environment->insert_test_data( i_data = flight_mock_data ).

    SELECT SINGLE PriceWithDiscount FROM zsat_dmo_i_flight_r INTO @DATA(act_result).
    cl_abap_unit_assert=>assert_equals( act = act_result exp = 500 msg = 'PriceWithDiscount' ).

  ENDMETHOD.

  METHOD equal_to_threshold.

    DATA Flight_mock_data TYPE STANDARD TABLE OF /dmo/flight WITH EMPTY KEY.
    flight_mock_data = VALUE #( ( price = '1000' ) ).

    environment->insert_test_data( i_data = flight_mock_data ).

    SELECT SINGLE PriceWithDiscount FROM zsat_dmo_i_flight_r INTO @DATA(act_result).
    cl_abap_unit_assert=>assert_equals( act = act_result exp = 1000 msg = 'PriceWithDiscount' ).

  ENDMETHOD.

  METHOD initial_value.

    DATA Flight_mock_data TYPE STANDARD TABLE OF /dmo/flight WITH EMPTY KEY.
    flight_mock_data = VALUE #( ( price = '100' ) ).

    environment->insert_test_data( i_data = flight_mock_data ).

    SELECT SINGLE PriceWithDiscount FROM zsat_dmo_i_flight_r INTO @DATA(act_result).
    cl_abap_unit_assert=>assert_equals( act = act_result exp = 0 msg = 'PriceWithDiscount' ).

  ENDMETHOD.

ENDCLASS.
