CREATE DATABASE IF NOT EXISTS p1;
USE p1;

CREATE TABLE hotel (
    idhotel INT PRIMARY KEY,
    ville VARCHAR(100),
    pays VARCHAR(100),
    codepostal INT
);

CREATE TABLE client (
    idclient INT PRIMARY KEY,
    adress VARCHAR(100),
    ville VARCHAR(100),
    codepostal INT,
    email VARCHAR(100),
    numtele VARCHAR(20),
    nomcomplet VARCHAR(100)
);

CREATE TABLE prestation (
    idprestation INT PRIMARY KEY,
    prix INT,
    designation VARCHAR(100)
);


CREATE TABLE typechambre (
    idtype INT PRIMARY KEY,
    type VARCHAR(100),
    tarif INT
);

CREATE TABLE chambre (
    id_chambre INT PRIMARY KEY,
    numerochambre INT,
    etage INT,
    fumeurs BOOLEAN,
    idtype INT,
    idhotel INT,
    FOREIGN KEY (idtype) REFERENCES typechambre(idtype),
    FOREIGN KEY (idhotel) REFERENCES hotel(idhotel)
);

CREATE TABLE reservation (
    idreservation INT PRIMARY KEY,
    datearrive DATE,
    datedepart DATE,
    idclient INT,
    FOREIGN KEY (idclient) REFERENCES client(idclient)
);

CREATE TABLE reservation_chambre (
    idreservation INT,
    id_chambre INT,
    PRIMARY KEY (idreservation, id_chambre),
    FOREIGN KEY (idreservation) REFERENCES reservation(idreservation),
    FOREIGN KEY (id_chambre) REFERENCES chambre(id_chambre)
);

CREATE TABLE evaluation (
    idevaluation INT PRIMARY KEY,
    datearrive1 DATE,
    note INT,
    textedescriptif VARCHAR(255),
    idclient INT,
    FOREIGN KEY (idclient) REFERENCES client(idclient)
);

INSERT INTO hotel VALUES
(1, 'Paris', 'France', 75001),
(2, 'Lyon', 'France', 69002);

INSERT INTO client VALUES
(1, '12 Rue de Paris', 'Paris', 75001, 'jean.dupont@email.fr', '0612345678', 'Jean Dupont'),
(2, '5 Avenue Victor Hugo', 'Lyon', 69002, 'marie.leroy@email.fr', '0623456789', 'Marie Leroy'),
(3, '8 Boulevard Saint-Michel', 'Marseille', 13005, 'paul.moreau@email.fr', '0634567890', 'Paul Moreau'),
(4, '27 Rue Nationale', 'Lille', 59800, 'lucie.martin@email.fr', '0645678901', 'Lucie Martin'),
(5, '3 Rue des Fleurs', 'Nice', 06000, 'emma.giraud@email.fr', '0656789012', 'Emma Giraud');

INSERT INTO prestation VALUES
(1, 15, 'Petit-déjeuner'),
(2, 30, 'Navette aéroport'),
(3, 0, 'Wi-Fi gratuit'),
(4, 50, 'Spa et bien-être'),
(5, 20, 'Parking sécurisé');

INSERT INTO typechambre VALUES
(1, 'Simple', 80),
(2, 'Double', 120);

INSERT INTO chambre VALUES
(1, 201, 2, 0, 1, 1),
(2, 502, 5, 1, 1, 2),
(3, 305, 3, 0, 2, 1),
(4, 410, 4, 0, 2, 2),
(5, 104, 1, 1, 2, 2),
(6, 202, 2, 0, 1, 1),
(7, 307, 3, 1, 1, 2),
(8, 101, 1, 0, 1, 1);

INSERT INTO reservation VALUES
(1, '2025-06-15', '2025-06-18', 1),
(2, '2025-07-01', '2025-07-05', 2),
(3, '2025-08-10', '2025-08-14', 3),
(4, '2025-09-05', '2025-09-07', 4),
(5, '2025-09-20', '2025-09-25', 5),
(7, '2025-11-12', '2025-11-14', 2),
(9, '2026-01-15', '2026-01-18', 4),
(10, '2026-02-01', '2026-02-05', 2);

INSERT INTO reservation_chambre VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(7, 6),
(9, 7),
(10, 8);

INSERT INTO evaluation VALUES
(1, '2025-06-15', 5, 'Excellent séjour, personnel très accueillant.', 1),
(2, '2025-07-01', 4, 'Chambre propre, bon rapport qualité/prix.', 2),
(3, '2025-08-10', 3, 'Séjour correct mais bruyant la nuit.', 3),
(4, '2025-09-05', 5, 'Service impeccable, je recommande.', 4),
(5, '2025-09-20', 4, 'Très bon petit-déjeuner, hôtel bien situé.', 5);

SELECT r.idreservation, c.nomcomplet, h.ville
FROM reservation r
JOIN client c ON r.idclient = c.idclient
JOIN reservation_chambre rc ON r.idreservation = rc.idreservation
JOIN chambre ch ON rc.id_chambre = ch.id_chambre
JOIN hotel h ON ch.idhotel = h.idhotel;

SELECT * FROM client WHERE ville = 'Paris';

SELECT c.nomcomplet, COUNT(r.idreservation) AS nb_reservations
FROM client c
LEFT JOIN reservation r ON c.idclient = r.idclient
GROUP BY c.nomcomplet;

SELECT tc.type, COUNT(c.id_chambre) AS nb_chambres
FROM typechambre tc
LEFT JOIN chambre c ON tc.idtype = c.idtype
GROUP BY tc.type;

SELECT * FROM chambre
WHERE id_chambre NOT IN (
    SELECT rc.id_chambre
    FROM reservation r
    JOIN reservation_chambre rc ON r.idreservation = rc.idreservation
    WHERE (r.datearrive <= @date_fin AND r.datedepart >= @date_debut)
);

