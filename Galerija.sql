CREATE TABLE podtehnika (
	id INT PRIMARY KEY,
	naziv VARCHAR(255) NOT NULL,
	tehnika_id INT NOT NULL
);

CREATE TABLE tehnika (
	id INT PRIMARY KEY,
	naziv VARCHAR(255) NOT NULL
);

CREATE TABLE delovi_slike (
	id INT PRIMARY KEY,
	visina FLOAT NOT NULL,
	sirina FLOAT NOT NULL,
	tehnika_id INT NOT NULL,
	slike_id INT NOT NULL
);

CREATE TABLE slike (
	id INT PRIMARY KEY NOT NULL,
	naziv VARCHAR(255) NOT NULL,
	godina DATE NOT NULL,
	kupac_id INT,
	slikar_id INT NOT NULL
);

CREATE TABLE slikar (
	id INT PRIMARY KEY,
	ime VARCHAR(255) NOT NULL,
	prezime VARCHAR(255) NOT NULL,
	napomena VARCHAR(255)
);

CREATE TABLE izlozene_slike (
	galerija_id INT NOT NULL,
	slike_id INT NOT NULL,
	vreme_trajanja TIME,
	cena FLOAT
);

CREATE TABLE galerija (
	id INT PRIMARY KEY,
	naziv VARCHAR(255) NOT NULL,
	adresa VARCHAR(255) NOT NULL,
	vlasnik_id INT NOT NULL,
	mesto_ptt INT NOT NULL
);

CREATE TABLE vlasnik (
	id INT PRIMARY KEY,
	ime VARCHAR(255) NOT NULL,
	prezime VARCHAR(255) NOT NULL
);

CREATE TABLE mesto (
	ptt INT PRIMARY KEY NOT NULL,
	naziv VARCHAR(255) NOT NULL,
	drzava_oznaka VARCHAR(255) NOT NULL
);


CREATE TABLE drzava (
	oznaka VARCHAR(255) PRIMARY KEY,
	naziv VARCHAR(255) NOT NULL
);


CREATE TABLE kupac (
	id INT PRIMARY KEY,
	br_tel VARCHAR(255),
	mesto_ptt INT NOT NULL
);

CREATE TABLE pravno_lice (
	pib INT PRIMARY KEY,
	naziv VARCHAR(255) NOT NULL,
	faks VARCHAR(255),
	kupac_id INT NOT NULL
);

CREATE TABLE fizicko_lice (
	br_lk VARCHAR(255) PRIMARY KEY,
	ime VARCHAR(255) NOT NULL,
	prezime VARCHAR(255) NOT NULL,
	kupac_id INT NOT NULL
);

ALTER TABLE podtehnika
	ADD 
		CONSTRAINT FK_podtehnika_tehnika
		FOREIGN KEY (tehnika_id)
		REFERENCES tehnika(id)
		ON UPDATE CASCADE
		ON DELETE CASCADE;

ALTER TABLE delovi_slike
	ADD
		CONSTRAINT FK_delovi_slike_tehnika
		FOREIGN KEY (tehnika_id)
		REFERENCES tehnika(id)
		ON UPDATE CASCADE
		ON DELETE CASCADE,

		CONSTRAINT FK_delovi_slike_slike
		FOREIGN KEY (slike_id)
		REFERENCES slike(id)
		ON UPDATE CASCADE
		ON DELETE CASCADE;

ALTER TABLE slike 
	ADD 
		CONSTRAINT FK_slike_kupac
		FOREIGN KEY (kupac_id)
		REFERENCES kupac(id)
		ON UPDATE CASCADE
		ON DELETE CASCADE,

		CONSTRAINT FK_slike_slikar
		FOREIGN KEY (slikar_id)
		REFERENCES slikar(id)
		ON UPDATE CASCADE
		ON DELETE CASCADE;

ALTER TABLE izlozene_slike
	ADD 
		CONSTRAINT FK_izlozene_slike_galerija
		FOREIGN KEY (galerija_id)
		REFERENCES galerija(id)
		ON UPDATE CASCADE
		ON DELETE CASCADE,

		CONSTRAINT FK_izlozene_slike_slike
		FOREIGN KEY (slike_id)
		REFERENCES slike(id)
		ON UPDATE CASCADE
		ON DELETE CASCADE,

		CONSTRAINT PK_izlozene_slike
		PRIMARY KEY (galerija_id, slike_id);

ALTER TABLE galerija
	ADD 
		CONSTRAINT FK_galerija_vlasnik
		FOREIGN KEY (vlasnik_id)
		REFERENCES vlasnik(id)
		ON UPDATE CASCADE
		ON DELETE CASCADE,

		CONSTRAINT FK_galerija_mesto
		FOREIGN KEY (mesto_ptt)
		REFERENCES mesto(ptt)
		ON UPDATE CASCADE
		ON DELETE CASCADE;

ALTER TABLE mesto
	ADD
		CONSTRAINT FK_mesto_drzava
		FOREIGN KEY (drzava_oznaka)
		REFERENCES drzava(oznaka)
		ON UPDATE CASCADE
		ON DELETE CASCADE;

ALTER TABLE kupac
	ADD 
		CONSTRAINT FK_kupac_mesto
		FOREIGN KEY (mesto_ptt)
		REFERENCES mesto(ptt);

ALTER TABLE pravno_lice
	ADD 
		CONSTRAINT FK_pravno_lice_kupac
		FOREIGN KEY (kupac_id)
		REFERENCES kupac(id)
		ON UPDATE CASCADE
		ON DELETE CASCADE;

ALTER TABLE fizicko_lice
	ADD
		CONSTRAINT FK_kupac_fizicko_lice
		FOREIGN KEY (kupac_id)
		REFERENCES kupac(id)
		ON UPDATE CASCADE
		ON DELETE CASCADE;