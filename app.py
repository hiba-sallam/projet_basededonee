import streamlit as st
import sqlite3

# Connexion à la base de données
conn = sqlite3.connect('hotel_db.sqlite')
c = conn.cursor()

# Titre de l'application
st.title("Gestion des Réservations d'Hôtel")

# Menu
option = st.sidebar.selectbox("Choisir une action", ["Consulter Réservations", "Consulter Clients", 
                                                    "Consulter Chambres Disponibles", "Ajouter Client", 
                                                    "Ajouter Réservation"])

# 1. Consulter la liste des réservations
if option == "Consulter Réservations":
    st.subheader("Liste des Réservations")
    c.execute("SELECT r.id_reservation, c.nom, h.ville FROM Reservation r JOIN Client c ON r.id_client = c.id_client JOIN Hotel h ON h.id_hotel = (SELECT id_hotel FROM Chambre LIMIT 1)")
    reservations = c.fetchall()
    for res in reservations:
        st.write(f"ID: {res[0]}, Client: {res[1]}, Ville Hôtel: {res[2]}")

# 2. Consulter la liste des clients
elif option == "Consulter Clients":
    st.subheader("Liste des Clients")
    c.execute("SELECT id_client, nom, email FROM Client")
    clients = c.fetchall()
    for client in clients:
        st.write(f"ID: {client[0]}, Nom: {client[1]}, Email: {client[2]}")

# 3. Consulter les chambres disponibles
elif option == "Consulter Chambres Disponibles":
    st.subheader("Chambres Disponibles")
    date_debut = st.date_input("Date de début", value=None)
    date_fin = st.date_input("Date de fin", value=None)
    if date_debut and date_fin:
        c.execute("""
            SELECT c.id_chambre, c.numero_chambre, tc.type_chambre, h.ville 
            FROM Chambre c
            JOIN Type_Chambre tc ON c.id_type = tc.id_type
            JOIN Hotel h ON c.id_hotel = h.id_hotel
            WHERE c.id_chambre NOT IN (
                SELECT id_reservation 
                FROM Reservation r
                WHERE NOT (r.date_fin <= ? OR r.date_debut >= ?)
            ) AND c.occupe = 0
        """, (date_debut, date_fin))
        chambres = c.fetchall()
        if chambres:
            for chambre in chambres:
                st.write(f"ID: {chambre[0]}, Numéro: {chambre[1]}, Type: {chambre[2]}, Ville: {chambre[3]}")
        else:
            st.write("Aucune chambre disponible pour cette période.")

# 4. Ajouter un client
elif option == "Ajouter Client":
    st.subheader("Ajouter un Client")
    with st.form(key='client_form'):
        nom = st.text_input("Nom")
        email = st.text_input("Email")
        telephone = st.text_input("Téléphone")
        adresse = st.text_input("Adresse")
        ville = st.text_input("Ville")
        code_postal = st.number_input("Code postal", min_value=0)
        submit = st.form_submit_button("Ajouter")
        if submit:
            # Trouver le prochain ID client
            c.execute("SELECT MAX(id_client) FROM Client")
            max_id = c.fetchone()[0]
            new_id = (max_id + 1) if max_id else 1
            c.execute("INSERT INTO Client (id_client, nom, email, telephone, adresse, ville, code_postal) VALUES (?, ?, ?, ?, ?, ?, ?)",
                      (new_id, nom, email, telephone, adresse, ville, code_postal))
            conn.commit()
            st.success("Client ajouté avec succès !")

# 5. Ajouter une réservation
elif option == "Ajouter Réservation":
    st.subheader("Ajouter une Réservation")
    with st.form(key='reservation_form'):
        id_client = st.number_input("ID Client", min_value=1)
        date_debut = st.date_input("Date de début")
        date_fin = st.date_input("Date de fin")
        submit = st.form_submit_button("Ajouter")
        if submit:
            # Trouver le prochain ID réservation
            c.execute("SELECT MAX(id_reservation) FROM Reservation")
            max_id = c.fetchone()[0]
            new_id = (max_id + 1) if max_id else 1
            c.execute("INSERT INTO Reservation (id_reservation, id_client, date_debut, date_fin) VALUES (?, ?, ?, ?)",
                      (new_id, id_client, date_debut, date_fin))
            conn.commit()
            st.success("Réservation ajoutée avec succès !")

# Fermer la connexion
conn.close()