/*EVENTO(CodE, NomeEvento, CategoriaEvento, CostoEvento, DurataEvento)
CALENDARIO_EVENTI(CodE, Data, OraInizio, Luogo)
SOMMARIO_CATEGORIA(CategoriaEvento, Data, NumeroTotaleEventi, CostoComplessivoEventi)

Si vuole gestire la pianificazione degli eventi nella città di Torino per l’anniversario dei 150 anni
dell’unità d’Italia (Italia 150).
Gli eventi appartengono a diverse categorie (attributo CategoriaEvento), quali mostre, dibattiti,
proiezioni, e sono caratterizzati da un costo di realizzazione (attributo CostoEvento). Ciascun evento può
essere ripetuto più volte in date diverse. La tabella CALENDARIO_EVENTI riporta la pianificazione
degli eventi in diversi giorni e luoghi della città. Si scrivano i trigger per gestire le seguenti attività.

(1) Aggiornamento della tabella SOMMARIO_CATEGORIA. La tabella SOMMARIO_CATEGORIA
riporta, per ogni categoria di evento e per ogni data, il numero complessivo di eventi previsti e il costo
complessivo per la loro realizzazione.
Si scriva il trigger per propagare le modifiche alla tabella SOMMARIO_CATEGORIA quando viene
inserito un nuovo evento a calendario (inserimento nella tabella CALENDARIO_EVENTI).

(2) Vincolo di integrità sul costo massimo dell’evento. Il costo di un evento della categoria proiezione
cinematografica (attributo CategoriaEvento) non può essere superiore a 1500 euro. Se un valore di costo
superiore a 1500 è inserito nella tabella EVENTO, all’attributo CostoEvento deve essere assegnato il
valore 1500. Si scriva il trigger per la gestione del vincolo di integrità.

(3) Vincolo sul numero massimo di eventi per data. In ogni data non possono essere pianificati più di 10
eventi. Ogni modifica della tabella CALANDARIO_EVENTI che causa la violazione del vincolo non
deve essere eseguita.*/

/*

EVENTO INNESCANTE: INSERT ON CALENDARIO_EVENTI

TABELLA MUTANTE (TARGET): CALENDARI_EVENTI
CONDIZIONE 
AZIONI:
    -LEGGO DA TABELLA EVENTO LA CATEGORIA (E ANCHE IL COSTO) PER L'EVENTO PIANIFICATO O INSERITO A CALENDARIO
    -VERIRICARE SE IN SOMMARIO CATEGORIA è GIA PRESENTE UN RECORD DELLO STESSO TIPO (STESSA CHIAVE PRIMARIA)
        ^SE SI: AGGIORNARE IL RECORD: NUMEROTOT += 1 E COSTO =  COSTOPREC. + COSTO
        ^SE NO: INIZIALIZZARE IL RECORD

GRANULARITA': TUPLA 
MODO ESECUZIONE: AFTER

*/

CREATE  OR REPLACE TRIGGER aggiorna_sommario_categoria
AFTER INSERT ON CALENDARIO_EVENTI
FOR EACH ROW 
DECLARE
    X CHAR (10);
    Y NUMBER;
    Z NUMBER;

BEGIN
    SELECT CategoriaEvento, CostoEvento INTO X, Y
    FROM EVENTO
    WHERE CodE = :NEW.CodE;

    SELECT COUNT (*) INTO Z
    FROM SOMMARIO_CATEGORIA
    WHERE CategoriaEvento = X AND Data = :NEW.Data;

    IF (Z <> 0) THEN
        UPDATE SOMMARIO_CATEGORIA
        SET NumeroTotaleEventi = NumeroTotaleEventi + 1, 
        CostoComplessivoEventi = CostoComplessivoEventi + Y
        WHERE CategoriaEvento = X AND Data = :NEW.Data;
    ELSE
        INSERT INTO SOMMARIO_CATEGORIA (CategoriaEvento, Data, NumeroTotaleEventi, CostoComplessivoEventi)
        VALUES (X, :New.Data, 1, Y);
    END IF
END

