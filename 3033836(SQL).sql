-- -test------------------------------------------------------------------------------------------------------------------------------------------
-- -test------------------------------------------------------------------------------------------------------------------------------------------
-- IF Not EXISTS Create DATABASE Mensa;
-- use Mensa;
-- ----Ohne Foreign key zuerst.
-- DEFAULT 0 -- noch zu setzen
-- NOT NULL bei Forgein keys
-- Alle Annahmen Kommentieren

-- Drop Tables ....
-- Kreuz
DROP TABLE IF EXISTS MahlzeitenXBilder;
DROP TABLE IF EXISTS ZutatenXMahlzeiten;
DROP TABLE IF EXISTS FHAngehörigeXFachbereiche;
DROP TABLE IF EXISTS MahlzeitenXDeklarationen;
DROP TABLE IF EXISTS MahlzeitenXBestellungen;
DROP TABLE IF EXISTS BenutzerXBenutzer;
-- andere
DROP TABLE IF EXISTS Kommentare;
DROP TABLE IF EXISTS Preise;
DROP TABLE IF EXISTS Mahlzeiten;
DROP TABLE IF EXISTS Kategorien;
DROP TABLE IF EXISTS Student;
DROP TABLE IF EXISTS Mitarbeiter;
DROP TABLE IF EXISTS Gäste;
DROP TABLE IF EXISTS `FHAngehörige`;
DROP TABLE IF EXISTS Bestellungen;
-- Ohne 
DROP TABLE IF EXISTS Fachbereiche;
DROP TABLE IF EXISTS Deklarationen;
DROP TABLE IF EXISTS Bilder;
DROP TABLE IF EXISTS Zutaten;
DROP TABLE IF EXISTS Benutzer;
-- Create Tables ....
-- Ohne 
CREATE TABLE Zutaten (
	ID INT UNSIGNED PRIMARY KEY CHECK( ID BETWEEN 9999 AND 100000),
	Bio BOOL NOT NULL DEFAULT 0,
	Vegan BOOL NOT NULL DEFAULT 0,
	Vegetarisch BOOL NOT NULL DEFAULT 0,
	Glutenfrei BOOL NOT NULL DEFAULT 0,
	Name VARCHAR(30) NOT NULL -- e
);

CREATE TABLE Bilder(
	ID INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
	`Alt-Text` VARCHAR(50) NOT NULL, -- ein alt ist eigentlich immer kurz und knackig
	Titel VARCHAR(50) , -- Genauso der Titel
	`Binärdaten` BLOB NOT NULL
);

CREATE TABLE Deklarationen(
	Zeichen VARCHAR(2) PRIMARY KEY,
	Beschriftung VARCHAR(32) NOT NULL
);

CREATE TABLE Fachbereiche(
	ID INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
	Website VARCHAR(100) NOT NULL,
	Name VARCHAR(50) NOT NULL,
	Adresse VARCHAR(100)
);

CREATE TABLE Benutzer(
	Nummer INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
	`E-Mail` VARCHAR(100) UNIQUE NOT NULL,
	LetzterLogin Datetime DEFAULT NULL,
	Nutzername VARCHAR(30)UNIQUE NOT NULL,
	Geburtsdatum Date,
	Aktiv BOOL NOT NULL,
	Anlegedatum Date NOT NULL,
	`Alter` INT, -- Berechnet
	Vorname VARCHAR(50) NOT NULL,
	Nachname VARCHAR(25) NOT NULL,
	Salt VARCHAR(32) NOT NULL,
	`Hash` VARCHAR(24) NOT NULL,
	ISA ENUM("Gast", "FHAngehörige") NOT NULL
);
-- andere

CREATE TABLE Bestellungen(
	Nummer INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
	Bestellzeitpunkt Datetime NOT NULL,
	Abholzeitpunkt Datetime,
	Benutzer INT UNSIGNED,
	FOREIGN KEY (Benutzer) REFERENCES Benutzer(Nummer),
	Endpreis DOUBLE(2,2) -- Berechnet
	
);

