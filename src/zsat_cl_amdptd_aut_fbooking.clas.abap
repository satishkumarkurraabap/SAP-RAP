class ZSAT_cl_amdptd_AUT_fbooking definition public final create public.

public section.
    interfaces if_amdp_marker_hdb.

    types: begin of ty_flight_booking,
        booking_id type /dmo/booking_id,
        travel_id type /dmo/travel_id,
        customer_id type /dmo/customer_id,
        carrier_id type /dmo/carrier_id,
        connection_id type /dmo/connection_id,
        total_price type /dmo/total_price,
        currency_code type /dmo/currency_code,
        overall_status type /dmo/overall_status,
    end of ty_flight_booking.

    types: begin of ty_travel,
        travel_id type /dmo/travel_id,
        agency_id type /dmo/agency_id,
        customer_id type /dmo/customer_id,
        booking_fee type /dmo/booking_fee,
        total_price type /dmo/total_price,
        currency_code type /dmo/currency_code,
        overall_status type /dmo/overall_status,
    end of ty_travel.

    types tt_booking type standard table of /dmo/i_booking_m with empty key.
    types tt_travel type standard table of ty_travel with empty key.
    types tt_flight_booking type standard table of ty_flight_booking with empty key.

    "! Read the flight booking status
    methods read_flight_booking_status amdp options read-only  CDS SESSION CLIENT DEPENDENT
        importing value(booking_id) type /dmo/booking_id
        exporting value(booking_status) type /dmo/booking_status.

    "! Change the flight booking status to 'Accepted'
    "!    methods set_booking_status_accepted amdp options read-only CDS SESSION CLIENT DEPENDENT
    "!    importing value(booking_id) type /dmo/booking_id.

    "! Read the flight details from booking id ( booking and the travel details )
    methods read_flight_details amdp options read-only  CDS SESSION CLIENT DEPENDENT
        importing value(booking_id) type /dmo/booking_id
        exporting value(flight_details) type tt_flight_booking.

    "! Read flight booking details
    methods read_booking_details amdp options read-only CDS SESSION CLIENT DEPENDENT
        importing value(booking_id) type /dmo/booking_id
        exporting value(booking) type tt_booking.

    "! Read flight travel details
    methods read_travel_details amdp options read-only CDS SESSION CLIENT DEPENDENT
        importing value(travel_id) type /dmo/travel_id
        exporting value(travel) type tt_travel.

endclass.


class ZSAT_cl_amdptd_AUT_fbooking implementation.

    method read_flight_booking_status by database procedure for hdb language sqlscript using /dmo/booking_m.
        select booking_status into booking_status from "/DMO/BOOKING_M" where booking_id = :booking_id;
    endmethod.


    method read_flight_details by database procedure for hdb language sqlscript
    using  ZSAT_cl_amdptd_AUT_fbooking=>read_booking_details ZSAT_cl_amdptd_AUT_fbooking=>read_travel_details.

        declare travel_id nvarchar( 8 );

        -- Read booking details
        call "ZSAT_CL_AMDPTD_AUT_FBOOKING=>READ_BOOKING_DETAILS"( booking_id => :booking_id, booking => :booking );

        -- To fetch the travel details we need to get the travel id from booking details
        travel_id = :booking.travel_id[ 1 ];

        -- Read travel details
        call "ZSAT_CL_AMDPTD_AUT_FBOOKING=>READ_TRAVEL_DETAILS"( travel_id => travel_id, travel => :travel );

        -- Read the overall flight details
        flight_details = select b.booking_id, b.travel_id, b.customer_id, b.carrier_id,
                                b.connection_id, t.total_price, t.currency_code, t.overall_status
                         from :booking as b inner join :travel as t on t.travel_id = b.travel_id;
    endmethod.

    method read_booking_details by database procedure for hdb language sqlscript using /dmo/i_booking_m.
        booking = select travel_id, booking_id, booking_date, customer_id, carrier_id, connection_id,
                         flight_date, flight_price, currency_code, booking_status, last_changed_at
                  from "/DMO/I_BOOKING_M" where booking_id = :booking_id;
    endmethod.

    method read_travel_details by database procedure for hdb language sqlscript using /dmo/i_travel_m.
        travel = select travel_id, agency_id, customer_id, booking_fee,
                        total_price, currency_code, overall_status
                 from "/DMO/I_TRAVEL_M" where travel_id = :travel_id;
    endmethod.

endclass.
