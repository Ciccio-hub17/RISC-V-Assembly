import streamlit as st
import sqlite3
import datetime
import pandas as pd

st.title("Ricerca Istruttori")

# Widget di input 
cognome_filtro = st.text_input("Digita il cognome dell'istruttore:", placeholder="Es. Rossi")

data_range = st.date_input(
    "Seleziona l'intervallo per la data di nascita:",
    value=(datetime.date(1960, 1, 1), datetime.date(2005, 1, 1))
)

st.write("---")

if len(data_range) == 2:
    start_date, end_date = data_range
    
    conn = sqlite3.connect('palestra.db')
    
    # Query con passaggio delle date convertite in stringa 
    query_istruttori = """
        SELECT Nome, Cognome, DataNascita, Email 
        FROM ISTRUTTORE 
        WHERE Cognome LIKE ? AND DataNascita BETWEEN ? AND ?
    """
    df_istruttori = pd.read_sql(query_istruttori, conn, params=[f"%{cognome_filtro}%", str(start_date), str(end_date)])
    conn.close()

    if df_istruttori.empty:
        st.info("Nessun istruttore trovato con i criteri inseriti.", icon="ℹ️")
    else:
        st.subheader("Profili Istruttori:")
        
        # Stampa iterativa riga per riga tramite iterrows 
        for index, row in df_istruttori.iterrows():
            # Utilizzo delle colonne per affiancare l'icona al testo 
            col_icona, col_testo = st.columns([1, 15])
            with col_icona:
                st.write("👤") # Icona associata al risultato
            with col_testo:
                st.markdown(f"**{row['Nome']} {row['Cognome']}**")
                st.text(f"Data di Nascita: {row['DataNascita']} | Email: {row['Email']}")
            st.write("---")
else:
    st.info("Seleziona entrambe le date sul calendario per avviare la ricerca.")