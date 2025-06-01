import sqlite3

conn = sqlite3.connect('hotel_db.sqlite')

with open('create_db.sql', 'r', encoding='utf-8') as f:
    sql = f.read()

conn.executescript(sql)
conn.close()
print("Base de données créée avec succès.")
