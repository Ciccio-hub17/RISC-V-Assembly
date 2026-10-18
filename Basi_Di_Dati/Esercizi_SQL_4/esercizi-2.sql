/*EDITORE (CodE, NomeEditore, Indirizzo, Città)
PUBBLICAZIONE (CodP, Titolo, NomeAutore, CodE)
LIBRERIA (CodL, NomeLibreria, Indirizzo, Città)
VENDITA (CodP, CodL, Data, CopieVendute)

a) Trovare il nome delle librerie in cui non è stata venduta nessuna pubblicazione di editori
con sede a Torino.
b) Trovare il nome degli editori per cui almeno 10 pubblicazioni sono state vendute nel
2002 nelle librerie di Roma in più di 2.000 copie.*/

SELECT DISTINCT NomeLibreria
FROM LIBRERIA L
WHERE CodL NOT IN (SELECT V.CodL
                            FROM LIBRERIA L, PUBBLICAZIONE P, EDITORE E, VENDITA V
                            WHERE P.CodE = E.CodE AND P.CodP = V.CodP AND E.Città = "Torino")

SELECT NomeEditore
FROM EDITORE E, PUBLLICAZIONE P
WHERE E.CodE = P.CodE AND CodP IN (SELECT P.CodP
            FROM PUBBLICAZIONE P, VENDITA V, LIBRERIA L
            WHERE L.CodL = V.CodL AND P.CodP = V.CodP AND Città = "Roma" AND Data = "2002"
            GROUP BY P.CodP
            HAVING SUM (CopieVendute) > 2000)
GROUP BY NomeEditore
HAVING COUNT (*) >= 10

/*QUIZ (CodQuiz, Argomento, Punteggio)
STUDENTE (Matricola, Nome, Indirizzo, Città)
RISULTATO-TEST (Matricola, CodQuiz, RispostaCorretta)

a) Trovare il nome degli studenti che non hanno risposto correttamente a nessun quiz di
matematica.
b) Trovare il nome degli studenti di Torino che hanno conseguito il punteggio massimo
possibile nei quiz di matematica.*/

SELECT DISTINCT Nome
FROM STUDENTE S
WHERE Matricola NOT IN (SELECT Matricola
                        FROM STUDENTE S, QUIZ Q, RISULTATO-TEST R
                        WHERE S.Matricola = R.Matricola AND Q.CodQuiz = R.CodQuiz AND Argomento = "Matematica" AND RispostaCorretta = "SI")


SELECT DISTINCT Nome
FROM STUDENTE S
WHERE Citta = "Torino" AND Matricola NOT IN (SELECT Matricola
                                            FROM STUDENTE S, QUIZ Q, RISULTATO-TEST R
                                            WHERE S.Matricola = R.Matricola AND Q.CodQuiz = R.CodQuiz 
                                            AND Argomento = "Matematica" AND RispostaCorretta = "No")
AND Matricola IN (SELECT Matricola
                FROM QUIZ Q, RISULTATO-TEST R
                WHERE S.Matricola = R.Matricola AND Q.CodQuiz = R.CodQuiz 
                AND Argomento = "Matematica")

/*ORARIO (Sigla, ParteDa, Destinaz, OraPart, OraArr)
VOLI (Sigla, Matr, Data, PostiPren, PostiTot)

a) Trovare la sigla e l’ora di partenza dei voli in partenza da Milano per Napoli il 1
ottobre 1993, che dispongono ancora di posti liberi e la cui durata (differenza tra
l’ora di arrivo e l’ora di partenza) è inferiore alla durata media dei voli da Milano
a Napoli*/

SELECT Sigla, OraPart
FROM ORARIO O, VOLI V
WHERE O.Sigla = V.Sigla AND ParteDa = "Milano" AND Destinaz = "Napoli" AND Data = "01-10-1993" AND PostiPren < PostiTot
AND (OraArr - OraPart) < (SELECT AVG (OraArr - OraPart)
                            FROM ORARIO O
                            WHERE ParteDa = "Milano" AND Destinaz = "Napoli")

/*MECCANICO (MatrM, NomeM)
SA-RIPARARE (MatrM, TipoGuasto)
EFFETTUA-RIPARAZIONE (CodR, MatrM, Targa, Data, Durata, TipoGuasto)
a) Trovare il nome dei meccanici che hanno effettuato almeno una riparazione di
un guasto che non sapevano riparare.
b) Per le autovetture per cui sono state necessarie riparazioni effettuate da almeno
3 meccanici diversi nello stesso giorno, visualizzare la targa dell’autovettura, la
data delle riparazioni e i tipi di guasto che si sono verificati, ordinando il risultato
in ordine crescente di targa e decrescente di data.*/

