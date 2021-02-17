--
-- Name: airline, Type: SCHEMA, Schema: -, Database: postgres
--

DROP SCHEMA IF EXISTS airline CASCADE;

CREATE SCHEMA airline;

--
-- Name: airplane_type, Type: TABLE, Schema: airline
--

CREATE TABLE airline.airplane_type (
    type_name                   varchar(20) NOT NULL,
    max_seats                   integer NOT NULL,
    company                     varchar(15) NOT NULL,
    
    CONSTRAINT pk_airplane_type PRIMARY KEY (type_name),
    CONSTRAINT ck_max_seats CHECK (max_seats >= 0)
);

--
-- Name: airplane, Type: TABLE, Schema: airline
--

CREATE TABLE airline.airplane (
    airplane_id                 integer NOT NULL,
    total_number_of_seats       integer NOT NULL,
    airplane_type               varchar(20) NOT NULL,

    CONSTRAINT pk_airplane PRIMARY KEY (airplane_id),
    CONSTRAINT fk_airplane_type FOREIGN KEY (airplane_type) REFERENCES airline.airplane_type(type_name)
);

--
-- Name: airport, Type: TABLE, Schema: airline
--

CREATE TABLE airline.airport (
    airport_code                char(3) NOT NULL,
    name                        varchar(30) NOT NULL,
    city                        varchar(30) NOT NULL,
    state                       varchar(30),

    CONSTRAINT pk_airport PRIMARY KEY (airport_code)
);

--
-- Name: flight, Type: TABLE, Schema: airline
--

CREATE TABLE airline.flight (
    number                      varchar(6) NOT NULL,
    airline                     varchar(20) NOT NULL,
    weekdays                    varchar(10) NOT NULL,

    CONSTRAINT pk_flight PRIMARY KEY (number)
);

--
-- Name: flight_leg, Type: TABLE, Schema: airline
--

CREATE TABLE airline.flight_leg (
    flight_number               varchar(6) NOT NULL,
    leg_number                  integer NOT NULL,
    departure_airport_code      char(3) NOT NULL,
    scheduled_departure_time    timestamp with time zone,
    arrival_airport_code        char(3) NOT NULL,
    scheduled_arrival_time      timestamp with time zone,

    CONSTRAINT pk_flight_leg PRIMARY KEY (flight_number, leg_number),
    CONSTRAINT fk_flight_number FOREIGN KEY (flight_number) REFERENCES airline.flight(number),
    CONSTRAINT fk_departure_airport_code FOREIGN KEY (departure_airport_code) REFERENCES airline.airport(airport_code),
    CONSTRAINT fk_arrival_airport_code FOREIGN KEY (arrival_airport_code) REFERENCES airline.airport(airport_code)
);

--
-- Name: leg_instance, Type: TABLE, Schema: airline
--

CREATE TABLE airline.leg_instance (
    flight_number               varchar(6) NOT NULL,
    leg_number                  integer NOT NULL,
    leg_date                    date NOT NULL,
    no_of_available_seats       integer,
    airplane_id                 integer,
    departure_airport_code      char(3),
    departure_time              timestamp with time zone,
    arrival_airport_code        char(3),
    arrival_time                timestamp with time zone,

    CONSTRAINT pk_leg_instance PRIMARY KEY (flight_number, leg_number, leg_date),
    CONSTRAINT fk_flight_number_leg_number FOREIGN KEY (flight_number, leg_number) REFERENCES airline.flight_leg(flight_number, leg_number),
    CONSTRAINT fk_airplane_id FOREIGN KEY (airplane_id) REFERENCES airline.airplane(airplane_id),
    CONSTRAINT fk_departure_airport_code FOREIGN KEY (departure_airport_code) REFERENCES airline.airport(airport_code),
    CONSTRAINT fk_arrival_airport_code FOREIGN KEY (arrival_airport_code) REFERENCES airline.airport(airport_code)
);

--
-- Name: fares, Type: TABLE, Schema: airline
--

CREATE TABLE airline.fares (
    flight_number               varchar(6) NOT NULL,
    fare_code                   varchar(10) NOT NULL,
    amount                      decimal(8,2) NOT NULL,
    restrictions                varchar(200),

    CONSTRAINT pk_fares PRIMARY KEY (flight_number, fare_code),
    CONSTRAINT fk_flight_number FOREIGN KEY (flight_number) REFERENCES airline.flight(number)
);

--
-- Name: can_land, Type: TABLE, Schema: airline
--

CREATE TABLE airline.can_land (
    airplane_type_name          varchar(20) NOT NULL,
    airport_code                char(3) NOT NULL,

    CONSTRAINT pk_can_land PRIMARY KEY (airplane_type_name, airport_code),
    CONSTRAINT fk_airplane_type_name FOREIGN KEY (airplane_type_name) REFERENCES airline.airplane_type(type_name),
    CONSTRAINT fk_airport_code FOREIGN KEY (airport_code) REFERENCES airline.airport(airport_code)
);

--
-- Name: seat_reservation, Type: TABLE, Schema: airline
--

CREATE TABLE airline.seat_reservation (
    flight_number               varchar(6) NOT NULL,
    leg_number                  integer NOT NULL,
    leg_date                    date NOT NULL,
    seat_number                 varchar(4),
    customer_name               varchar(30) NOT NULL,
    customer_phone              char(12),

    CONSTRAINT pk_seat_reservation PRIMARY KEY (flight_number, leg_number, leg_date, seat_number),
    CONSTRAINT fk_flight_number_leg_number_leg_date FOREIGN KEY (flight_number, leg_number, leg_date) REFERENCES airline.leg_instance(flight_number, leg_number, leg_date)
);
