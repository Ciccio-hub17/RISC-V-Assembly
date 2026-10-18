import streamlit as st
import sqlite3
import pandas as pd


st.set_page_config(page_title="Homepage Palestra", layout="wide")


st.markdown("# :red[Homework su Streamlit]")
st.markdown("## Obiettivo: Monitoraggio e Gestione del Database Palestra")
st.markdown("**Studente:** Francesco Rosa")

st.write("---") 

st.subheader("Statistiche delle Lezioni in Programma")

# Connessione al database
conn = sqlite3.connect('palestra.db')

#Query Area Chart
query_area = """
    SELECT OrarioInizio, COUNT(*) as NumeroLezioni 
    FROM PROGRAMMA 
    GROUP BY OrarioInizio
"""
df_area = pd.read_sql(query_area, conn).set_index('OrarioInizio')

#Query Bar Chart
query_bar = """
    SELECT Giorno, COUNT(*) as NumeroLezioni 
    FROM PROGRAMMA 
    GROUP BY Giorno
"""
df_bar = pd.read_sql(query_bar, conn).set_index('Giorno')

conn.close()

# Creazione del layout a 2 colonne affiancate 
col1, col2 = st.columns(2)

with col1:
    st.markdown("### :blue[Lezioni per Slot Orario]")
    st.area_chart(df_area) # Area Chart 

with col2:
    st.markdown("### :blue[Lezioni per Giorno della Settimana]")
    st.bar_chart(df_bar) # Bar Chart 