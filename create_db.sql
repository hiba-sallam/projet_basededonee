-- Suppression si elles existent
DROP TABLE IF EXISTS evaluation;
DROP TABLE IF EXISTS reservation;
DROP TABLE IF EXISTS chambre;
DROP TABLE IF EXISTS type_chambre;
DROP TABLE IF EXISTS prestation;
DROP TABLE IF EXISTS client;
DROP TABLE IF EXISTS hotel;

-- Table hôtel
CREATE TABLE hotel (
    id_hotel INTEGER PRIMARY KEY,
    ville TEXT,
    pays TEXT,
    code_postal INTEGER
);

-- Table client
CREATE TABLE client (
    id_client INTEGER PRIMARY KEY,
    adresse TEXT,
    ville TEXT,
    code_postal INTEGER,
    email TEXT,
    telephone TEXT,
    nom_complet TEXT
);

-- Table prestation
CREATE TABLE prestation (
    id_prestation INTEGER PRIMARY KEY,
    prix REAL,
    description TEXT
);

-- Table type_chambre
CREATE TABLE type_chambre (
    id_type_chambre INTEGER PRIMARY KEY,
    designation TEXT,
    prix_par_nuit REAL
);

-- Table chambre
CREATE TABLE chambre (
    id_chambre INTEGER PRIMARY KEY,
    numero_chambre INTEGER,
    etage INTEGER,
    est_occupe INTEGER,
    id_type_chambre INTEGER,
    id_hotel INTEGER,
    FOREIGN KEY (id_type_chambre) REFERENCES type_chambre(id_type_chambre),
    FOREIGN KEY (id_hotel) REFERENCES hotel(id_hotel)
);

-- Table reservation
CREATE TABLE reservation (
    id_reservation INTEGER PRIMARY KEY,
    date_debut TEXT,
    date_fin TEXT,
    id_client INTEGER,
    id_chambre INTEGER,
    FOREIGN KEY (id_client) REFERENCES client(id_client),
    FOREIGN KEY (id_chambre) REFERENCES chambre(id_chambre)
);

-- Table evaluation
CREATE TABLE evaluation (
    id_evaluation INTEGER PRIMARY KEY,
    date_evaluation TEXT,
    note INTEGER,
    commentaire TEXT,
    id_client INTEGER,
    FOREIGN KEY (id_client) REFERENCES client(id_client)
);
DROP TABLE IF EXISTS hotel;

CREATE TABLE hotel (
    id_hotel INTEGER PRIMARY KEY,
    ville TEXT,
    pays TEXT,
    code_postal INTEGER
);

INSERT INTO hotel VALUES
(1, 'Paris', 'France', 75001),
(2, 'Lyon', 'France', 69002);
hadxi li fih
-- Données d’exemple
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

INSERT INTO type_chambre VALUES
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
(1, '2025-06-15', '2025-06-18', 1, 1),
(2, '2025-07-01', '2025-07-05', 2, 2),
(3, '2025-08-10', '2025-08-14', 3, 3),
(4, '2025-09-05', '2025-09-07', 4, 4),
(5, '2025-09-20', '2025-09-25', 5, 5),
(7, '2025-11-12', '2025-11-14', 2, 6),
(9, '2026-01-15', '2026-01-18', 4, 7),
(10, '2026-02-01', '2026-02-05', 2, 8);

INSERT INTO evaluation VALUES
(1, '2025-06-15', 5, 'Excellent séjour, personnel très accueillant.', 1),
(2, '2025-07-01', 4, 'Chambre propre, bon rapport qualité/prix.', 2),
(3, '2025-08-10', 3, 'Séjour correct mais bruyant la nuit.', 3),
(4, '2025-09-05', 5, 'Service impeccable, je recommande.', 4),
(5, '2025-09-20', 4, 'Très bon petit-déjeuner, hôtel bien situé.', 5);