/*(2) Vincolo di integrità sul costo massimo dell’evento. Il costo di un evento della categoria proiezione
cinematografica (attributo CategoriaEvento) non può essere superiore a 1500 euro. Se un valore di costo
superiore a 1500 è inserito nella tabella EVENTO, all’attributo CostoEvento deve essere assegnato il
valore 1500. Si scriva il trigger per la gestione del vincolo di integrità.*/

CREATE OR REPLACE TRIGGER massimo_evento
BEFORE INSERT OR UPDATE OF CostoEvento, CategoriaEvento ON EVENTO
FOR EACH ROW
WHEN (:NEW.CategoriaEvento = 'Proiezione') AND (NEW.CostoEvento > 1500)
    X CHAR (10);
    Y NUMBER;
BEGIN
    :NEW.CostoEvento := 1500;
END

/*(3) Vincolo sul numero massimo di eventi per data. In ogni data non possono essere pianificati più di 10
eventi. Ogni modifica della tabella CALANDARIO_EVENTI che causa la violazione del vincolo non
deve essere eseguita.*/

CREATE OR REPLACE TRIGGER verifica_numero_eventi
AFTER INSERT OR UPDATE OF Data ON CALENDARIO_EVENTI
DECLARE
    X NUMBER;

BEGIN

    SELECT COUNT (*) INTO X
    FROM CALENDARIO_EVENTI
    WHERE Data IN (SELECT Data
        FROM CALENDARIO_EVENTI
        GROUP BY Data
        HAVING COUNT (*) > 10;)
    
    IF (X <> 0) THEN
        raise_application_error (TTT, 'Troppi eventi in almeno una data');
    END IF
END

CREATE OR REPLACE TRIGGER gestisci_ferie
AFTER INSERT ON RICHIESTA-FERIE
FOR EACH ROW
DECLARE
    X NUMBER;
    Y NUMBER;
BEGIN
    SELECT COUNT (*) INTO X
    FROM TURNO
    WHERE TURNO.Matricola = :NEW.Matricola AND TURNO.Data = :NEW.Data

    IF (X = 0) THEN
        INSERT INTO NOTIFICA (Matricola, Data, EsitoRichiesta)
        VALUES (:NEW.MATRICOLA, :NEW.Data, 'accettata');

    ELSE

        WITH tab AS (SELECT Matricola
        FROM PERSONA, TURNO
        WHERE PERSONA.Matricola = TURNO.Matricola AND P.Mansione = (SELECT Mansione
                            FROM PERSONA P
                            WHERE P.Matricola = :NEW.Matricola;)
        AND TURNO.Data NOT IN (SELECT Data FROM TURNO WHERE Data = :NEW.Data))

        SELECT COUNT (*) INTO Y
        FROM tab

        IF (Y = 0) THEN 
            INSERT INTO NOTIFICA (Matricola, Data, EsitoRichiesta)
            VALUES (:NEW.MATRICOLA, :NEW.Data, 'rifiutata');
        ELSE
            INSERT INTO NOTIFICA (Matricola, Data, EsitoRichiesta)
            VALUES (:NEW.MATRICOLA, :NEW.Data, 'accettata');
        END IF
    END IF
END

/*Inserimento di uno studente in graduatoria. Lo studente presenta la
domanda per l'assegnazione di borse di studio. La domanda viene
accettata se lo studente non è già presente in graduatoria (tabella
GRADUATORIA) ed ha acquisito almeno 120 crediti sugli esami superati. Se
almeno uno dei requisiti non è soddisfatto, la domanda viene annullata.
Altrimenti si deve aggiornare la graduatoria, assegnando allo studente un
punteggio dato dal prodotto della media dei voti per gli esami superati
(votazione maggiore o uguale a 18), per il numero di anni di iscrizione
dello studente al corso di laurea (si assuma che l'anno corrente sia fornito
dalla variabile SYSDATE).*/

CREATE OR REPLACE TRIGGER graduatoria_studenti
AFTER INSERT ON DOMANDA_INSERIMETO_GRADUATORIA
FOR EACH ROW
DECLARE
    NC NUMBER;
    NE NUMBER;
    M NUMBER;
    N NUMBER;
    A NUMBER;
