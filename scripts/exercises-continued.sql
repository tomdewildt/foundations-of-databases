---
--- Set 1 - Question 1
---

SELECT p.name, p.party
FROM president.president p
WHERE p.name IN (SELECT a.vice_pres_name FROM president.admin_vpres a);

---
--- Set 1 - Question 2
---

SELECT p1.name, p1.birth_year
FROM president.president p1
WHERE p1.years_served > (SELECT avg(p2.years_served)
                         FROM president.president p2
                         WHERE p2.birth_year > 1850)
ORDER BY p1.name;

---
--- Set 1 - Question 3
---

SELECT p1.birth_year
FROM president.president p1
WHERE p1.death_age < (SELECT min(p2.death_age)
                      FROM president.president p2
                      WHERE p2.birth_year < 1800);

---
--- Set 1 - Question 4
---

SELECT p.name, p.birth_year
FROM president.president p
WHERE p.id IN (SELECT pm.pres_id
               FROM president.pres_marriage pm
               GROUP BY pm.pres_id
               HAVING min(pm.nr_children) > 6)
ORDER BY p.name;

---
--- Set 1 - Question 5
---

SELECT p.name, p.party
FROM president.president p
WHERE p.birth_year > 1800
AND (SELECT count(*)
     FROM president.pres_marriage pm
     WHERE pm.pres_id = p.id) >= 2;

---
--- Set 1 - Question 6
---

SELECT p.name, p.years_served
FROM president.president p
WHERE p.name = (SELECT e.candidate
                FROM president.election e
                WHERE e.votes = (SELECT max(e.votes) FROM president.election e));

---
--- Set 1 - Question 7
---

SELECT p1.party, count(*) AS num
FROM president.president p1
WHERE (SELECT count(*)
       FROM president.president p2
       WHERE p2.birth_year > 1900 AND p2.party = p1.party) > 2
GROUP BY p1.party
ORDER BY num DESC;

---
--- Set 1 - Question 8
---

SELECT p.name, p.party
FROM president.president p
WHERE p.id IN (SELECT pm.pres_id
               FROM president.pres_marriage pm
               GROUP BY pm.pres_id
               HAVING count(*) >= 2 AND sum(pm.nr_children) >= 2);

---
--- Set 2 - Question 1
---

SELECT p.name, p.party
FROM president.president p
WHERE p.id IN (SELECT pm.pres_id
               FROM president.pres_marriage pm
               GROUP BY pm.pres_id
               HAVING count(*) >= 2);

---
--- Set 2 - Question 2
---

SELECT p.name, p.birth_year
FROM president.president p
WHERE (SELECT count(*)
       FROM president.pres_hobby ph
       WHERE ph.pres_id = p.id) > 4;

---
--- Set 2 - Question 3
---

SELECT p1.name, p1.party, p1.years_served
FROM president.president p1
WHERE p1.years_served = (SELECT max(p2.years_served)
                         FROM president.president p2
                         WHERE p2.party = p1.party)
ORDER BY p1.years_served DESC;

---
--- Set 2 - Question 4
---

SELECT p1.name, p1.birth_year
FROM president.president p1
WHERE p1.death_age > (SELECT avg(p2.death_age)
                      FROM president.president p2
                      WHERE p2.state_id_born = p1.state_id_born)
ORDER BY p1.birth_year;

---
--- Set 2 - Question 5
---

SELECT e1.candidate, e1.election_year, e1.votes
FROM president.election e1
WHERE e1.election_year > 1970
AND e1.election_year = (SELECT min(e2.election_year)
                        FROM president.election e2
                        WHERE e2.candidate = e1.candidate)
ORDER BY e1.candidate;

---
--- Set 3 - Question 1
---

SELECT s.name
FROM president.state s
WHERE s.id IN (SELECT p.state_id_born FROM president.president p)
AND s.id NOT IN (SELECT p.state_id_born
                 FROM president.president p
                 WHERE p.id IN (SELECT ph.pres_id FROM president.pres_hobby ph));

---
--- Set 3 - Question 2
---

SELECT DISTINCT ph.hobby
FROM president.pres_hobby ph
WHERE ph.pres_id IN (SELECT p.id
                     FROM president.president p
                     WHERE p.name NOT IN (SELECT e.candidate
                                          FROM president.election e
                                          GROUP BY e.candidate, e.winner_loser_indic
                                          HAVING e.winner_loser_indic = 'L'))
ORDER BY ph.hobby;

---
--- Set 3 - Question 3
---

