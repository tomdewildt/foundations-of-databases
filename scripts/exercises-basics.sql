---
--- Set 1 - Question 1
---

SELECT max(spouse_age)FROM president.pres_marriage WHERE nr_children > 3;

---
--- Set 1 - Question 2
---

SELECT avg(nr_children) FROM president.pres_marriage WHERE marriage_year > 1930;

---
--- Set 1 - Question 3
---

SELECT avg(years_served) FROM president.president;

---
--- Set 1 - Question 4
---

SELECT min(votes)
FROM president.election
WHERE winner_loser_indic = 'W' AND election_year BETWEEN 1801 AND 1900;

---
--- Set 1 - Question 5
---

SELECT sum(votes) FROM president.election WHERE election_year = 1808;

---
--- Set 1 - Question 6
---

SELECT count(*)
FROM president.election
WHERE winner_loser_indic = 'W' AND election_year BETWEEN 1901 AND 2000;

---
--- Set 1 - Question 7
---

SELECT count(DISTINCT candidate) FROM president.election WHERE winner_loser_indic = 'L';

---
--- Set 1 - Question 8
---

SELECT count(*) FROM president.election WHERE winner_loser_indic = 'L';

---
--- Set 1 - Question 9
---

SELECT count(*) FROM president.state WHERE year_entered BETWEEN 1875 AND 1925;

---
--- Set 1 - Question 10
---

SELECT count(DISTINCT state_id_born) FROM president.president WHERE birth_year < 1900;

---
--- Set 1 - Question 11
---

SELECT count(*) FROM president.pres_marriage WHERE marriage_year > 1900;

---
--- Set 2 - Question 1
---

SELECT sum(nr_children)
FROM president.pres_marriage
WHERE spouse_age BETWEEN 30 AND 40 AND (marriage_year < 1900 OR marriage_year > 1950);

---
--- Set 2 - Question 2
---

SELECT max(death_age) - min(death_age) AS difference
FROM president.president
WHERE years_served > 4;

---
--- Set 2 - Question 3
---

SELECT round(avg(nr_children)) FROM president.pres_marriage WHERE spouse_age > 20;

---
--- Set 2 - Question 4
---

SELECT count(*)
FROM president.pres_marriage
WHERE nr_children > 0 AND (45.0 - spouse_age) / nr_children <= 5;

---
--- Set 2 - Question 5
---

SELECT count(*)
FROM president.president
WHERE birth_year <= 1950 AND death_age IS NULL OR birth_year + death_age >= 1950;

---
--- Set 2 - Question 6
---

SELECT count(*) FROM president.pres_marriage WHERE nr_children = 1;

---
--- Set 2 - Question 7
---

SELECT avg(death_age) FROM president.president WHERE party = 'DEMOCRATIC' AND birth_year < 1900;

---
--- Set 3 - Question 1
---

SELECT election_year, count(candidate) AS candidate, min(votes) AS minimum_votes
FROM president.election
GROUP BY election_year
HAVING count(candidate) >= 3 AND min(votes) > 20;

---
--- Set 3 - Question 2
---

SELECT pres_id, count(hobby) AS number_hobbies
FROM president.pres_hobby
GROUP BY pres_id
HAVING count(hobby) >= 5
ORDER BY pres_id;

---
--- Set 3 - Question 3
---

SELECT election_year, sum(votes) AS votes_cast
FROM president.election
GROUP BY election_year
HAVING election_year > 1900 AND count(votes) >= 3
ORDER BY election_year;

---
--- Set 3 - Question 4
---

WITH election_result AS (
    SELECT election_year, (max(votes) - min(votes)) AS votes_diff
    FROM president.election
    GROUP BY election_year
    HAVING election_year > 1900 AND count(votes) = 2
)
SELECT max(votes_diff) FROM election_result;

---
--- Set 3 - Question 5
---

SELECT election_year, count(votes)
FROM president.election
GROUP BY election_year
HAVING election_year > 1850 AND count(votes) > 2 AND ((100.0 / sum(votes)) * max(votes)) >= 80
ORDER BY election_year;

---
--- Set 3 - Question 6
---

SELECT pres_id, max(nr_children) AS maxchild, min(nr_children) AS minchild
FROM president.pres_marriage
GROUP BY pres_id
HAVING count(*) >= 2
ORDER BY pres_id;

---
--- Set 3 - Question 7
---

