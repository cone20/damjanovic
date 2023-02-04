CREATE DATABASE Zubarska_Radionica

USE Zubarska_Radionica

CREATE TABLE Zaposlen(
    jmbg VARCHAR(13)  PRIMARY KEY NOT NULL,
    ime VARCHAR(30) NOT NULL,
    prezime VARCHAR(30) NOT NULL,
    godinaRodjenja DATE NOT NULL,
    adresaStana VARCHAR(50) NOT NULL,
    telefonZaposlenog VARCHAR(20) NOT NULL,
    stepenStrucneSpreme VARCHAR(30) NOT NULL,
    datumZasnivanjaRadnogOdnosa DATE NOT NULL
);

CREATE TABLE Administrator(
    id INT NOT NULL PRIMARY KEY IDENTITY(1,1),
    jmbgZaposlenog VARCHAR(13) NOT NULL,
    CONSTRAINT FK_Administrator_Zaposlen_jmbg FOREIGN KEY (jmbgZaposlenog) REFERENCES Zaposlen(jmbg)
);

CREATE TABLE MedicinskiTehnicar(
    idTehnicara INT NOT NULL PRIMARY KEY IDENTITY(1,1)
);


CREATE TABLE Klijent(
    jmbg VARCHAR(13) PRIMARY KEY NOT NULL,
    ime VARCHAR(30) NOT NULL,
    prezime VARCHAR(30) NOT NULL,
    pol VARCHAR(30) NOT NULL,
    adresaStana VARCHAR(30) NOT NULL,
    telefon VARCHAR(30) NOT NULL,
);



CREATE TABLE Racun(
    brojRacuna INT PRIMARY KEY NOT NULL IDENTITY(1,1),
    jmbgKlijenta VARCHAR(13) NOT NULL
    CONSTRAINT FK_Racun_Klijent_jmbg FOREIGN KEY (jmbgKlijenta) REFERENCES Klijent(jmbg)
);

CREATE TABLE Doktor(
    idDoktora INT PRIMARY KEY NOT NULL IDENTITY(1,1)
);

CREATE TABLE IzvrseniPregled(
    brojPregleda INT PRIMARY KEY NOT NULL IDENTITY(1,1),
    vremePregleda TIME NOT NULL,
    datumPregleda DATE NOT NULL,
    idDoktora INT NOT NULL,
    CONSTRAINT FK_IzvrseniPregled_Doktor_id FOREIGN KEY (idDoktora) REFERENCES Doktor(idDoktora)    
);

CREATE TABLE Usluge(
    sifra VARCHAR(11) NOT NULL PRIMARY KEY,
    naziv VARCHAR(30) NOT NULL,
    cena VARCHAR(30) NOT NULL,
);

CREATE TABLE ZakazanPregled(
    idZakazanogPregleda INT NOT NULL PRIMARY KEY IDENTITY(1,1),
    vreme TIME NOT NULL,
    datum DATE NOT NULL,
    idDoktora INT NOT NULL,
    sifraUsluge VARCHAR(11) NOT NULL,
    jmbgKlijenta VARCHAR(13) NOT NULL,
    CONSTRAINT FK_ZakazanPregled_Doktor_id FOREIGN KEY (idDoktora) REFERENCES Doktor(idDoktora),
    CONSTRAINT FK_ZakazanPregled_Usluga_sifra FOREIGN KEY (sifraUsluge) REFERENCES Usluge(sifra),
    CONSTRAINT FK_ZakazanPregled_Klijent_jmbg FOREIGN KEY (jmbgKlijenta) REFERENCES Klijent(jmbg),
);

CREATE TABLE Zub(
    brojZuba INT PRIMARY KEY NOT NULL,
    stanjeZuba VARCHAR(50) NOT NULL,
);

CREATE TABLE Intervencija(
    brojIntervencije INT PRIMARY KEY NOT NULL IDENTITY(1,1),
    brojZuba INT NOT NULL,
    brojRacuna INT NOT NULL,
    sifraUsluge VARCHAR(11) NOT NULL,
    CONSTRAINT FK_Intervencija_Zub_broj FOREIGN KEY (brojZuba) REFERENCES Zub(brojZuba),
    CONSTRAINT FK_Intervencija_Racun_broj FOREIGN KEY (brojRacuna) REFERENCES Racun(brojRacuna),
    CONSTRAINT FK_Intervencija_Usluga_sifra FOREIGN KEY (sifraUsluge) REFERENCES Usluge(sifra),
);

