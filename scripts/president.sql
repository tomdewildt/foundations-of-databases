--
-- Name: president, Type: SCHEMA, Schema: -, Database: postgres
--

DROP SCHEMA IF EXISTS president CASCADE;

CREATE SCHEMA president;

--
-- Name: election, Type: TABLE, Schema: president
--

CREATE TABLE president.election (
	election_year		smallint,
	candidate			varchar(128),	
	votes				integer,
	winner_loser_indic	boolean,
	
    CONSTRAINT pk_election PRIMARY KEY (election_year, candidate)
);

--
-- Name: state, Type: TABLE, Schema: president
--

CREATE TABLE president.state (
	id					integer,
	name				varchar(128) NOT NULL,
	admin_id			integer,
	year_entered		smallint NOT NULL,
	
    CONSTRAINT pk_state PRIMARY KEY (id)
);

--
-- Name: administration, Type: TABLE, Schema: president
--

CREATE TABLE president.administration (
	id					integer,
	admin_nr			integer NOT NULL,
	pres_id				integer,
	year_inaugurated	smallint NOT NULL,
	
    CONSTRAINT pk_administration PRIMARY KEY (id)
);

--
-- Name: admin_vpres, Type: TABLE, Schema: president
--

CREATE TABLE president.admin_vpres (
	admin_id			integer,
	vice_pres_name		varchar(128),
	
    CONSTRAINT pk_admin_vpres PRIMARY KEY (admin_id, vice_pres_name)
);

--
-- Name: president, Type: TABLE, Schema: president
--

CREATE TABLE president.president (
	id					integer,
	name				varchar(128) NOT NULL,
	birth_year			smallint NOT NULL,
	years_served		smallint,
	death_age			smallint,
	party				varchar(128) NOT NULL,
	state_id_born		integer,
	
    CONSTRAINT pk_president PRIMARY KEY (id),
	CONSTRAINT ck_party CHECK (party IN ('DEMOCRATIC', 'REPUBLIC', 'WHIG', 'FEDERALIST', 'DEMO-REP')),
	CONSTRAINT ck_birth_year_party CHECK ((birth_year <= 1800) OR (birth_year > 1800 AND party != 'WHIG'))
);

--
-- Name: pres_hobby, Type: TABLE, Schema: president
--

CREATE TABLE president.pres_hobby (
	pres_id				integer,
	hobby				varchar(128),
	
    CONSTRAINT pk_pres_hobby PRIMARY KEY (pres_id, hobby)
);

--
-- Name: pres_marriage, Type: TABLE, Schema: president
--

CREATE TABLE president.pres_marriage (
	pres_id				integer,
	spouse_name			varchar(128),
	spouse_age			smallint,
	nr_children			integer,
	marriage_year		smallint,
	
    CONSTRAINT pk_pres_marriage PRIMARY KEY (pres_id, spouse_name),
	CONSTRAINT ck_spouse_age_marriage_year CHECK ((marriage_year < 1800 AND spouse_age >= 21) OR (marriage_year >= 1800 AND spouse_age >= 18)),
	CONSTRAINT ck_spouse_age_nr_children CHECK ((spouse_age <= 60) OR (spouse_age > 60 AND nr_children = 0))
);

--
-- Name: state.fk_admin_id, Type: FK_CONSTRAINT, Schema: president
--

ALTER TABLE ONLY president.state ADD CONSTRAINT fk_admin_id FOREIGN KEY (admin_id) REFERENCES president.administration(id);

--
-- Name: state.fk_pres_id, Type: FK_CONSTRAINT, Schema: president
--

ALTER TABLE ONLY president.administration ADD CONSTRAINT fk_pres_id FOREIGN KEY (pres_id) REFERENCES president.president(id);

--
-- Name: state.fk_admin_id, Type: FK_CONSTRAINT, Schema: president
--

ALTER TABLE ONLY president.admin_vpres ADD CONSTRAINT fk_admin_id FOREIGN KEY (admin_id) REFERENCES president.administration(id);

--
-- Name: state.fk_state_id_born, Type: FK_CONSTRAINT, Schema: president
--

ALTER TABLE ONLY president.president ADD CONSTRAINT fk_state_id_born FOREIGN KEY (state_id_born) REFERENCES president.state(id);

--
-- Name: state.fk_pres_id, Type: FK_CONSTRAINT, Schema: president
--

ALTER TABLE ONLY president.pres_hobby ADD CONSTRAINT fk_pres_id FOREIGN KEY (pres_id) REFERENCES president.president(id);

--
-- Name: state.fk_pres_id, Type: FK_CONSTRAINT, Schema: president
--

ALTER TABLE ONLY president.pres_marriage ADD CONSTRAINT fk_pres_id FOREIGN KEY (pres_id) REFERENCES president.president(id);

--
-- Name: president, Type: TABLE_DATA, Schema: president
--

INSERT INTO president.president (id, name, birth_year, years_served, death_age, party) VALUES (1, 'John Adams', 1735, 4, 90, 'FEDERALIST'); 		-- should work
INSERT INTO president.president (id, name, birth_year, years_served, death_age, party) VALUES (2, 'Franklin Pierce', 1804, 4, 64, 'UNKNOWN'); 		-- should not work
INSERT INTO president.president (id, name, birth_year, years_served, death_age, party) VALUES (2, 'Franklin Pierce', 1804, 4, 64, 'DEMOCRATIC'); 	-- should work
INSERT INTO president.president (id, name, birth_year, years_served, death_age, party) VALUES (3, 'Abraham Lincoln', 1809, 4, 56, 'WHIG'); 			-- should not work
INSERT INTO president.president (id, name, birth_year, years_served, death_age, party) VALUES (3, 'Abraham Lincoln', 1809, 4, 56, 'REPUBLIC'); 		-- should work
INSERT INTO president.president (id, name, birth_year, years_served, death_age, party) VALUES (4, 'Theodore Roosevelt', 1809, 8, 60, 'REPUBLIC'); 	-- should work

--
-- Name: pres_marriage, Type: TABLE_DATA, Schema: president
--

INSERT INTO president.pres_marriage (pres_id, spouse_name, spouse_age, nr_children, marriage_year) VALUES (1, 'Abigail Adams', 20, 6, 1764); 		-- should not work
INSERT INTO president.pres_marriage (pres_id, spouse_name, spouse_age, nr_children, marriage_year) VALUES (1, 'Abigail Adams', 53, 6, 1764); 		-- should work
INSERT INTO president.pres_marriage (pres_id, spouse_name, spouse_age, nr_children, marriage_year) VALUES (2, 'Jane Pierce',17, 3, 1834); 			-- should not work
INSERT INTO president.pres_marriage (pres_id, spouse_name, spouse_age, nr_children, marriage_year) VALUES (2, 'Jane Pierce', 57, 3, 1834); 			-- should work
INSERT INTO president.pres_marriage (pres_id, spouse_name, spouse_age, nr_children, marriage_year) VALUES (3, 'Mary Lincoln', 63, 4, 1842); 		-- should not work
INSERT INTO president.pres_marriage (pres_id, spouse_name, spouse_age, nr_children, marriage_year) VALUES (3, 'Mary Lincoln', 60, 4, 1842); 		-- should work
INSERT INTO president.pres_marriage (pres_id, spouse_name, spouse_age, nr_children, marriage_year) VALUES (4, 'Alice Roosevelt', 22, 1, 1880);		-- should work
