--
-- PostgreSQL database 

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 4 (class 2615 OID 2200)
-- Name: public; Type: SCHEMA; Schema: -; Owner: pg_database_owner
--

CREATE SCHEMA public;


ALTER SCHEMA public OWNER TO pg_database_owner;

--
-- TOC entry 4396 (class 0 OID 0)
-- Dependencies: 4
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: pg_database_owner
--

COMMENT ON SCHEMA public IS 'standard public schema';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 222 (class 1259 OID 24818)
-- Name: d_calendar; Type: TABLE; Schema: public; Owner: avnadmin
--

CREATE TABLE public.d_calendar (
    date date NOT NULL,
    year integer NOT NULL,
    month integer NOT NULL,
    week integer NOT NULL,
    day integer NOT NULL,
    month_n integer NOT NULL,
    week_n integer NOT NULL,
    day_n integer NOT NULL
);


ALTER TABLE public.d_calendar OWNER TO avnadmin;

--
-- TOC entry 221 (class 1259 OID 24811)
-- Name: d_customer; Type: TABLE; Schema: public; Owner: avnadmin
--

CREATE TABLE public.d_customer (
    id_customer integer NOT NULL,
    location_id integer,
    first_name character varying NOT NULL,
    last_name character varying NOT NULL,
    id_card character varying NOT NULL,
    birth_date date NOT NULL,
    address_street character varying,
    start_date date NOT NULL,
    end_date date NOT NULL,
    active character(1) NOT NULL,
    etl_ts timestamp without time zone NOT NULL
);


ALTER TABLE public.d_customer OWNER TO avnadmin;

--
-- TOC entry 219 (class 1259 OID 24803)
-- Name: d_location; Type: TABLE; Schema: public; Owner: avnadmin
--

CREATE TABLE public.d_location (
    id_location integer NOT NULL,
    country character varying NOT NULL,
    region character varying NOT NULL,
    city character varying NOT NULL,
    active character(1) NOT NULL,
    etl_ts timestamp without time zone NOT NULL
);


ALTER TABLE public.d_location OWNER TO avnadmin;

--
-- TOC entry 217 (class 1259 OID 24795)
-- Name: d_vehicle; Type: TABLE; Schema: public; Owner: avnadmin
--

CREATE TABLE public.d_vehicle (
    id_vehicle integer NOT NULL,
    plate character varying NOT NULL,
    brand character varying NOT NULL,
    model character varying NOT NULL,
    fuel character varying NOT NULL,
    location_id integer,
    start_rent date NOT NULL,
    end_rent date NOT NULL,
    etl_ts timestamp without time zone NOT NULL
);


ALTER TABLE public.d_vehicle OWNER TO avnadmin;

--
-- TOC entry 215 (class 1259 OID 24787)
-- Name: f_booking; Type: TABLE; Schema: public; Owner: avnadmin
--

CREATE TABLE public.f_booking (
    id_booking integer NOT NULL,
    customer_id integer,
    vehicle_id integer,
    date date NOT NULL,
    customer character varying NOT NULL,
    brand_model character varying NOT NULL,
    vehicle_plate character varying NOT NULL,
    start_rent date NOT NULL,
    end_rent date NOT NULL,
    active character(1) NOT NULL,
    etl_ts timestamp without time zone NOT NULL
);


ALTER TABLE public.f_booking OWNER TO avnadmin;

--
-- TOC entry 214 (class 1259 OID 24786)
-- Name: t_booking_id_booking_seq; Type: SEQUENCE; Schema: public; Owner: avnadmin
--

ALTER TABLE public.f_booking ALTER COLUMN id_booking ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.t_booking_id_booking_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 220 (class 1259 OID 24810)
-- Name: t_customer_id_customer_seq; Type: SEQUENCE; Schema: public; Owner: avnadmin
--

ALTER TABLE public.d_customer ALTER COLUMN id_customer ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.t_customer_id_customer_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 218 (class 1259 OID 24802)
-- Name: t_location_id_location_seq; Type: SEQUENCE; Schema: public; Owner: avnadmin
--

ALTER TABLE public.d_location ALTER COLUMN id_location ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.t_location_id_location_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 216 (class 1259 OID 24794)
-- Name: t_vehicle_id_vehicle_seq; Type: SEQUENCE; Schema: public; Owner: avnadmin
--

ALTER TABLE public.d_vehicle ALTER COLUMN id_vehicle ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.t_vehicle_id_vehicle_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);