SELECT pres_id
FROM president.pres_marriage
GROUP BY pres_id
HAVING count(*) = 1 AND min(spouse_age) >= 30
ORDER BY pres_id;

---
--- Set 3 - Question 8
---

SELECT pres_id, round(avg(nr_children)) AS average
FROM president.pres_marriage
GROUP BY pres_id
HAVING max(spouse_age) < 30 AND round(avg(nr_children)) > 4
ORDER BY pres_id;

---
--- Set 3 - Question 9
---

SELECT pres_id, sum(nr_children) AS sumchild
FROM president.pres_marriage
GROUP BY pres_id
HAVING min(spouse_age) > 30
ORDER BY pres_id;

---
--- Set 3 - Question 10
---

SELECT pres_id
FROM president.pres_marriage
GROUP BY pres_id
HAVING max(nr_children) = 0
ORDER BY pres_id DESC;

---
--- Set 3 - Question 11
---

SELECT pres_id
FROM president.pres_marriage
GROUP BY pres_id
HAVING count(*) > 1 AND min(nr_children) >= 2
ORDER BY pres_id;

---
--- Set 3 - Question 12
---

SELECT death_age, count(*) AS numberpres
FROM president.president
GROUP BY death_age
HAVING death_age > 85
ORDER BY death_age;

---
--- Set 4 - Question 1
---

SELECT pm.spouse_name
FROM president.president p
JOIN president.pres_marriage pm ON p.id = pm.pres_id
JOIN president.state s ON p.state_id_born = s.id
WHERE s.year_entered > 1850;

---
--- Set 4 - Question 2
---

SELECT p.name, e.election_year, e.votes
FROM president.president p
JOIN president.election e ON p.name = e.candidate
JOIN president.state s ON p.state_id_born = s.id
WHERE p.party = 'DEMOCRATIC' AND e.election_year > 1900 AND s.year_entered > 1800
ORDER BY p.name;

---
--- Set 4 - Question 3
---

SELECT p.name, pm.spouse_name, pm.nr_children
FROM president.president p
JOIN president.pres_marriage pm ON p.id = pm.pres_id
WHERE p.party = 'REPUBLICAN' AND pm.marriage_year > 1900
GROUP BY p.name, pm.spouse_name, pm.nr_children
HAVING min(pm.nr_children) >= 2;

---
--- Set 4 - Question 4
---

SELECT p.name, p.years_served AS "sum", count(pm.pres_id) AS nummar, sum(pm.nr_children) AS sumchi
FROM president.president p
JOIN president.pres_marriage pm ON p.id = pm.pres_id
WHERE p.years_served >= 8
GROUP BY p.name, p.years_served
HAVING count(pm.pres_id) >= 2
ORDER BY p.name DESC;

---
--- Set 4 - Question 5
---

SELECT s.name, s.year_entered, p.name
FROM president.president p
JOIN president.state s ON p.state_id_born = s.id
WHERE s.year_entered > 1800 AND p.years_served >= 4;

---
--- Set 4 - Question 6
---

SELECT p.name, p.birth_year, e.election_year, e.candidate, e.votes, e.winner_loser_indic
FROM president.president p
JOIN president.election e ON p.name = e.candidate
WHERE p.party = 'REPUBLICAN' AND e.election_year BETWEEN 1950 AND 1980;

---
--- Set 4 - Question 7
---

SELECT p.name, p.years_served, avg(e.votes) AS averagevotes
FROM president.president p
JOIN president.election e ON p.name = e.candidate
JOIN president.state s ON p.state_id_born = s.id
WHERE s.name = 'TEXAS'
GROUP BY p.name, p.years_served
HAVING avg(e.votes) > 450;

---
--- Set 4 - Question 8
---

SELECT p.name, p.years_served, pm.spouse_name, max(e.votes) AS maxvotes
FROM president.president p
JOIN president.pres_marriage pm ON p.id = pm.pres_id
JOIN president.election e ON p.name = e.candidate
JOIN president.state s ON p.state_id_born = s.id
WHERE s.name = 'TEXAS'
GROUP BY p.name, p.years_served, pm.spouse_name;

---
--- Set 4 - Question 9
---

SELECT e.candidate, round(avg(e.votes)) AS average, p.years_served
FROM president.president p
JOIN president.election e ON p.name = e.candidate
WHERE p.years_served >= 6
GROUP BY e.candidate, p.years_served
HAVING count(*) >= 2;
