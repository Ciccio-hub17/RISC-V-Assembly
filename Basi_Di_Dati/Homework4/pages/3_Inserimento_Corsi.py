import streamlit as st
import sqlite3

st.title("Aggiungi un Nuovo Corso")

# Creazione del form strutturato
with st.form(key="form_corso", clear_on_submit=False):
    st.subheader("Modulo inserimento dati")
    
    cod_c = st.text_input("Codice Corso (Deve iniziare con 'CT'):")
    nome = st.text_input("Nome del Corso:")
    tipo = st.text_input("Categoria/Tipo:")
    
    # Controllo livello intero 1-4 tramite widget
    livello = st.number_input("Livello di difficoltà (da 1 a 4):", min_value=1, max_value=4, value=1, step=1)
    
    submit_button = st.form_submit_button(label="Registra Corso")

# Logica di verifica al momento del submit
if submit_button:
    # Verifica che tutti i campi siano valorizzati
    if not cod_c or not nome or not tipo:
        st.error("Tutti i campi sono obbligatori! Compila l'intero modulo.")
    # Verifica che il codice inizi per "CT"
    elif not cod_c.upper().startswith("CT"):
        st.error("Struttura codice errata! L'attributo CodC deve iniziare tassativamente con 'CT'.")
    else:
        # Tentativo di inserimento nel database reale
        try:
            conn = sqlite3.connect('palestra.db')
            cursor = conn.cursor()
            
            cursor.execute(
                "INSERT INTO CORSO (CodC, Nome, Tipo, Livello) VALUES (?, ?, ?, ?)",
                (cod_c.upper(), nome, tipo, int(livello))
            )
            conn.commit()
            conn.close()
            
            st.success("Operazione andata a buon fine! Il corso è stato inserito.", icon="✅")
            
        except sqlite3.IntegrityError:
            st.error("Errore di inserimento: Rilevata una chiave duplicata! Il codice corso inserito esiste già.")