--
-- TOC entry 4397 (class 0 OID 0)
-- Dependencies: 214
-- Name: t_booking_id_booking_seq; Type: SEQUENCE SET; Schema: public; Owner: avnadmin
--

SELECT pg_catalog.setval('public.t_booking_id_booking_seq', 6227, true);


--
-- TOC entry 4398 (class 0 OID 0)
-- Dependencies: 220
-- Name: t_customer_id_customer_seq; Type: SEQUENCE SET; Schema: public; Owner: avnadmin
--

SELECT pg_catalog.setval('public.t_customer_id_customer_seq', 30, true);


--
-- TOC entry 4399 (class 0 OID 0)
-- Dependencies: 218
-- Name: t_location_id_location_seq; Type: SEQUENCE SET; Schema: public; Owner: avnadmin
--

SELECT pg_catalog.setval('public.t_location_id_location_seq', 19, true);


--
-- TOC entry 4400 (class 0 OID 0)
-- Dependencies: 216
-- Name: t_vehicle_id_vehicle_seq; Type: SEQUENCE SET; Schema: public; Owner: avnadmin
--

SELECT pg_catalog.setval('public.t_vehicle_id_vehicle_seq', 45, true);


--
-- TOC entry 4226 (class 2606 OID 24793)
-- Name: f_booking t_booking_pkey; Type: CONSTRAINT; Schema: public; Owner: avnadmin
--

ALTER TABLE ONLY public.f_booking
    ADD CONSTRAINT t_booking_pkey PRIMARY KEY (id_booking);


--
-- TOC entry 4234 (class 2606 OID 24822)
-- Name: d_calendar t_calendar_pkey; Type: CONSTRAINT; Schema: public; Owner: avnadmin
--

ALTER TABLE ONLY public.d_calendar
    ADD CONSTRAINT t_calendar_pkey PRIMARY KEY (date);


--
-- TOC entry 4232 (class 2606 OID 24817)
-- Name: d_customer t_customer_pkey; Type: CONSTRAINT; Schema: public; Owner: avnadmin
--

ALTER TABLE ONLY public.d_customer
    ADD CONSTRAINT t_customer_pkey PRIMARY KEY (id_customer);


--
-- TOC entry 4230 (class 2606 OID 24809)
-- Name: d_location t_location_pkey; Type: CONSTRAINT; Schema: public; Owner: avnadmin
--

ALTER TABLE ONLY public.d_location
    ADD CONSTRAINT t_location_pkey PRIMARY KEY (id_location);


--
-- TOC entry 4228 (class 2606 OID 24801)
-- Name: d_vehicle t_vehicle_pkey; Type: CONSTRAINT; Schema: public; Owner: avnadmin
--

ALTER TABLE ONLY public.d_vehicle
    ADD CONSTRAINT t_vehicle_pkey PRIMARY KEY (id_vehicle);


--
-- TOC entry 4235 (class 2606 OID 24823)
-- Name: f_booking t_booking_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: avnadmin
--

ALTER TABLE ONLY public.f_booking
    ADD CONSTRAINT t_booking_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.d_customer(id_customer);


--
-- TOC entry 4236 (class 2606 OID 24843)
-- Name: f_booking t_booking_date_fkey; Type: FK CONSTRAINT; Schema: public; Owner: avnadmin
--

ALTER TABLE ONLY public.f_booking
    ADD CONSTRAINT t_booking_date_fkey FOREIGN KEY (date) REFERENCES public.d_calendar(date);


--
-- TOC entry 4237 (class 2606 OID 24828)
-- Name: f_booking t_booking_vehicle_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: avnadmin
--

ALTER TABLE ONLY public.f_booking
    ADD CONSTRAINT t_booking_vehicle_id_fkey FOREIGN KEY (vehicle_id) REFERENCES public.d_vehicle(id_vehicle);


--
-- TOC entry 4239 (class 2606 OID 24838)
-- Name: d_customer t_customer_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: avnadmin
--

ALTER TABLE ONLY public.d_customer
    ADD CONSTRAINT t_customer_location_id_fkey FOREIGN KEY (location_id) REFERENCES public.d_location(id_location);


--
-- TOC entry 4238 (class 2606 OID 24833)
-- Name: d_vehicle t_vehicle_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: avnadmin
--

ALTER TABLE ONLY public.d_vehicle
    ADD CONSTRAINT t_vehicle_location_id_fkey FOREIGN KEY (location_id) REFERENCES public.d_location(id_location);


-- Completed on 2024-12-07 19:15:27

--
-- PostgreSQL database dump complete
--