SELECT s.name
FROM president.state s
WHERE s.id IN (SELECT p.state_id_born FROM president.president p)
AND s.id NOT IN (SELECT p.state_id_born
                 FROM president.president p
                 JOIN president.administration a
                 ON p.id = a.pres_id
                 WHERE a.year_inaugurated <= 1900)
ORDER BY s.name;

---
--- Set 3 - Question 4
---

SELECT e1.candidate
FROM president.election e1
WHERE e1.candidate IN (SELECT e2.candidate
                       FROM president.election e2
                       GROUP BY e2.candidate
                       HAVING min(e2.votes) = 1 AND max(e2.votes) = 1)
ORDER BY e1.votes;

---
--- Set 3 - Question 5
---

SELECT s.name
FROM president.state s
WHERE s.id IN (SELECT p.state_id_born FROM president.president p)
AND s.id NOT IN (SELECT p.state_id_born
                 FROM president.president p
                 JOIN president.election e ON p.name = e.candidate
                 WHERE e.winner_loser_indic = 'L')
ORDER BY s.name;

---
--- Set 3 - Question 6
---

SELECT s.name
FROM president.state s
WHERE s.id IN (SELECT p.state_id_born FROM president.president p)
AND s.id NOT IN (SELECT p.state_id_born
                 FROM president.president p
                 JOIN president.pres_marriage pm ON p.id = pm.pres_id
                 GROUP BY p.id
                 HAVING min(pm.nr_children) = 0)
ORDER BY s.name;

---
--- Set 3 - Question 7
---

SELECT DISTINCT p1.party
FROM president.president p1
WHERE p1.party NOT IN (SELECT p2.party
                       FROM president.president p2
                       JOIN president.pres_marriage pm ON p2.id = pm.pres_id
                       GROUP BY p2.id
                       HAVING sum(pm.nr_children) = 0);

---
--- Set 3 - Question 8
---

SELECT DISTINCT s.name
FROM president.state s
JOIN president.president p ON s.id = p.state_id_born
WHERE p.id NOT IN (SELECT pm.pres_id
                   FROM president.pres_marriage pm
                   WHERE pm.nr_children > 0);

---
--- Set 3 - Question 9
---

SELECT p.name
FROM president.president p
WHERE p.id IN (SELECT ph1.pres_id
               FROM president.pres_hobby ph1
               WHERE ph1.hobby = (SELECT ph2.hobby
                                  FROM president.pres_hobby ph2
                                  JOIN president.president p ON ph2.pres_id = p.id
                                  WHERE p.name = 'JACKSON A'))
AND p.id IN (SELECT ph1.pres_id
             FROM president.pres_hobby ph1
             GROUP BY ph1.pres_id
             HAVING count(*) = (SELECT count(*)
                                FROM president.pres_hobby ph2
                                JOIN president.president p ON ph2.pres_id = p.id
                                WHERE p.name = 'JACKSON A'));

---
--- Set 3 - Question 10
---

SELECT DISTINCT ph.hobby
FROM president.pres_hobby ph
WHERE ph.pres_id IN (SELECT pm.pres_id FROM president.pres_marriage pm);

---
--- Set 3 - Question 11
---

SELECT ph1.hobby
FROM president.pres_hobby ph1
WHERE ph1.hobby NOT IN (SELECT ph2.hobby
                        FROM president.pres_hobby ph2
                        JOIN president.president p ON ph2.pres_id = p.id
                        JOIN president.state s ON p.state_id_born = s.id
                        WHERE s.name != 'TEXAS');

---
--- Set 4 - Question 1
---

WITH party_hobby_count AS (
       SELECT p.party, count(*)
       FROM president.president p
       JOIN president.pres_hobby ph ON p.id = ph.pres_id
       GROUP BY p.name, p.party
)
SELECT p.name, p.party
FROM president.president p
JOIN president.pres_hobby ph ON p.id = ph.pres_id
GROUP BY p.name, p.party
HAVING count(*) = (SELECT max(phc.count)
                   FROM party_hobby_count phc
                   WHERE phc.party = p.party)
ORDER BY p.party;

---
--- Set 4 - Question 2
---

WITH party_president_count AS (
       SELECT p.party, count(*)
       FROM president.president p
       GROUP BY p.party
)
SELECT p.party, count(*)
FROM president.president p
GROUP BY p.party
HAVING count(*) = (SELECT max(ppc.count) FROM party_president_count ppc);

---
--- Set 4 - Question 3
---