SELECT DISTINCT NomeM
FROM MECCANICO M, EFFETTUA-RIPARAZIONE E
WHERE E.MatrM = M.MatrM AND E.TipoGuasto NOT IN (SELECT TipoGuasto
                                                FROM SA-RIPARARE S
                                                WHERE M.MatrM = S.MatrM)

SELECT Targa, Data, TipoGuasto
FROM EFFETTUA-RIPARAZIONE E
WHERE (Targa, Data) IN (SELECT Targa, Data
                        FROM EFFETTUA-RIPARAZIONE E
                        GROUP BY Targa, Data
                        HAVING COUNT (DISTINCT MatrM) >= 3)
ORDER BY Targa ASC, Data DESC

/*SALA_RIUNIONI(CodS, NumeroMaxPosti, Proiettore)
PRENOTAZIONE_SALA(CodS, Data, OraInizio, OraFine, CodDip)
DIPENDENTE(CodDip, Nome, Cognome, DataNascita, Città)

a) Visualizzare il codice e il numero massimo di posti delle sale dotate di proiettore
che sono state prenotate almeno 15 volte per riunioni che iniziano prima delle
ore 15:00, ma non sono mai state prenotate per riunioni che cominciano dopo le
ore 20:00.
b) Visualizzare per ogni sala il codice della sala, il numero massimo di posti e il
numero di prenotazioni considerando solo l’ultima data in cui la sala è stata
prenotata*/

SELECT CodS, NumeroMaxPosti
FROM SALA_RIUNIONI S
WHERE Proiettore = "Si" AND CodS IN (SELECT CodS
                                    FROM PRENOTAZIONE_SALA P
                                    WHERE OraInizio < "15:00"
                                    GROUP BY CodS
                                    HAVING COUNT (CodS) >= 15)
                        AND CodS NOT IN (SELECT CodS
                                        FROM PRENOTAZIONE_SALA P
                                        WHERE OraInizio > "20:00")

SELECT CodS, NumeroMaxPosti, COUNT (*) AS NumeroPrenotazioni
FROM PRENOTAZIONE_SALA P, SALA_RIUNIONI S
WHERE P.CodS = S.CodS AND Data = (SELECT MAX (Data)
                                    FROM PRENOTAZIONE_SALA S1
                                    WHERE S.CodS = S1.CodS)
GROUP BY CodS, NumeroMaxPosti


/*GUIDA (CodGuida, Nome, Cognome, Nazionalità)
TIPO-VISITA (CodTipoVisita, Monumento, Durata, Città)
GRUPPO (CodGR, NumeroPartecipanti, Lingua)
VISITA-GUIDATA-EFFETTUATA (CodGR, Data, OraI, CodTipoVisita, CodGuida)

a) Tra i monumenti per cui sono state effettuate almeno 10 visite guidate,
visualizzare il monumento che è stato visitato complessivamente dal maggior
numero di persone*/

/*GUIDA (CodGuida, Nome, Cognome, Nazionalità)
TIPO-VISITA (CodTipoVisita, Monumento, Durata, Città)
GRUPPO (CodGR, NumeroPartecipanti, Lingua)
VISITA-GUIDATA-EFFETTUATA (CodGR, Data, OraI, CodTipoVisita, CodGuida)

a) Tra i monumenti per cui sono state effettuate almeno 10 visite guidate,
visualizzare il monumento che è stato visitato complessivamente dal maggior
numero di persone*/

WITH visite AS (SELECT Monumento
                FROM TIPO-VISITA T, VISITA-GUIDATA-EFFETTAUTA V
                WHERE V.CodTipoVisita = T.CodTipoVisita
                GROUP BY Monumento
                HAVING COUNT (*) >= 10)
persone AS (SELECT v.Monumento, SUM (NumeroPartecipanti)
            FROM visite v, GRUPPO G, VISITA-GUIDATA-EFFETTUATA V
            WHERE v.CodTipoVisita = V.CodTipoVisita AND V.CodGR = G.CodGR
            GROUP BY v.Monumento
            )

SELECT Monumento
FROM persone
WHERE NumeroPartecipanti = (SELECT MAX (NumeroPartecipanti)
                            FROM persone)

/*RAGAZZO(CodFiscale, Nome, Cognome, DataNascita, CittàResidenza)
ATTIVITA’(CodAttività, NomeA, Descrizione, Categoria)
CAMPO-ESTIVO(CodCampo, NomeCampo, Città)
ISCRIZIONE-PER-ATTIVITA’-IN-CAMPO-ESTIVO(CodFiscale, CodAttività,
CodCampo, DataIscrizione)

b) Visualizzare il nome e cognome del ragazzo che ha partecipato al maggior
numero di campi estivi per l’attività della categoria «Tennis».*/

