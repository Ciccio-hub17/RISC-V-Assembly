import streamlit as st
import pandas as pd
import sqlite3

st.title("Pianificazione Lezioni Settimanali")

conn = sqlite3.connect('palestra.db')

# Estrazione dinamica delle chiavi esterne per i menu a tendina
lista_istruttori = pd.read_sql("SELECT CodFisc FROM ISTRUTTORE", conn)['CodFisc'].tolist()
lista_corsi = pd.read_sql("SELECT CodC FROM CORSO", conn)['CodC'].tolist()

with st.form(key="form_programma", clear_on_submit=True):
    st.subheader("Assegnazione Spazio Orario")
    
    # Menu a tendina popolati dal DB 
    cod_fisc = st.selectbox("Seleziona il Codice Fiscale dell'Istruttore:", options=lista_istruttori)
    cod_c = st.selectbox("Seleziona il Codice del Corso:", options=lista_corsi)
    
    giorno = st.selectbox("Seleziona il Giorno:", options=["Lunedì", "Martedì", "Mercoledì", "Giovedì", "Venerdì", "Sabato", "Domenica"])
    
    # Slider per la selezione manuale di orario e durata 
    ora_inizio = st.slider("Ora Inizio Lezione (Formato ore intere):", min_value=7, max_value=22, value=18)
    durata = st.slider("Durata della lezione (in minuti):", min_value=15, max_value=90, value=45, step=5)
    
    sala = st.text_input("Assegna la Sala:")
    
    submit_programma = st.form_submit_button(label="Aggiungi al Programma")

if submit_programma:
    # Trasformiamo l'orario intero in stringa standard per l'inserimento nel database 
    stringa_orario = f"{ora_inizio:02d}:00"
    
    # MAX 60 MIN
    if durata > 60:
        st.error("Errore di convalida: Non è possibile inserire nel programma lezioni che durino più di 60 minuti.")
    
    # NO WEEKEND
    elif giorno in ["Sabato", "Domenica"]:
        st.error("Errore di convalida: Il giorno indicato deve essere compreso esclusivamente tra Lunedì e Venerdì.")
    
    elif not sala:
        st.error("Errore di convalida: Il campo 'Sala' non può essere lasciato vuoto.")
        
    else:
        # SOVRAPPOSIZIONE DATA
        # Interrogazione preventiva 
        query_check = "SELECT COUNT(*) FROM PROGRAMMA WHERE CodC = ? AND Giorno = ?"
        conteggio_conflitti = pd.read_sql(query_check, conn, params=[cod_c, giorno]).iloc[0, 0]
        
        if conteggio_conflitti > 0:
            st.error("Errore di Conflitto: Operazione negata! Sono già presenti in programma altre lezioni per lo stesso corso nello stesso giorno della settimana.")
        else:
            # Se tutti i vincoli sono rispettati, procediamo all'effettivo inserimento
            try:
                cursor = conn.cursor()
                cursor.execute(
                    "INSERT INTO PROGRAMMA (CodFisc, Giorno, OrarioInizio, Durata, CodC, Sala) VALUES (?, ?, ?, ?, ?, ?)",
                    (cod_fisc, giorno, stringa_orario, int(durata), cod_c, sala)
                )
                conn.commit()
                st.success("Lezione registrata ed eseguita correttamente all'interno del programma!", icon="✅")
            except Exception as e:
                # Riporta il tipo esatto di problema riscontrato
                st.error(f"Errore di inserimento nel Database: {str(e)}")

conn.close()