CREATE TABLE Materijal(
    sifra INT NOT NULL PRIMARY KEY,
    naziv VARCHAR(50) NOT NULL,
    stanje VARCHAR(50) NOT NULL,
);

CREATE TABLE Iskoristio(
    id INT PRIMARY KEY NOT NULL IDENTITY(1,1),
    brojIntervencije INT NOT NULL,
    sifraMaterijala INT NOT NULL,
    CONSTRAINT FK_Iskoristio_Intervencija FOREIGN KEY (brojIntervencije) REFERENCES Intervencija(brojIntervencije),
    CONSTRAINT FK_Iskoristio_Materijal FOREIGN KEY (sifraMaterijala) REFERENCES Materijal(sifra),
);

CREATE TABLE Dobavljac(
    sifra INT PRIMARY KEY NOT NULL,
    ime VARCHAR(30) NOT NULL,
    sifraMaterijala INT NOT NULL,
    CONSTRAINT FK_Dobavljac_Materijal_sifra FOREIGN KEY (sifraMaterijala) REFERENCES Materijal(sifra),
);

CREATE TABLE Narudzbenica(
    brojNarudzbenice INT NOT NULL PRIMARY KEY,
    datum DATE NOT NULL,
    cenaMaterijala INT NOT NULL,
    kolicina INT NOT NULL,
    sifraDobavljaca INT NOT NULL,
    CONSTRAINT FK_Narudzbenica_Dobavljac_sifra FOREIGN KEY (sifraDobavljaca) REFERENCES Dobavljac(sifra),
);

CREATE TABLE Prijemnica(
    brojPrijemnice INT NOT NULL PRIMARY KEY IDENTITY(1,1),
    sifraMaterijala INT NOT NULL,
    brojNarudzbenice INT NOT NULL,
    CONSTRAINT FK_Prijemnica_Materijal_sifra FOREIGN KEY (sifraMaterijala) REFERENCES Materijal(sifra),
    CONSTRAINT FK_Prijemnica_Narudzbenica_broj FOREIGN KEY (brojNarudzbenice) REFERENCES Narudzbenica(brojNarudzbenice)
);

-- Alter tabels

ALTER TABLE  MedicinskiTehnicar
ADD jmbgZaposlenog VARCHAR(13) NOT NULL,
CONSTRAINT FK_MedicinskiTehnicar_Zaposlen FOREIGN KEY (jmbgZaposlenog) REFERENCES Zaposlen(jmbg);

ALTER TABLE Klijent
ADD idTehnicara INT NOT NULL IDENTITY(1,1),
CONSTRAINT FK_Klijent_Tehnicar_id FOREIGN KEY (idTehnicara) REFERENCES MedicinskiTehnicar(idTehnicara)

ALTER TABLE Materijal 
ADD brojNarudzbenice INT NOT NULL,
CONSTRAINT FK_Materijal_Narudzbenica FOREIGN KEY (brojNarudzbenice) REFERENCES Narudzbenica(brojNarudzbenice);



-- Queries

SELECT ime, prezime, telefon, racun.jmbgKlijenta, usluge.cena 
from Klijent INNER join Racun on Klijent.jmbg = Racun.jmbgKlijenta 
INNER JOIN Intervencija on Racun.brojIntervencije = Intervencija.brojIntervencije 
INNER JOIN Usluge on Intervencija.sifraUsluge = Usluge.sifra WHERE Usluge.cena > 5500;

SELECT Klijent.ime,  Klijent.prezime, Klijent.telefon, Klijent.adresaStana, Klijent.jmbgKlijenta,
CONCAT(Zaposlen.ime, " ", Zaposlen.prezime) as Doktor FROM Zaposleni 
INNER JOIN Doktor on Doktor.jmbg = Zaposlen.jmbg 
INNER JOIN IzvrseniPregled on IzvrseniPregled.jmbg = Doktor.jmbg 
INNER JOIN Intervencija on Intervencija.brojPregleda = IzvrseniPregled.brojPregleda  
INNER JOIN  Racun on Racun.brojRacuna = Intervencija.brojIntervencije 
INNER JOIN Klijent on Racun.jmbgKlijenta = Klijent.jmbg WHERE IzvrseniPregled.datum = '2017.12.15';

DELETE FROM Klijent WHERE telefon LIKE '069%';
UPDATE Dostavljac SET ime = 'Novartis' WHERE ime = 'Galenika';

DELETE FROM ZakazanPregled WHERE datum = '2018-02-18';