BEGIN
    SELECT SUM (NumeroCrediti) , AVG (VOTO) INTO NC, M
    FROM CORSO, ESAMI_SOSTENUTI
    WHERE ESAMI_SOSTENUTI.CodCorso = CORSO.CodCorso 
    AND ESAMI_SOSTENUTI.Matricola = :NEW.Matricola 
    AND Voto >= 18;

    SELECT COUNT (*) INTO N
    FROM GRADUATORIA_STUDENTI
    WHERE :NEW.Matricola = GRADUATORIA_STUDENTI.Matricola;

    SELECT AnnoImmatricolazione INTO A
    FROM STUDENTE
    WHERE :NEW.Matricola = SUDENTE.Matricola

    IF (N = 0) AND (NC > 120) THEN
        INSERT INTO GRADUATORIA_STUDENTI (Matricola, Punteggio)
        VALUES (:NEW.Matricola, M*(SYSDATE-A))
    ELSE
        raise_application_error (TTT, "Domanda annullata");
    END IF


END


/*Assegnazione di una borsa di studio per un corso. Quando viene offerta una borsa
di studio per un corso, si seleziona dalla graduatoria lo studente a cui assegnare la
borsa. Viene selezionato lo studente con punteggio più alto tra gli studenti che
soddisfano i seguenti requisiti: lo studente ha superato l'esame per il corso per cui
è offerta la borsa di studio, e lo studente complessivamente non svolge più di 150
ore sulle borse di studio assegnate. Si assuma che ci sia sempre al più un solo
studente che soddisfi tutti i requisiti. Occorre notificare l'esito dell'operazione, sia
che la borsa di studio sia stata assegnata, sia che non sia possibile assegnare la
borsa (in questo caso, la matricola sarà NULL). L'attributo CodN è un contatore che
viene incrementato ogni volta che viene inserita una nuova notifica. Se la borsa di
studio è assegnata, si deve aggiornare la tabella BORSE_STUDIO_ASSEGNATE.*/

CREATE OR REPLACE TRIGGER assegnazione
AFTER INSERT ON OFFERTA_BORSA_STUDIO
FOR EACH ROW
DECLARE
    N NUMBER;
    B NUMBER;
    CodNN NUMBER;

BEGIN
    SELECT MAX (Punteggio) INTO N
    FROM GRADUATORIA_STUDENTI
    WHERE Matricola IN (SELECT Matricola FROM ESAMI_SOSTENUTI WHERE Voto >= 18 AND:NEW.CodCorso = GRADUATORIA_STUDENTI.CodCorso)
    AND Matricola NOT IN (SELECT Matricola FROM BORSE_STUDIO_ASSEGNATE GROUP BY Matricola HAVING SUM (NumeroOre) + :NEW.NumeroOre > 150);

    IF (N IS NOT NULL) THEN 

        SELECT Matricola INTO B
        FROM GRADUATORIA_STUDENTI
        WHERE Matricola IN (SELECT Matricola FROM ESAMI_SOSTENUTI WHERE Voto >= 18 AND:NEW.CodCorso = GRADUATORIA_STUDENTI.CodCorso)
        AND Matricola NOT IN (SELECT Matricola FROM BORSE_STUDIO_ASSEGNATE GROUP BY Matricola HAVING SUM (NumeroOre) + :NEW.NumeroOre > 150)
        AND Punteggio = N;

        IF (CodNN IS NULL) THEN CodNN = 0
        ELSE CodNN = CodNN + 1
        END IF

        INSERT INTO BORSE_STUDIO_ASSEGNATE  (CodBorsa, Matricola, NumeroOre)
        VALUES (:NEW.CodBorsa, B, :NEW.NumeroOre);

        INSERT INTO NOTIFICA_INFORMAZIONI (CodN, CodBorsa, Matricola*, Messaggio)
        VALUES (CodNN, :NEW.CodBorsa, B, "Borsa assegnata");

        SELECT MAX (CodN) INTO CodNN
        FROM NOTIFICA_INFORMAZIONI;

        

    ELSE
        INSERT INTO NOTIFICA_INFORMAZIONI (CodN, CodBorsa, Matricola*, Messaggio)
        VALUES (CodNN, :NEW.CodBorsa, NULL, "Borsa NON assegnata");
    END IF