CREATE TABLE `FHAngehörige`(
	ID INT UNSIGNED PRIMARY KEY,
	CONSTRAINT `BenutzerDelFHA` FOREIGN KEY (ID) REFERENCES Benutzer(Nummer) ON DELETE CASCADE
	-- beziehung zu Benutzer
);
CREATE TABLE Gäste(
	Grund VARCHAR(255),
	Ablaufdatum Date,
	ID INT UNSIGNED PRIMARY KEY,
	CONSTRAINT `BenutzerDelGast` FOREIGN KEY (ID) REFERENCES Benutzer(Nummer) ON DELETE CASCADE
	-- beziehung zu Benutzer
);
CREATE TABLE Mitarbeiter(
	ID INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
	Telefon VARCHAR(20) ,
	Büro VARCHAR(20),
	`FHAngehörige` INT UNSIGNED UNIQUE,
	CONSTRAINT `BenutzerDelMA` FOREIGN KEY (`FHAngehörige`) REFERENCES `FHAngehörige`(ID) ON DELETE CASCADE

);
CREATE TABLE Student(
	ID INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
	Matrikelnummer INT UNSIGNED UNIQUE NOT NULL CHECK( Matrikelnummer BETWEEN 9999999 AND 1000000000),
	Studiengang ENUM ("ET", "INF", "ISE", "MCD", "WI") NOT NULL DEFAULT "INF",
	`FHAngehörige` INT UNSIGNED UNIQUE,
	CONSTRAINT `BenutzerDelStu` FOREIGN KEY (`FHAngehörige`) REFERENCES `FHAngehörige`(ID) ON DELETE CASCADE
);

CREATE TABLE Kategorien(
	ID INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
	Bezeichnung VARCHAR(25) NOT NULL,
	Bild INT UNSIGNED,
	Kategorie INT UNSIGNED,
	CONSTRAINT `BildDel`
	FOREIGN KEY (Bild) 
	REFERENCES Bilder(ID)
	ON DELETE SET NULL 
		,
	CONSTRAINT `ParentDel`
	FOREIGN KEY (Kategorie) 
	REFERENCES Kategorien(ID)
	ON DELETE SET NULL 
);

CREATE TABLE Mahlzeiten(
	ID INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
	Vorrat INT UNSIGNED NOT NULL DEFAULT 0,
	Beschreibung VARCHAR(255) NOT NULL,
	Name VARCHAR(20) NOT NULL,
	Kategorie INT UNSIGNED,
	FOREIGN KEY (Kategorie) REFERENCES Kategorien(ID),
	Verfügbar BOOL, -- Berechnet.
	PreisJahr year
);

CREATE TABLE Preise(
	`MA-Preis` DOUBLE(2,2),
	Studentpreis DOUBLE(2,2) ,
	Gastpreis DOUBLE(2,2) NOT NULL,
	Jahr year NOT NULL,	-- hilfs primary ?
	Mahlzeit  INT UNSIGNED,
	CONSTRAINT `PreisZuMahlzeitLöschen` 
	FOREIGN KEY (Mahlzeit) 
	REFERENCES Mahlzeiten(ID)
	ON DELETE CASCADE 
);

CREATE TABLE Kommentare(
	ID INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
	Bemerkung VARCHAR(255),
	Bewertung DOUBLE(1,1) NOT NULL ,
	Mahlzeiten INT UNSIGNED,
	Student INT UNSIGNED NOT NULL,
	FOREIGN KEY (Student) REFERENCES Student(ID),
	CONSTRAINT `MahlzeitGelöscht`
	FOREIGN KEY (Mahlzeiten) 
	REFERENCES Mahlzeiten(ID)
	ON DELETE SET NULL
);

-- Kreuz
CREATE TABLE ZutatenXMahlzeiten(
	ID INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
	Zutaten INT UNSIGNED NOT NULL,
	Mahlzeit INT UNSIGNED NOT NULL,
	FOREIGN KEY (Zutaten) REFERENCES Zutaten(ID)

);

CREATE TABLE MahlzeitenXBilder(
	ID INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
	Mahlzeiten INT UNSIGNED NOT NULL,
	Bilder INT UNSIGNED NOT NULL,
	FOREIGN KEY (Mahlzeiten) REFERENCES Mahlzeiten(ID),
	FOREIGN KEY (Bilder) REFERENCES Bilder(ID)
);

CREATE TABLE FHAngehörigeXFachbereiche(
	Fachbereiche INT UNSIGNED,
	FHAngehörige INT UNSIGNED, 
	FOREIGN KEY (Fachbereiche) REFERENCES Fachbereiche(ID),
	FOREIGN KEY (FHAngehörige) REFERENCES FHAngehörige(ID)
	-- Beziehungs kram
);

