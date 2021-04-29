---
--- Set 1 - Question 1
---

CREATE OR REPLACE FUNCTION president.increment_years_served(_pres_id int)
RETURNS void AS $$
DECLARE
    _years_served president.president.years_served%type;
BEGIN
    SELECT years_served INTO _years_served
    FROM president.president
    WHERE id = _pres_id;

    IF _years_served IS NULL THEN
        RAISE EXCEPTION 'cannot not find president with id %', _pres_id;
    ELSEIF _years_served + 1 > 8 THEN
        RAISE EXCEPTION 'cannot not increase years served beyond 8';
    END IF;

    UPDATE president.president SET years_served = _years_served + 1 WHERE id = _pres_id;
END;
$$ LANGUAGE plpgsql;

SELECT president.increment_years_served(45);

---
--- Set 1 - Question 2
---

CREATE OR REPLACE FUNCTION president.add_marriage(_pres_id president.pres_marriage.pres_id%type,
                                                  _spouse_name president.pres_marriage.spouse_name%type,
                                                  _spouse_age president.pres_marriage.spouse_age%type,
                                                  _nr_children president.pres_marriage.nr_children%type,
                                                  _marriage_year president.pres_marriage.marriage_year%type)
RETURNS void AS $$
DECLARE
    _birth_year president.president.birth_year%type;
BEGIN
    SELECT birth_year INTO _birth_year
    FROM president.president
    WHERE id = _pres_id;

    IF _birth_year IS NULL THEN
        RAISE EXCEPTION 'cannot not find president with id %', _pres_id;
    ELSEIF _marriage_year < _birth_year + 21 THEN
        RAISE EXCEPTION 'cannot store marriage with year before %', _birth_year + 21;
    END IF;

    INSERT INTO president.pres_marriage VALUES (_pres_id, _spouse_name, _spouse_age, _nr_children, _marriage_year);
END;
$$ LANGUAGE plpgsql;

SELECT president.add_marriage(45, 'NAME', 50::smallint, 0::smallint, 2000);

---
--- Set 1 - Question 3
---

CREATE OR REPLACE FUNCTION president.add_hobby(_pres_id president.pres_hobby.pres_id%type,
                                               _hobby president.pres_hobby.hobby%type)
RETURNS void AS $$
DECLARE
BEGIN
    IF _pres_id NOT IN (SELECT id FROM president.president) THEN
        RAISE EXCEPTION 'cannot not find president with id %', _pres_id;
    ELSEIF _hobby NOT IN (SELECT DISTINCT hobby FROM president.pres_hobby) THEN
        RAISE EXCEPTION 'cannot not find hobby with name %', _hobby;
    END IF;
    
    INSERT INTO president.pres_hobby VALUES (_pres_id, _hobby);
END;
$$ LANGUAGE plpgsql;

SELECT president.add_hobby(45, 'GOLF');

---
--- Set 1 - Question 4
---

CREATE OR REPLACE FUNCTION president.add_state(_name president.state.name%type)
RETURNS void AS $$
DECLARE
    _year_entered president.state.year_entered%type;
BEGIN
    SELECT date_part('year', CURRENT_DATE) INTO _year_entered;

    INSERT INTO president.state (name, year_entered) VALUES (_name, _year_entered);
END;
$$ LANGUAGE plpgsql;

SELECT president.add_state('NAME');

---
--- Set 2 - Question 1
---

CREATE OR REPLACE FUNCTION president.tr_votes_sum()
RETURNS trigger AS $$
BEGIN
    IF (SELECT sum(votes) FROM president.election WHERE election_year = new.election_year) + new.votes > 538 THEN
        RAISE NOTICE 'sum of votes for election of % cannot be larger than 538', new.election_year;
        RETURN NULL;
    END IF;

    RETURN new;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS tr_votes_sum ON president.election;

CREATE TRIGGER tr_votes_sum
BEFORE INSERT OR UPDATE ON president.election
FOR EACH ROW EXECUTE PROCEDURE president.tr_votes_sum();

INSERT INTO president.election VALUES (2020, 'CANDIDATE', 1, 'L');

---
--- Set 2 - Question 2
---

CREATE OR REPLACE FUNCTION president.tr_winner_loser_indic_count()
RETURNS trigger AS $$
BEGIN
    IF new.winner_loser_indic = 'W' AND (SELECT count(*) FROM president.election WHERE election_year = new.election_year) > 0 THEN
        RAISE NOTICE 'election of % can only have one winner', new.election_year;
        RETURN NULL;
    END IF;

    RETURN new;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS tr_winner_loser_indic_count ON president.election;

CREATE TRIGGER tr_winner_loser_indic_count
BEFORE INSERT OR UPDATE ON president.election
FOR EACH ROW EXECUTE PROCEDURE president.tr_winner_loser_indic_count();

INSERT INTO president.election VALUES (2020, 'CANDIDATE', 0, 'W');

---
--- Set 2 - Question 3
---

CREATE OR REPLACE FUNCTION president.tr_election_loser()
RETURNS trigger AS $$
BEGIN
    IF new.winner_loser_indic = 'L' AND new.votes > (SELECT max(votes) FROM president.election WHERE election_year = new.election_year) THEN
        RAISE NOTICE '% of election % cannot be the election loser', new.candidate, new.election_year;
        RETURN NULL;
    END IF;

    RETURN new;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS tr_election_loser ON president.election;

CREATE TRIGGER tr_election_loser
BEFORE INSERT OR UPDATE ON president.election
FOR EACH ROW EXECUTE PROCEDURE president.tr_election_loser();

INSERT INTO president.election VALUES (2024, 'CANDIDATE 1', 200, 'L');
INSERT INTO president.election VALUES (2024, 'CANDIDATE 2', 300, 'L');

---
--- Set 2 - Question 4
---

CREATE OR REPLACE FUNCTION president.tr_election_winner()
RETURNS trigger AS $$
BEGIN
    IF new.winner_loser_indic = 'W' AND new.votes < (SELECT max(votes) FROM president.election WHERE election_year = new.election_year) THEN
        RAISE NOTICE '% of election % cannot be the election winner', new.candidate, new.election_year;
        RETURN NULL;
    END IF;

    RETURN new;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS tr_election_winner ON president.election;

CREATE TRIGGER tr_election_winner
BEFORE INSERT OR UPDATE ON president.election
FOR EACH ROW EXECUTE PROCEDURE president.tr_election_winner();

INSERT INTO president.election VALUES (2028, 'CANDIDATE 1', 300, 'W');
INSERT INTO president.election VALUES (2028, 'CANDIDATE 2', 200, 'W');