END


/*Si scriva il trigger per la verifica di correttezza e eventuale correzione
del seguente vincolo. Per ciascuna borsa di studio offerta, il numero di
ore previsto deve essere pari ad almeno 15 ore. Se viene offerta una
borsa di studio con un numero di ore inferiore a 15, il valore deve
essere assegnato a 15*/

CREATE OR REPLACE TRIGGER correzione_borsa
BEFORE INSERT OR UPDATE of NumeroOre ON OFFERTA_BORSA_STUDIO
FOR EACH ROW
DECLARE

BEGIN
    IF (:NEW.NumeroOre < 15) THEN 
        :new.NumeroOre := 15
    END IF

END

CREATE OR REPLACE TRIGGER ore_borse
AFTER INSERT OR UPDATE of NumeroOre ON OFFERTA_BORSA_STUDIO
FOR EACH ROW
DECLARE
    X NUMBER;

BEGIN
    SELECT NVL(SUM (NumeroOre), 0) INTO X
    FROM OFFERTA_BORSA_STUDIO
    WHERE OFFERTA_BORSA_STUDIO.CodCorso = :NEW.CodCorso 

    IF (X > 300) THEN 
    raise_application_error (TTT, "Troppe Ore");
    END IF
END


/*PAZIENTE (CodP, NomeP, CognomeP, DataNascita)

MEDICO (CodM, NomeM, CognomeM, Specializzazione)

LABORATORIO (CodL, NomeL, Piano, Città)

ESAME (CodE, NomeEsame, Categoria)

ESECUZIONE (CodP, DataEsecuzione, CodE, CodM, CodL, DataReferto, Valore*)


Per ciascun laboratorio visualizzare il nome e, per ciascun esame di categoria "ematologica" 
effettuato nel laboratorio nell’anno 2025, visualizzare il nome dell’esame e il numero medio 
di giorni necessari per la produzione del referto (definito come differenza tra DataEsecuzione 
e DataReferto). Si considerino solo i laboratori che nel 2025 ha complessivamente eseguito più 
di 100 esami di categoria " ematologica" ad almeno 50 pazienti diversi.*/


SELECT NomeL, NomeEsame, AVG (DataReferto-DataEsecuzione)
FROM LABORATORIO L, ESAME E, ESECUZIONE ES
WHERE E.CodE = ES.CodE AND ES.CodL = L.CodL
    AND E.Categoria = 'ematologica' AND YEAR(DataEsecuzione) = 2025 
    AND L.CodL IN (SELECT CodL 
                FROM ESAME E1, ESECUZIONE ES1
                WHERE E1.CodE = ES1.CodE
                AND YEAR(DataEsecuzione) = 2025 AND E1.Categoria = 'ematologica'
                GROUP BY CodL
                HAVING COUNT (DISTINCT CodP) >= 50 AND COUNT (*) > 100)
GROUP BY NomeL, NomeEsame, L.CodL

/*Per ciascun esame, visualizzare il nome, la categoria, il numero di volte in cui è stato 
effettuato ed il tempo medio di attesa del referto. Si considerino solo gli esami effettuati 
nei laboratori di Torino per cui il tempo medio di attesa del referto (definita come la 
differenza tra DataReferto e DataPrescrizione) è maggiore del tempo medio di attesa del 
referto per gli esami della stessa categoria.*/

WITH TMEDIOTOT AS (SELECT Categoria, AVG (DataReferto-DataEsecuzione) AS N
                    FROM ESAME E, ESECUZIONE ES
                    WHERE E.CodE = ES.CodE
                    GROUP BY Categoria)

SELECT NomeEsame, Categoria, COUNT (*) AS Nvolte, AVG (DataReferto-DataEsecuzione)
FROM ESAME E, ESECUZIONE ES, LABORATORIO L1
WHERE E.CodE = ES.CodE AND ES.CodL = L1.CodL AND Città = 'Torino'
GROUP BY CodE, NomeEsame, Categoria
HAVING AVG (DataReferto-DataEsecuzione) > (SELECT N
                                            FROM TMEDIOTOT T
                                            WHERE E.Categoria = T.Categoria)


