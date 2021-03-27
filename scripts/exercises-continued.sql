---
--- Set 1 - Question 1
---
SELECT p.name, p.party
    FROM president.president p
        WHERE p.name IN (SELECT a.vice_pres_name FROM president.admin_vpres a);

---
--- Set 1 - Question 2
---
SELECT p.name, p.birth_year
    FROM president.president p
        WHERE p.years_served > (SELECT avg(_p.years_served)
                                    FROM president.president _p
                                        WHERE _p.birth_year > 1850)
            ORDER BY p.name;

---
--- Set 1 - Question 3
---
SELECT p.birth_year
    FROM president.president p
        WHERE p.death_age < (SELECT min(_p.death_age)
                                FROM president.president _p
                                    WHERE _p.birth_year < 1800);

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
        WHERE p.birth_year > 1800 AND (SELECT count(*)
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
SELECT p.party, count(*) AS num
    FROM president.president p
        WHERE (SELECT count(*)
                FROM president.president _p
                    WHERE _p.birth_year > 1900 AND _p.party = p.party) > 2
            GROUP BY p.party
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
