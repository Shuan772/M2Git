
-- DB Anlegen und verwenden
-- /wenn die Rechte dazu existieren!
CREATE DATABASE November;
USE November;

-- DB löschen
DROP DATABASE November;


CREATE TABLE Kunden (
	Nummer INT,						-- Nummer wie in ERD
	`Vorname` STRING(100),		-- Geht der String? Datentypen lesen
	`Nachname` VARCHAR(50),
	`E-Mail` VARCHAR(255),		-- Backticks `` für problematische Namen
	`Portrait` BLOB				-- sollte nicht 4mb groß sein ;)
);

-- Daten alle auswählen von Kunden
SELECT * FROM Kunden;

-- Welche Tabellen? Wie sehen die aus?
SHOW TABLES;
DESCRIBE Kunden;

-- Tabelle(nschema) löschen
DROP TABLE Kunden;
CREATE TABLE Kunden (
	Nummer INT UNSIGNED AUTO_INCREMENT,	
	`Vorname` VARCHAR(100),			
	`Nachname` VARCHAR(50) NOT NULL,
	`E-Mail` VARCHAR(255) UNIQUE,
	`Portrait` BLOB,				
	PRIMARY KEY(Nummer) -- Künstlich --> Surrogate Key
);

CREATE TABLE Bankdaten (
	IBAN CHAR(22) PRIMARY KEY,
	BIC CHAR(10), -- abgeleitetes Attribut
	Kunde INT NOT NULL,
	CONSTRAINT `KundeFürBankdaten` FOREIGN KEY (Kunde) REFERENCES Kunden(Nummer) -- erster Fremdschlüssel
);

CREATE TABLE Zutaten(
	vegan BOOL 
);

DROP TABLE Zahlungen;
CREATE TABLE Zahlungen (
	TXID INT UNSIGNED PRIMARY KEY AUTO_INCREMENT, -- so ist es richtig!
	Betrag DECIMAL(5,2) NOT NULL,
	Zweck VARCHAR(255) DEFAULT 'Nicht näher beschrieben',
	Kunde INT NOT NULL,
	IBAN VARCHAR(22),
	
	CONSTRAINT `KundeFürZahlung` 
		FOREIGN KEY (Kunde) REFERENCES Kunden(Nummer), -- erster Fremdschlüssel,
	
	FOREIGN KEY (IBAN) REFERENCES Bankdaten (IBAN) ON DELETE CASCADE
);



CREATE TABLE Fahrzeuge (
	ID INT AUTO_INCREMENT PRIMARY KEY,
	Erfassungsdatum DATE DEFAULT CURRENT_DATE NOT NULL,
	Vernichtungsdatum DATE DEFAULT CURRENT_DATE,
	Kreis VARCHAR(3) NOT NULL DEFAULT 'AC',
	Kennzeichen VARCHAR(7) NOT NULL,
	
	Antrieb ENUM ('Elektro', 'Diesel', 'Benzin', 'Kerosin')
	
	-- oder so?
	-- FOREIGN KEY (Antrieb) REFERENCES Antriebe (Typ)
);

CREATE TABLE Antriebe (
	Typ VARCHAR(8) PRIMARY KEY
);
-- Diesel
-- Benzin
-- Elektro
-- Gas


-- Primärschlüssel über mehrere Attribute
CREATE TABLE Raum (
	Gebäude CHAR(1),
	Nummer TINYINT(3) UNSIGNED,
	PRIMARY KEY (Gebäude, Nummer)
);

CREATE TABLE FahrzeugKunde (
	Kunde INT,
	Fahrzeug INT,
	FOREIGN KEY (Kunde) REFERENCES Kunden(Nummer),
	FOREIGN KEY (Fahrzeug) REFERENCES Fahrzeuge(ID),
	PRIMARY KEY (Kunde, Fahrzeug)
);