CREATE TABLE MahlzeitenXDeklarationen(
	Mahlzeiten INT UNSIGNED,
	Deklarationen VARCHAR(2),
	FOREIGN KEY (Mahlzeiten) REFERENCES Mahlzeiten(ID),
	FOREIGN KEY (Deklarationen) REFERENCES Deklarationen(Zeichen)
);

CREATE TABLE MahlzeitenXBestellungen(
	Mahlzeiten INT UNSIGNED,
	Bestellungen INT UNSIGNED,
	Anzahl INT UNSIGNED NOT NULL,
	FOREIGN KEY (Mahlzeiten) REFERENCES Mahlzeiten(ID),
	FOREIGN KEY (Bestellungen) REFERENCES Bestellungen(Nummer)
);

CREATE TABLE BenutzerXBenutzer(
	Benutzereins INT UNSIGNED,
	Benutzerzwei INT UNSIGNED,
	FOREIGN KEY (Benutzereins) REFERENCES Benutzer(Nummer),
	FOREIGN KEY (Benutzerzwei) REFERENCES Benutzer(Nummer)
);



INSERT INTO Benutzer (`E-Mail` , Nutzername , Aktiv , Anlegedatum , Vorname , Nachname , Salt , `Hash` , ISA ) 
VALUES 
('test1@test.de','test1' , 1 , '1996-01-02' , 'Adrian', 'Dorshock' , 'asdjaowdp23424' , '68g3r7bhdixan' , "FHAngehörige" ), 
('test2@test.de','test2' , 1 , '1997-01-02' , 'Adr', 'Dor' , 'asdjaowdp23424' , '68g3r7bhdixan' , "FHAngehörige" ),
('test3@test.de','test3' , 1 , '1998-01-02' , 'Alexander', 'Schultes' , 'asdjaowdp23424' , '68g3r7bhdixan' , "FHAngehörige" ),
('test4@test.de','test4' , 1 , '1999-01-02' , 'Ale', 'Sch' , 'asdjaowdp23424' , '68g3r7bhdixan' , "Gast" );


REPLACE INTO `Deklarationen` (`Zeichen`, `Beschriftung`) VALUES
	('2', 'Konservierungsstoff'),
	('3', 'Antioxidationsmittel'),
	('4', 'Geschmacksverstärker'),
	('5', 'geschwefelt'),
	('6', 'geschwärzt'),
	('7', 'gewachst'),
	('8', 'Phosphat'),
	('9', 'Süßungsmittel'),
	('10', 'enthält eine Phenylalaninquelle'),
	('A', 'Gluten'),
	('A1', 'Weizen'),
	('A2', 'Roggen'),
	('A3', 'Gerste'),
	('A4', 'Hafer'),
	('A5', 'Dinkel'),
	('B', 'Sellerie'),
	('C', 'Krebstiere'),
	('D', 'Eier'),
	('E', 'Fische'),
	('F', 'Erdnüsse'),
	('G', 'Sojabohnen'),
	('H', 'Milch'),
	('I', 'Schalenfrüchte'),
	('I1', 'Mandeln'),
	('I2', 'Haselnüsse'),
	('I3', 'Walnüsse'),
	('I4', 'Kaschunüsse'),
	('I5', 'Pecannüsse'),
	('I6', 'Paranüsse'),
	('I7', 'Pistazien'),
	('I8', 'Macadamianüsse'),
	('J', 'Senf'),
	('K', 'Sesamsamen'),
	('L', 'Schwefeldioxid oder Sulfite'),
	('M', 'Lupinen'),
	('N', 'Weichtiere')
;