WITH state_count AS (
       SELECT s.year_entered, count(*)
       FROM president.state s
       GROUP BY s.year_entered
)
SELECT a.admin_nr
FROM president.administration a
WHERE a.id = (SELECT s1.admin_id
              FROM president.state s1
              WHERE s1.year_entered = 100 + (SELECT s2.year_entered
                                             FROM president.state s2
                                             GROUP BY s2.year_entered
                                             HAVING count(*) = (SELECT max(sc.count)
                                                                FROM state_count sc)));

---
--- Set 4 - Question 4
---

WITH election_candiate_count AS (
       SELECT e.election_year, count(*)
       FROM president.election e
       GROUP BY e.election_year
)
SELECT e.election_year
FROM president.election e
GROUP BY e.election_year
HAVING count(*) = (SELECT max(ecc.count) FROM election_candiate_count ecc);

---
--- Set 4 - Question 5
---

SELECT p.name, p.birth_year, (SELECT a1.year_inaugurated
                              FROM president.administration a1
                              WHERE a1.pres_id = max(p.id)
                              ORDER BY a1.year_inaugurated
                              LIMIT 1) AS "first", (SELECT a1.year_inaugurated
                                                    FROM president.administration a1
                                                    WHERE a1.pres_id = max(p.id)
                                                    ORDER BY a1.year_inaugurated
                                                    LIMIT 1 OFFSET 1) AS "second", (SELECT a1.year_inaugurated
                                                                                    FROM president.administration a1
                                                                                    WHERE a1.pres_id = max(p.id)
                                                                                    ORDER BY a1.year_inaugurated
                                                                                    LIMIT 1 OFFSET 2) AS "third", (SELECT a1.year_inaugurated
                                                                                                                   FROM president.administration a1
                                                                                                                   WHERE a1.pres_id = max(p.id)
                                                                                                                   ORDER BY a1.year_inaugurated
                                                                                                                   LIMIT 1 OFFSET 3) AS "fourth"
FROM president.president p
JOIN president.administration a ON p.id = a.pres_id
GROUP BY p.name, p.birth_year
HAVING count(*) = 4;

---
--- Set 4 - Question 6
---

SELECT p.name
FROM president.president p
JOIN president.state s ON p.state_id_born = s.id
WHERE s.name = 'VIRGINIA' AND p.years_served >= 1 AND (SELECT min(e.election_year)
                                                       FROM president.election e
                                                       WHERE e.candidate = p.name) - p.birth_year >= 60;

---
--- Set 4 - Question 7
---

SELECT p1.name, max(a.year_inaugurated)
FROM president.president p1
JOIN president.administration a ON p1.id = a.pres_id
GROUP BY p1.name
HAVING max(a.year_inaugurated) > (SELECT min(pm.marriage_year)
                                  FROM president.president p2
                                  JOIN president.pres_marriage pm ON p2.id = pm.pres_id
                                  WHERE p2.name = 'REAGAN R');

---
--- Set 4 - Question 8
---

SELECT p.name
FROM president.president p
JOIN president.pres_marriage pm ON p.id = pm.pres_id
GROUP BY p.name
HAVING sum(pm.marriage_year) - max(p.birth_year) < sum(pm.spouse_age)
ORDER BY p.name; 

---
--- Set 4 - Question 9
---

SELECT e.candidate, (e.election_year - p.birth_year) AS age
FROM president.election e
JOIN president.president p ON e.candidate = p.name
ORDER BY age
LIMIT 1;

---
--- Set 4 - Question 10
---

SELECT p.name, p.birth_year, (max(pm.marriage_year) - p.birth_year) AS president_age
FROM president.president p
JOIN president.pres_marriage pm ON p.id = pm.pres_id
GROUP BY p.name, p.birth_year
HAVING count(*) > 1
ORDER BY p.name;

---
--- Set 4 - Question 11
---

SELECT p.name
FROM president.president p
JOIN president.pres_marriage pm ON p.id = pm.pres_id
GROUP BY p.name
HAVING sum(pm.nr_children) < (SELECT count(*)
                              FROM president.election e
                              WHERE e.candidate = p.name)
ORDER BY p.name;

---
--- Set 4 - Question 12
---

SELECT p.name
FROM president.president p
JOIN president.pres_marriage pm ON p.id = pm.pres_id
GROUP BY p.id, p.name
HAVING sum(pm.nr_children) = (SELECT count(*)
                              FROM president.administration a
                              WHERE a.pres_id = p.id)
ORDER BY p.name;

---
--- Set 4 - Question 13
---

SELECT p.name
FROM president.president p
JOIN president.pres_marriage pm ON p.id = pm.pres_id
JOIN president.administration a ON p.id = a.pres_id
GROUP BY p.name
HAVING min(pm.marriage_year) > min(a.year_inaugurated);