CREATE TABLE Parklog (
	ID INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,	
	Einfahrt TIMESTAMP,	
	Kunde INT,	
	Fahrzeug INT,	
	CONSTRAINT `Balalala`
		FOREIGN KEY (Kunde, Fahrzeug)
		REFERENCES FahrzeugKunde (Kunde, Fahrzeug)
);





DROP TABLE IF EXISTS Zutaten;
CREATE TABLE Zutaten (
	ID INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
	Bio Bool,
	Vegan Bool,
	Vegetarisch Bool,
	Glutenfrei Bool,
	Name VARCHAR(255),
);

DROP TABLE IF EXISTS ZutatenXMahlzeiten;
CREATE TABLE ZutatenXMahlzeiten(
	ID INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
	Zutaten INT,
	Mahlzeiten INT,
	FOREIGN KEY (Zutaten) REFERENCES Zutaten(ID),
	FOREIGN KEY (Mahlzeiten) REFERENCES Mahlzeiten(ID)
);

DROP TABLE IF EXISTS Mahlzeiten;
CREATE TABLE Mahlzeiten(
	ID INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
	Vorrat INT,
	Beschreibung VARCHAR(255),
	Verfügbar BOOL, -- Wie rechnet man aus  abgeleitetes attribut
	FOREIGN KEY (Kommentare) REFERENCES Kommentare(ID)
);

DROP TABLE IF EXISTS MahlzeitenXBilder;
CREATE TABLE MahlzeitenXBilder(
	ID INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
	Mahlzeiten INT,
	Bilder INT,
	FOREIGN KEY (Mahlzeiten) REFERENCES Mahlzeiten(ID),
	FOREIGN KEY (Bilder) REFERENCES Bilder(ID)
);

DROP TABLE IF EXISTS Bilder;
CREATE TABLE Bilder(
	ID INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
	`Alt-Text` VARCHAR(255),
	Titel VARCHAR(255) NOT NULL,
	`Binärdaten` BLOB,
	FOREIGN KEY (Kategorien) REFERENCES Kategorien(ID)
);

DROP TABLE IF EXISTS Kategorien;
CREATE TABLE Kategorien(
	ID INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
	Bezeichnung VARCHAR(255),
	FOREIGN KEY (Mahlzeiten) REFERENCES Mahlzeiten(ID),
	FOREIGN KEY (Kategorien) REFERENCES Kategorien(ID)
);

DROP TABLE IF EXISTS Preise;
CREATE TABLE Preise(
	MA-Preis INT NOT NULL,
	Studentpreis INT NOT NULL,
	Gastpreis INT,
	Jahr year
);

DROP TABLE IF EXISTS Kommentare;
CREATE TABLE Kommentare(
	ID INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
	Bemerkung VARCHAR(255) NOT NULL,
	Bewertung INT
);

DROP TABLE IF EXISTS Student;
CREATE TABLE Student(
	ID INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
	Matrikelnummer INT,
	Studiengang VARCHAR(255),
	FOREIGN KEY (Kommentare) REFERENCES Kommentare(ID)
);


DROP TABLE IF EXISTS Mitarbeiter;
CREATE TABLE Mitarbeiter(
	ID INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
	Telefon INT NOT NULL,
	Büro VARCHAR(255)
);

DROP TABLE IF EXISTS Gäste;
CREATE TABLE Gäste(
	Grund VARCHAR(255),
	Ablaufdatum Date
	
);

DROP TABLE IF EXISTS FH-Angehörige;
CREATE TABLE FH-Angehörige(
	
);

DROP TABLE IF EXISTS Fachbereiche;
CREATE TABLE Fachbereiche(
	ID INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
	Website VARCHAR(255),
	Name VARCHAR(255)
);

DROP TABLE IF EXISTS FH-AngehörigerXFachbereich;
CREATE TABLE FH-AngehörigeXFachbereiche(
	Fachbereiche INT,
	FH-Angehörige -- ?????????
	FOREIGN KEY (Fachbereiche) REFERENCES Fachbereiche(ID),
	FOREIGN KEY (FH-Angehörige) REFERENCES FH-Angehörige(ID)
);