REPLACE INTO `Zutaten` (`ID`, `Name`, `Bio`, `Vegan`, `Vegetarisch`, `Glutenfrei`) VALUES
	(10080, 'Aal', 0, 0, 0, 1),
	(10081, 'Forelle', 0, 0, 0, 1),
	(10082, 'Barsch', 0, 0, 0, 1),
	(10083, 'Lachs', 0, 0, 0, 1),
	(10084, 'Lachs', 1, 0, 0, 1),
	(10085, 'Heilbutt', 0, 0, 0, 1),
	(10086, 'Heilbutt', 1, 0, 0, 1),
	(10100, 'Kurkumin', 1, 1, 1, 1),
	(10101, 'Riboflavin', 0, 1, 1, 1),
	(10123, 'Amaranth', 1, 1, 1, 1),
	(10150, 'Zuckerkulör', 0, 1, 1, 1),
	(10171, 'Titandioxid', 0, 1, 1, 1),
	(10220, 'Schwefeldioxid', 0, 1, 1, 1),
	(10270, 'Milchsäure', 0, 1, 1, 1),
	(10322, 'Lecithin', 0, 1, 1, 1),
	(10330, 'Zitronensäure', 1, 1, 1, 1),
	(10999, 'Weizenmehl', 1, 1, 1, 0),
	(11000, 'Weizenmehl', 0, 1, 1, 0),
	(11001, 'Hanfmehl', 1, 1, 1, 1),
	(11010, 'Zucker', 0, 1, 1, 1),
	(11013, 'Traubenzucker', 0, 1, 1, 1),
	(11015, 'Branntweinessig', 0, 1, 1, 1),
	(12019, 'Karotten', 0, 1, 1, 1),
	(12020, 'Champignons', 0, 1, 1, 1),
	(12101, 'Schweinefleisch', 0, 0, 0, 1),
	(12102, 'Speck', 0, 0, 0, 1),
	(12103, 'Alginat', 0, 1, 1, 1),
	(12105, 'Paprika', 0, 1, 1, 1),
	(12107, 'Fenchel', 0, 1, 1, 1),
	(12108, 'Sellerie', 0, 1, 1, 1),
	(19020, 'Champignons', 1, 1, 1, 1),
	(19105, 'Paprika', 1, 1, 1, 1),
	(19107, 'Fenchel', 1, 1, 1, 1),
	(19110, 'Sojasprossen', 1, 1, 1, 1)
;


-- Im ER-Diagramm fehlt noch das Attribut Adresse, 
-- das Sie per ALTER TABLE einfach hinzufügen können
-- sobald Sie an den Punkt kommen ;)

REPLACE INTO `Fachbereiche` (`ID`, `Name`, `Website`, `Adresse`) VALUES
	(1, 'Architektur', 'https://www.fh-aachen.de/fachbereiche/architektur/', 'Bayernallee 9, 52066 Aachen'),
	(2, 'Bauingenieurwesen', 'https://www.fh-aachen.de/fachbereiche/bauingenieurwesen/', 'Bayernallee 9, 52066 Aachen'),
	(3, 'Chemie und Biotechnologie', 'https://www.fh-aachen.de/fachbereiche/chemieundbiotechnologie/', 'Heinrich-Mußmann-Straße 1, 52428 Jülich'),
	(4, 'Gestaltung', 'https://www.fh-aachen.de/fachbereiche/gestaltung/', 'Boxgraben 100, 52064 Aachen'),
	(5, 'Elektrotechnik und Informationstechnik', 'https://www.fh-aachen.de/fachbereiche/elektrotechnik-und-informationstechnik/', 'Eupener Straße 70, 52066 Aachen'),
	(6, 'Luft- und Raumfahrttechnik', 'https://www.fh-aachen.de/fachbereiche/luft-und-raumfahrttechnik/', 'Hohenstaufenallee 6, 52064 Aachen'),
	(7, 'Wirtschaftswissenschaften', 'https://www.fh-aachen.de/fachbereiche/wirtschaft/', 'Eupener Straße 70, 52066 Aachen'),
	(8, 'Maschinenbau und Mechatronik', 'https://www.fh-aachen.de/fachbereiche/maschinenbau-und-mechatronik/', 'Goethestraße 1, 52064 Aachen'),
	(9, 'Medizintechnik und Technomathematik', 'https://www.fh-aachen.de/fachbereiche/medizintechnik-und-technomathematik/', 'Heinrich-Mußmann-Straße 1, 52428 Jülich'),
	(10, 'Energietechnik', 'https://www.fh-aachen.de/fachbereiche/energietechnik/', 'Heinrich-Mußmann-Straße 1, 52428 Jülich')
;
REPLACE INTO `FHAngehörige` (`ID`) VALUES
(1),
(2),
(3);

REPLACE INTO `Student` (Matrikelnummer, Studiengang , `FHAngehörige`) VALUES
(30338369 , "INF" , 3),
(30335859 , "INF" , 1);

REPLACE INTO `Mitarbeiter` (Büro, Telefon , `FHAngehörige`) VALUES
("E203" , "08054646" , 3);

DELETE FROM `Benutzer` WHERE Nummer = 4;

-- ALTER TABLE Mahlzeiten 
-- FOREIGN KEY (PreisJahr) REFERENCES Preise(Jahr);-- eins zu eins bezieheung mit Preis 