WITH Category AS (SELECT *
                    FROM RAGAZZO R, ATTIVITA A, ISCRIZIONE-PER-ATTIVITA-CAMPO-ESTIVO I
                    WHERE R.CodFiscale = I.CodFiscale AND I.CodAttività = A.CodAttività AND Categoria = "Tennis"),
Part AS (SELECT C.Nome, C.Cognome, COUNT (DISTINCT CodCampo) AS Campi
        FROM Category C
        GROUP BY C.Nome, C.Cognome)

SELECT Nome, Cognome
FROM Part P
WHERE Campi = (SELECT MAX (Campi)
                        FROM Part)

/*CLIENTE (Cod-Cli, Nome)
CONTO (Cod-Conto, saldo, agenzia, stato)
CONTO-CLIENTE (Cod-Conto, Cod-Cli)

a) Trovare tutte le agenzie che hanno almeno un cliente titolare da solo (senza
cointestatari) di un unico conto corrente (cliente a cui non è intestato nessun altro
conto corrente)*/

WITH solo AS (SELECT Cod-Cli
                FROM CONTO-CLIENTE C
                GROUP BY Cod-Cli
                HAVING COUNT (*) = 1)

noCoi AS (SELECT Cod-Conto
        FROM CONTO-CLIENTE C
        GROUP BY Cod-Conto
        HAVING COUNT (*) = 1)

SELECT agenzia
FROM CONTO C, solo s, noCoi n, CONTO-CLIENTE CC
WHERE s.Cod-Cli = CC.Cod-Cli AND n.Cod-Conto = CC.Cod-Conto AND C.Cod-Conto = CC.Cod-Conto

/*CONTRIBUENTE (CodFiscale, Nome, Via, Città)
DICHIARAZIONE (CodDichiarazione, Tipo, Reddito)
PRESENTA (CodFiscale, CodDichiarazione, Data)

b) Visualizzare codice, nome e media dei redditi dichiarati dal 1990 in poi per i
contribuenti tali che il massimo reddito da loro dichiarato dal 1990 in poi sia
superiore alla media dei redditi calcolata su tutte le dichiarazioni nel database.*/

WITH mediaTot AS (SELECT AVG (Reddito)
                FROM DICHIARAZIONE D)

SELECT CodFiscale, Nome, AVG (Reddito)
FROM contMAX C, PRESENTA P, DICHIARAZIONE D
WHERE C.CodFiscale = P.CodFiscale AND D.CodDichiarazione = P.CodDichiarazione AND Data > "31-12-1989"
GROUP BY CodFiscale, Nome
HAVING MAX(Reddito) > (SELECT * FROM mediaTot)

/*PERSONA(Nome, Sesso, Età)
GENITORE(Nome-Gen, Nome-Figlio)

a) Trovare il nome di tutte le persone con età inferiore a 10 anni che sono figli unici*/
/*Questa query non controlla i fratellastri*/

WITH Unici AS (SELECT Nome-Gen
                FROM PERSONA P, GENITORE G
                WHERE P.Nome = G.Nome-Figlio
                GROUP BY Nome-Gen
                HAVING COUNT (*) = 1)

SELECT Nome
FROM Unici U, PERSONA P, GENITORE G
WHERE U.Nome-Gen = G.Nome-Gen AND G.Nome-Figlio = P.Nome AND Età < 10

/*OFFICINA (OID, Nome, Indirizzo, Città)
VEICOLO (Targa, Modello, Marca, Categoria, Alimentazione, AnnoImmatricolazione,
CodFiscale)
CLIENTE (CodFiscale, Nome, Cognome, DataNascita, Indirizzo, Città)
REVISIONE (Targa, OID, Data, Costo)

Per le officine che hanno effettuato revisioni di almeno 200 veicoli diversi intestati a persone nate tra
il 1970 e il 1980, visualizzare il nome e l’indirizzo dell’officina che ha eseguito il maggior numero di
revisioni (considerando tutte le revisioni effettuate) tra le officine ubicate nella stessa città.
Visualizzare anche il costo totale delle revisioni effettuate dall’officina e il numero di modelli di
veicoli diversi revisionati*/

WITH revisioniDiv AS (SELECT OID
                        FROM REVISIONE R, CLIENTE C, VEICOLO V
                        WHERE V.Targa = R.Targa AND V.CodFiscale = C.CodFiscale AND Data >= "01-01-1970" AND Data <= "31-12-1980"
                        GROUP BY OID
                        HAVING COUNT (DISTINCT Targa) >= 200)