DROP TABLE IF EXISTS Deklarationen;
CREATE TABLE Deklarationen(
	Zeichen INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
	Beschriftung VARCHAR(255)
);

DROP TABLE IF EXISTS MahlzeitenXDeklaration;
CREATE TABLE MahlzeitenXDeklarationen(
	Mahlzeiten INT,
	Deklarationen INT,
	FOREIGN KEY (Mahlzeiten) REFERENCES Mahlzeiten(ID),
	FOREIGN KEY (Deklarationen) REFERENCES Deklarationen(Zeichen)
);

DROP TABLE IF EXISTS Bestellungen;
CREATE TABLE Bestellungen(
	Nummer INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
	Bestellzeitpunkt Datetime,
	Abholzeitpunkt Datetime NOT NULL,
	Endpreis INT
);

DROP TABLE IF EXISTS MahlzeitenXBestellungen;
CREATE TABLE MahlzeitenXBestellungen(
	Mahlzeieten INT,
	Bestellungen INT,
	Anzahl INT,
	FOREIGN KEY (Mahlzeiten) REFERENCES Mahlzeiten(ID),
	FOREIGN KEY (Bestellungen) REFERENCES Bestellungen(Nummer)
);

DROP TABLE IF EXISTS Benutzer;
CREATE TABLE Benutzer(
	Nummer INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
	FOREIGN KEY (Bestellungen) REFERENCES Bestellungen(Nummer),
	E-Mail VARCHAR(255),
	Letzter Login Datetime,
	Nutzername VARCHAR(255),
	Geburtsdatum Date,
	Aktiv BOOL,
	Anlegedatum Date,
	`Alter` INT, -- bearbeiten
	Vorname VARCHAR(255),
	Nachname VARCHAR(255),
	NAME VARCHAR(255) GENERATED ALWAYS AS (Vorname || ' ' || Nachname) VIRTUAL,
	Salt VARCHAR(32),
	`Hash` VARCHAR(24),
	AUTH VARCHAR(255) GENERATED ALWAYS AS (Salt || ' ' || `Hash`) VIRTUAL
);

DROP TABLE IF EXISTS BenutzerXBenutzer;
CREATE TABLE BenutzerXBenutzer(
	Benutzereins INT,
	Benutzerzwei INT,
	FOREIGN KEY (Benutzereins) REFERENCES Benutzer(Nummer),
	FOREIGN KEY (Benutzerzwei) REFERENCES Benutzer(Nummer)
);









-- DDL Tabellen verändern, hier: Constraints (Bedingungen, die erfüllt sein müssen)
ALTER TABLE Fahrzeuge ADD CONSTRAINT `Fahrzeugeindeutig` UNIQUE (Kreis, Kennzeichen);

-- DDL Check Constraint als Bedingung
ALTER TABLE Raum ADD CONSTRAINT `Gebäudenachplan`  
CHECK (Gebäude IN ('A', 'C', 'D', 'H'))
-- CHECK `Gebäude` = 'A' OR `Gebäude` = 'C' OR `Gebäude` = 'D'  OR `Gebäude` = 'H';


-- DML 

-- INSERT

DESCRIBE Fahrzeuge
-- INSERT INTO Fahrzeuge (Erfassungsdatum, Vernichtungsdatum, Kreis, Kennzeichen, Antrieb) 
-- VALUES (CURRENT_DATE, NULL, 'TR', 'TT101', 'Diesel');

-- DELETE FROM Fahrzeuge WHERE ID = 6

-- Attribut in Tabelle aktualisieren für Entitäten, die die WHERE Bedingung erfüllen
UPDATE Fahrzeuge SET Vernichtungsdatum = '2099-12-31' WHERE ID=8

-- 
SELECT * FROM Fahrzeuge

INSERT INTO Raum (Gebäude, Nummer) 
VALUES 
('D',6), -- geht
('E',141), -- geht nach CHECK constraint nicht mehr
('E',143),
('E',145),
('H',215);


DESCRIBE Raum;