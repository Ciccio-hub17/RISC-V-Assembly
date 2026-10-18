import streamlit as st
import sqlite3
import pandas as pd

st.title("Visualizzazione e Filtraggio Corsi")

conn = sqlite3.connect('palestra.db')

# Estrazione dati per le metriche 
totale_corsi = pd.read_sql("SELECT COUNT(*) FROM CORSO", conn).iloc[0, 0]
totale_tipi = pd.read_sql("SELECT COUNT(DISTINCT Tipo) FROM CORSO", conn).iloc[0, 0]

# Estrazione delle opzioni reali dal DB per popolare i widget 
tipi_disponibili = pd.read_sql("SELECT DISTINCT Tipo FROM CORSO", conn)['Tipo'].tolist()

# Visualizzazione metriche in colonne 
m1, m2 = st.columns(2)
with m1:
    st.metric(label="Corsi Disponibili", value=totale_corsi)
with m2:
    st.metric(label="Tipologie di Corso", value=totale_tipi)

st.write("---")

# Suddivisione in Tabs 
tab_filtri, tab_risultati = st.tabs(["Filtri di Selezione", "Dettagli Programmazione"])

with tab_filtri:
    # Selezione multipla per categorie 
    tipi_selezionati = st.multiselect("Seleziona i Tipi di corso:", options=tipi_disponibili)
    
    # Range di livello 
    livello_range = st.slider("Seleziona il range di livello:", min_value=1, max_value=4, value=(1, 4))

with tab_risultati:
    # Costruzione dinamica della query in base ai filtri selezionati
    if tipi_selezionati:
        # Genera i punti di domanda dinamici per la clausola IN dell'SQL
        placeholders = ",".join(["?"] * len(tipi_selezionati))
        query_corsi = f"""
            SELECT C.Nome as Corso, C.Tipo, C.Livello, P.Giorno, P.OrarioInizio, P.Sala, 
                   (I.Nome || ' ' || I.Cognome) as Istruttore, I.Email
            FROM CORSO C
            LEFT JOIN PROGRAMMA P ON C.CodC = P.CodC
            LEFT JOIN ISTRUTTORE I ON P.CodFisc = I.CodFisc
            WHERE C.Tipo IN ({placeholders}) AND C.Livello BETWEEN ? AND ?
        """
        params = list(tipi_selezionati) + [livello_range[0], livello_range[1]]
    else:
        # Se non è selezionato nessun tipo specifico, mostra tutti filtrando solo per livello
        query_corsi = """
            SELECT C.Nome as Corso, C.Tipo, C.Livello, P.Giorno, P.OrarioInizio, P.Sala, 
                   (I.Nome || ' ' || I.Cognome) as Istruttore, I.Email
            FROM CORSO C
            LEFT JOIN PROGRAMMA P ON C.CodC = P.CodC
            LEFT JOIN ISTRUTTORE I ON P.CodFisc = I.CodFisc
            WHERE C.Livello BETWEEN ? AND ?
        """
        params = [livello_range[0], livello_range[1]]

    df_corsi = pd.read_sql(query_corsi, conn, params=params)

    # Controllo risultati vuoti
    if df_corsi.empty:
        st.warning("Nessun risultato trovato per i filtri impostati.", icon="⚠️")
    else:
        st.markdown("### Elenco Corsi Trovati")
        st.dataframe(df_corsi[['Corso', 'Tipo', 'Livello']]) # Tabella principale interattiva

        # Expander separato per i dettagli di lezioni e istruttori 
        with st.expander("Visualizza Programmi Lezioni e Istruttori", expanded=False):
            # Print dei risultati richiesti
            st.dataframe(df_corsi[['Corso', 'Giorno', 'OrarioInizio', 'Sala', 'Istruttore', 'Email']])

conn.close()