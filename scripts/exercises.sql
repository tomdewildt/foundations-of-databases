---
--- Set 1
---

SELECT max(spouse_age) FROM president.pres_marriage WHERE nr_children > 3;

SELECT avg(nr_children) FROM president.pres_marriage WHERE marriage_year > 1930;

SELECT avg(years_served) FROM president.president;

SELECT min(votes) FROM president.election WHERE winner_loser_indic = 'W' AND election_year BETWEEN 1801 AND 1900;

SELECT sum(votes) FROM president.election WHERE election_year = 1808;

SELECT count(*) FROM president.election WHERE winner_loser_indic = 'W' AND election_year BETWEEN 1901 AND 2000;

SELECT count(DISTINCT candidate) FROM president.election WHERE winner_loser_indic = 'L';

SELECT count(*)  FROM president.election WHERE winner_loser_indic = 'L';

SELECT count(*) FROM president.state WHERE year_entered BETWEEN 1875 AND 1925;

SELECT count(DISTINCT state_id_born) FROM president.president WHERE birth_year < 1900;

SELECT count(*) FROM president.pres_marriage WHERE marriage_year > 1900;

---
--- Set 2
---

SELECT sum(nr_children) FROM president.pres_marriage WHERE spouse_age BETWEEN 30 AND 40 AND (marriage_year < 1900 OR marriage_year > 1950);

SELECT max(death_age) - min(death_age) AS difference FROM president.president WHERE years_served > 4;

SELECT round(avg(nr_children)) FROM president.pres_marriage WHERE spouse_age > 20;

SELECT count(*) FROM president.pres_marriage WHERE nr_children > 0 AND (45.0 - spouse_age)/nr_children <= 5;

SELECT count(*) FROM president.president WHERE birth_year <= 1950 AND death_age IS NULL OR birth_year + death_age >= 1950;

SELECT count(*) FROM president.pres_marriage WHERE nr_children = 1;

SELECT avg(death_age) FROM president.president WHERE party = 'DEMOCRATIC' AND birth_year < 1900;