/*Per ogni medico visualizzare nome, cognome, specializzazione e, per ciascun esame effettuato, 
il nome, il numero complessivo di volte in cui ha effettuato l’esame e il numero di date diverse
 in cui ha effettuato l’esame. Si considerino solo gli esami che soddisfano i seguenti requisiti:
  non sono mai stati eseguiti più di 3 volte in uno stesso laboratorio nello stesso giorno, 
  e che hanno avuto un numero complessivo di esecuzioni superiore al numero medio di esecuzioni 
  degli esami appartenenti alla stessa categoria (considerando tutti gli esami).
 */

WITH ESAMIBUONI AS (SELECT CodE
                    FROM ESECUZIONE ES
                    GROUP BY CodE, CodL, DataEsecuzione
                    HAVING COUNT (*) > 3),

ESAMI_DIVERSI_CATEGORIA AS (SELECT Categoria, COUNT (DISTINCT CodE) AS E_DIV
                            FROM ESAME E
                            GROUP BY Categoria),

N_PER_ESAME AS (SELECT E.CodE, Categoria, COUNT (*) AS NTOT
                FROM ESAME E, ESECUZIONE ES
                WHERE E.CodE = ES.CodE
                GROUP BY Categoria, E.CodE),

MEDIA_CATEGORIA AS (SELECT N_PER_ESAME.Categoria, SUM (NTOT)/MAX (E_DIV) AS Media
                    FROM N_PER_ESAME, ESAMI_DIVERSI_CATEGORIA
                    WHERE ESAMI_DIVERSI_CATEGORIA.Categoria = N_PER_ESAME.Categoria
                    GROUP BY N_PER_ESAME.Categoria),

ESAMIGOOD AS (SELECT CodE, COUNT (*) AS N
            FROM ESAME E
            WHERE CodE NOT IN (SELECT CodE FROM ESAMIBUONI)
            GROUP BY CodE)

SELECT NomeM, CognomeM, Specializzazione, NomeEsame, COUNT (DISTINCT DataEsecuzione), COUNT (*)
FROM MEDICO M, ESAMIGOOD EG, ESECUZIONE ES, ESAME E
WHERE ES.CodM = M.CodM AND E.CodE = ES.CodE AND E.CodE = EG.CodE
GROUP BY M.CodM, E.CodE, NomeM, CognomeM, Specializzazione, NomeEsame
HAVING COUNT (*) > (SELECT Media FROM MEDIA_CATEGORIA WHERE E.Categoria = MEDIA_CATEGORIA.Categoria)
                        

CREATE OR REPLACE TRIGGER gestione_recensioni
AFTER INSERT ON RECENSIONE_RISTORANTE
FOR EACH ROW
DECLARE
    N NUMBER;
    M NUMBER;
    X NUMBER;
BEGIN
    SELECT COUNT (*) INTO N
    FROM RIASSUNTO_RECENSIONI R
    WHERE R.CodR = :NEW.CodR;


    IF (N = 0) THEN

    INSERT INTO RIASSUNTO_RECENSIONI (CodR, NumeroRecensioni, PunteggioComplessivo)
    VALUES (:NEW.CodR, 1, :NEW.Punteggio);

    ELSE

    UPDATE RIASSUNTO_RECENSIONI
    SET NumeroRecensioni = NumeroRecensioni + 1, 
    PunteggioComplessivo = PunteggioComplessivo + :NEW.Punteggio
    WHERE CodR = :NEW.CodR;

    END IF;

    SELECT PunteggioComplessivo/NumeroRecensioni INTO M
    FROM RIASSUNTO_RECENSIONI
    WHERE CodR = :NEW.CodR;

    SELECT SUM (PunteggioComplessivo) / SUM (NumeroRecensioni) INTO X
    FROM RIASSUNTO_RECENSIONI, RISTORANTE
    WHERE RISTORANTE.CodR = RIASSUNTO_RECENSIONI.CodR 
    GROUP BY Città
    HAVING Città = (SELECT Città FROM RISTORANTE WHERE CodR = :NEW.CodR);


    INSERT INTO NOTIFICA
    VALUES (:NEW.CodR, :NEW.DataRecensione, M, X);
END