CREATE table NEWS(
    ID_News int auto_increment primary key,
    Fonte varchar(50) not null,
    Dominio varchar(50) not null,
    DataPubblicazione date not null,
    Titolo varchar (50),
    Url varchar (255) not null,
    Autore varchar(50),
    Testo varchar(255),
    Commento varchar(50),
    Multimedia varbinary
);

CREATE table TOPIC(
 ID_Topic int auto_increment primary key,
 Argomento varchar(50) not null
);

CREATE table RESULT(
    ID_Result int auto_increment primary key,
    TipoResult varchar(10) check(TipoResult in('Fake', 'Vera', 'Dubbia'))
);

CREATE table MOTIVAZIONEFAKE(
    ID_Motivazione int auto_increment primary key,
    Descrizione varchar(50) check(Descrizione in('Contenuto fabbricato', 'Contenuto manipolato', 'Contenuto diffuso da impostori', 
    'Falso contesto', 'Contenuto ingannevole', 'Falsa connessione', 'Satira o parodia')) not null,
    Nota varchar(50)
);

CREATE table ESPERTO(
    Id_Esperto int auto_increment primary key,
    Nome varchar(20) not null,
    Cognome varchar(20) not null,
    Ruolo char(6) check(Ruolo in('Junior', 'Senior')) not null
);

CREATE table CLASSIFICAZIONE(
    ID_Classificazione int auto_increment primary key,
    DataClassificazione date not null,
    Validazione boolean check(Validazione) in('si', 'no') not null,
    ID_News int not null,
    ID_Topic int not null,
    ID_Result int not null,
    Id_Esperto int not null,
    ID_Motivazione int,
    FOREIGN KEY (ID_News) REFERENCES NEWS (ID_News),
    FOREIGN KEY (ID_Topic) REFERENCES TOPIC (ID_Topic),
    FOREIGN KEY (ID_Result) REFERENCES RESULT (ID_Result),
    FOREIGN KEY (Id_Esperto) REFERENCES ESPERTO (Id_Esperto),
    FOREIGN KEY (ID_Motivazione) REFERENCES MOTIVAZIONEFAKE (ID_Motivazione)
);

--Gli ID sono considerati tutti di tipo int autoincrementali poichè si ipotizza siano costituiti esclusivamente da caratteri numerici--
--La tabella CLASSIFICAZIONE deve essere creata per ultima poichè contiene al proprio interno tutte le chiavi esterne, a cui non potrebbe far riferimento senza la precedente creazione di tutte le altre tabelle--


--4a. Il numero di news classificate come false (fake) per ciascun valore dell'etichetta Topic pubblicate nell'ultimo anno--
SELECT COUNT (N.ID_News) AS TOTFAKENEWS, T.Argomento
FROM NEWS AS N INNER JOIN CLASSIFICAZIONE AS C ON N.ID_News=C.ID_News INNER JOIN RESULT AS R ON C.ID_Result=R.ID_Result INNER JOIN 
TOPIC AS T ON C.ID_Topic=T.ID_Topic
WHERE R.TipoResult='Fake' AND (N.DataPubblicazione BETWEEN '2025-01-01' AND '2025-12-31')
GROUP BY T.Argomento;

--4b. Il numero di news analizzate da un certo esperto senior di cui siano stati forniti il nome ed il cognome--
SELECT COUNT (C.ID_News) AS NEWSANALIZZATE
FROM CLASSIFICAZIONE AS C INNER JOIN ESPERTO AS E ON C.Id_Esperto=E.Id_Esperto
WHERE E.Ruolo='Senior' AND E.Nome=[Inserisci nome] AND E.Cognome=[Inserisci cognome];

--4c. Dato un argomento (Topic) e un periodo di pubblicazione, il numero delle news classificate come fake per ogni singola motivazione--
SELECT COUNT (M.ID_Motivazione) AS NUMFAKE
FROM NEWS AS N INNER JOIN CLASSIFICAZIONE AS C ON N.ID_News=C.ID_News INNER JOIN MOTIVAZIONEFAKE AS M ON C.ID_Motivazione=M.ID_Motivazione 
INNER JOIN TOPIC AS T ON C.ID_Topic=T.ID_Topic 
WHERE T.Argomento=[Inserisci topic] AND (DataPubblicazione BETWEEN[Inserisci data iniziale]AND [Inserisci data finale])
GROUP BY M.Descrizione;
--La tabella RESULT non viene inserita nella JOIN poichè contando gli ID della tabella motivazione si hanno già delle news precedentemente classificate come fake--

4d. --Il nominativo dell'operatore senior che ha effettuato il maggior numero di validazioni nell'ultimo mese delle news di tipo "fake"--
SELECT E.Nome, E.Cognome, COUNT(C.*) AS NumeroValidazioni
FROM ESPERTO AS E INNER JOIN CLASSIFICAZIONE AS C ON E.Id_Esperto=C.Id_Esperto INNER JOIN RESULT AS R ON C.ID_Result=R.ID_Result
WHERE C.Validazione='si' 
    AND R.TipoResult='Fake' 
    AND E.Ruolo='Senior' 
    AND C.DataClassificazione BETWEEN '2026-01-01' AND '2026-01-31'
    GROUP BY E.Id_Esperto
    ORDER BY NumeroValidazioni DESC
    LIMIT 1;
          