OfficineStat AS (SELECT OID, Città, Nome, Indirizzo, COUNT (*) AS tot, SUM (Costo) AS CostoTot, COUNT (DISTINCT Modello) AS NumeroModelli
                FROM OFFICINA O, VEICOLO V, REVISIONE R
                WHERE O.OID = R.OID AND V.Targa = R.Targa AND OID IN (SELECT OID
                                                                        FROM revisioniDiv)
                GROUP BY OID, Città, Nome, Indirizzo),
MaxCitta (SELECT Città, MAX (tot)
        FROM OfficineStat O
        GROUP BY Città)

SELECT Nome, Indirizzo, CostoTot, NumeroModelli
FROM OfficineStat O, MaxCitta M
WHERE tot = (SELECT MAX (tot)
                FROM OfficineStat)

/*TECNICO (Matricola, Nome, Cognome, DataNascita, Sesso, Tipo)
INTERVENTO (CodI, Nome, Descrizione, Costo_orario)
STRUTTURA (CodS, Indirizzo, Città, Provincia, Regione, Tipologia)
EFFETTUA_INTERVENTO (Matricola, CodI, Data, CodS, Durata)

Considerando solo le strutture situate nella provincia di Torino, visualizzare la data nel mese di
Marzo 2022 in cui è stato effettuato complessivamente il maggior numero di interventi nelle strutture
considerate.*/

WITH Tor AS (SELECT *
                FROM STRUTTURA S
                WHERE Provincia = "Torino"),
Interventi AS (SELECT Data, COUNT (*) AS NumeroInterventi
                FROM EFFETTUA-INTERVENTO E
                WHERE E.CodS IN (SELECT CodS FROM Tor) AND Data BETWEEN "01-03-2022" AND "31-03-2022"
                GROUP BY Data),

SELECT Data
FROM Interventi I
WHERE NumeroInterventi = (SELECT MAX (NumeroInterventi) FROM Interventi) 

/*LUOGO (CodL, Nome, Città, Regione, CapienzaMax)
EVENTO (CodE, Titolo, Tipo)
EDIZIONE (CodE, Data, CodL, NumeroPartecipanti)

Tra gli eventi per cui sono state organizzate edizioni in almeno 3 città diverse, visualizzare il titolo
dell’evento a cui ha complessivamente (considerando tutte le edizioni dell’evento) partecipato il
maggior numero di persone*/

WITH EventiBuoni AS (SELECT ED.CodE
                FROM EDIZIONE ED, LUOGO L
                WHERE ED.CodL = L.CodL
                GROUP BY CodE
                HAVING COUNT (DISTINCT Città) >= 3),

NumeroPersone AS (SELECT CodE, SUM (NumeroPartecipanti) AS N
                FROM EDIZIONE E
                WHERE CodE IN (SELECT CodE FROM EventiBuoni)
                GROUP BY CodE),

SELECT Titolo
FROM NumeroPersone N, EVENTO E
WHERE  E.CodE = N.CodE AND N.N = (SELECT MAX (N) FROM NumeroPersone)


/*FILM (CodF, Titolo, Data_uscita, Genere, DurataMinuti)
CINEMA (CodC, Nome, Indirizzo, Città)
SALA (CodC, NumeroSala, Capienza)
PROIEZIONE (CodC, NumeroSala, Data, OraInizio, OraFine, CodF)


Visualizzare il titolo di ciascun film che ha una durata inferiore della durata media dei film
appartenenti allo stesso genere, e che è stato proiettato un numero di volte maggiore del numero
medio di proiezioni dei film appartenenti allo stesso genere.*/

WITH DurataMediaPerGenere AS (SELECT Genere, AVG (DurataMinuti) AS DuarataMedia
                                FROM FILM F),
ContaProiezioneFilm (SELECT CodF, Titolo, Genere, DurataMinuti, COUNT (*) AS NumeroProFilm
                        FROM PROIEZIONE P, FILM F
                        WHERE F.CodF = P.CodF
                        GROUP BY CodF, Titolo, Genere, DurataMinuti),
ContaProiezionePerGenere AS (SELECT Genere, AVG (NumeroProFilm) AS NumeroProiezioni
                                FROM ContaProiezioneFilm
                                GROUP BY Genere)

SELECT 
FROM DurataMediaPerGenere D, ContaProiezioneFilm CF , ContaProiezionePerGenere CP
WHERE CF.Genere = D.Genere AND D.Genere = CP.Genere AND DurataMinuti < DurataMedia AND NumeroProFilm > NumeroProiezioni