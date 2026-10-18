import sqlite3
#file che mi è servito per crera eun db di esempio
def inizializza_db():
    # Crea una connessione al database (crea il file palestra.db se non esiste)
    conn = sqlite3.connect('palestra.db')
    cursor = conn.cursor()

    #Creazione Tabella CORSO
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS CORSO (
            CodC TEXT PRIMARY KEY,
            Nome TEXT NOT NULL,
            Tipo TEXT NOT NULL,
            Livello INTEGER CHECK(Livello >= 1 AND Livello <= 4)
        )
    ''')

    # Creazione Tabella ISTRUTTORE
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS ISTRUTTORE (
            CodFisc TEXT PRIMARY KEY,
            Nome TEXT NOT NULL,
            Cognome TEXT NOT NULL,
            DataNascita DATE,
            Email TEXT
        )
    ''')

    # Creazione Tabella PROGRAMMA
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS PROGRAMMA (
            CodFisc TEXT,
            Giorno TEXT,
            OrarioInizio TEXT,
            Durata INTEGER CHECK(Durata <= 60),
            CodC TEXT,
            Sala TEXT,
            PRIMARY KEY (CodC, Giorno),
            FOREIGN KEY (CodFisc) REFERENCES ISTRUTTORE(CodFisc),
            FOREIGN KEY (CodC) REFERENCES CORSO(CodC)
        )
    ''')
    
    #Qui inserisco alcuni dati per popolare un po il db
    cursor.executemany('''INSERT OR IGNORE INTO CORSO VALUES (?, ?, ?, ?)''', [
        ('CT01', 'Forza Base', 'Forza', 1),
        ('CT02', 'Cardio Extreme', 'Cardio', 4),
        ('CT03', 'Pilates Posturale', 'Posturale', 2)
    ])

    
    cursor.executemany('''INSERT OR IGNORE INTO ISTRUTTORE VALUES (?, ?, ?, ?, ?)''', [
        ('RSSMRA80A01H501U', 'Mario', 'Rossi', '1980-01-01', 'mario.rossi@email.com'),
        ('VRDLCU90B12F205Z', 'Luca', 'Verdi', '1990-02-12', 'luca.verdi@email.com'),
        ('BNCGLA85C45D332Y', 'Giulia', 'Bianchi', '1985-03-15', 'giulia.bianchi@email.com')
    ])

    
    cursor.executemany('''INSERT OR IGNORE INTO PROGRAMMA VALUES (?, ?, ?, ?, ?, ?)''', [
        ('RSSMRA80A01H501U', 'Lunedì', '18:00', 45, 'CT01', 'Sala Pesi'),
        ('VRDLCU90B12F205Z', 'Martedì', '10:00', 60, 'CT02', 'Sala Cardio'),
        ('BNCGLA85C45D332Y', 'Mercoledì', '19:00', 50, 'CT03', 'Sala Zen')
    ])

    conn.commit()
    conn.close()
    print("Database 'palestra.db' creato e popolato con successo!")

if __name__ == '__main__':
    inizializza_db()