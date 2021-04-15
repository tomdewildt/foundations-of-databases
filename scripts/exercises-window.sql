---
--- Set 1 - Question 1
---

SELECT p.name,
       p.death_age,
       avg(p.death_age) OVER (PARTITION BY p.party) AS avg_deathage_party,
       avg(p.death_age) OVER (PARTITION BY p.state_id_born) AS avg_deathage_state
FROM president.president p
WHERE p.death_age IS NOT NULL;

---
--- Set 1 - Question 2
---

SELECT e.candidate,
       cast(e.votes AS decimal) / sum(e.votes) OVER (PARTITION BY e.election_year) * 100 AS votes_percentage
FROM president.election e
WHERE e.election_year > 2000;

---
--- Set 1 - Question 3
---

SELECT p.name, p.birth_year, s.name, row_number() OVER (PARTITION BY s.name)
FROM president.president p
JOIN president.state s ON p.state_id_born = s.id
WHERE p.birth_year > 1850;

---
--- Set 1 - Question 4
---

SELECT p.name,
       p.party,
       p.years_served,
       sum(p.years_served) OVER (PARTITION BY p.party ORDER BY p.id)
FROM president.president p
WHERE p.party != 'REPUBLICAN' AND p.party != 'DEMOCRATIC';

---
--- Set 1 - Question 5
---

SELECT p.name, ph.hobby, count(*) OVER (PARTITION BY ph.hobby)
FROM president.president p
JOIN president.pres_hobby ph ON p.id = ph.pres_id
WHERE p.party = 'DEMOCRATIC'
ORDER BY ph.hobby;
