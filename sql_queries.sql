--R1

SELECT intitule FROM enseignement WHERE description LIKE '%SQL%' OR description LIKE '%Licence%';

--R2

SELECT enseignement_id,sum(nombre_heures)*50 AS "cout" FROM reservation GROUP BY enseignement_id;

--R2

SELECT intitule,sum(nombre_heures)*50 AS cout FROM enseignement e,reservation r WHERE e.enseignement_id=r.enseignement_id  GROUP BY intitule HAVING sum(nombre_heures)*50 BETWEEN 500 AND 750;

--R3

SELECT AVG(capacite) AS "AVGCAPACITE",max(capacite) AS "MAXCAPACITE" FROM salle;

--R4

SELECT numero_salle,capacite FROM salle WHERE capacite < (SELECT AVG(capacite) FROM salle);

--R5

SELECT prenom,nom FROM enseignant e,departement d WHERE e.departement_id=d.departement_id AND (d.nom_departement='MIDO' OR d.nom_departement='LSO');

--R6

SELECT prenom,nom FROM enseignant e,departement d WHERE e.departement_id=d.departement_id AND (d.nom_departement<>'MIDO' AND d.nom_departement<>'LSO');

--R6

SELECT ville,count(etudiant_id) FROM etudiant GROUP BY ville;

--R7

SELECT nom_departement,count(enseignement_id) FROM departement d, enseignement e where e.departement_id = d.departement_id GROUP BY d.departement_id;

--R8

SELECT nom_departement,count(enseignement_id) FROM departement d, enseignement e where e.departement_id = d.departement_id GROUP BY d.departement_id HAVING count(enseignement_id)>=3;

--R9

CREATE VIEW nbr_res_parEns AS
SELECT enseignant_id,count(reservation_id) FROM reservation GROUP BY enseignant_id;

--R10

1SELECT nom,prenom,count FROM enseignant e , nbr_res_parens nr WHERE e.enseignant_id = nr.enseignant_id AND count >= 2;

--R12

SELECT nom,prenom FROM enseignant e , nbr_res_parens nr WHERE e.enseignant_id = nr.enseignant_id AND count = (SELECT MAX(count) FROM nbr_res_parens);

--R13

SELECT DISTINCT nom,prenom FROM enseignant WHERE enseignant_id NOT IN (SELECT enseignant_id  FROM nbr_res_parens);

--R14

SELECT numero_salle,COUNT(reservation_id) FROM reservation GROUP BY numero_salle HAVING count(reservation_id) = (SELECT count(DISTINCT date_resa) from reservation);

--R15

SELECT enseignant_id, nom, prenom FROM Enseignant E WHERE enseignant_id NOT IN (SELECT enseignant_id FROM visual);

-- R16

SELECT DISTINCT date_resa FROM Reservation R1 WHERE EXISTS (SELECT COUNT(*) FROM salle WHERE (batiment,numero_salle) IN (SELECT batiment,numero_salle FROM Reservation R2 WHERE R1.date_resa = R2.date_resa) HAVING COUNT(*) = (SELECT COUNT(*) FROM salle));