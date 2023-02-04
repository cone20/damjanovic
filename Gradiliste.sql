CREATE DATABASE gradiliste;

USE gradiliste;

CREATE TABLE gradiliste (
	sifra INT PRIMARY KEY,
	naziv VARCHAR(255) NOT NULL,
	vrsta_objekta VARCHAR(255) NOT NULL,
	broj_masina INT NOT NULL,
	sef_gradilista VARCHAR(255) NOT NULL,
	projektant_objekta VARCHAR(255) NOT NULL,
	datum_pocetka DATE,
	rok_zavrsetka DATE
);

CREATE TABLE radnik (
	maticni_broj VARCHAR(13) PRIMARY KEY,
	ime VARCHAR(255) NOT NULL,
	prezime VARCHAR(255) NOT NULL
);

CREATE TABLE rad_angazovan (
	gradiliste_sifra INT NOT NULL,
	radnik_maticni_broj VARCHAR(13) NOT NULL,
	broj_casova_rada INT,
	broj_casova_rada_na_masini INT,
	datum_pocetka DATE,
	trajanje_angazmana TIME,
	status TINYINT
);

CREATE TABLE masina (
	registracioni_broj INT PRIMARY KEY,
	naziv VARCHAR(255) NOT NULL,
	datum_nabavke DATE,
	cena_nabavke FLOAT,
	amortizovana_vrednost FLOAT,
	tip_masine_id INT,
);

CREATE TABLE mas_angazovan (
	gradiliste_sifra INT NOT NULL,
	masina_registracioni_broj INT NOT NULL,
	status TINYINT,
	trajanje_angazmana TIME NOT NULL,
	datum_pocetka_angazmana DATETIME

	
);

CREATE TABLE tip_masine (
	id INT PRIMARY KEY,
	naziv VARCHAR(255) NOT NULL,
	broj_masina INT NOT NULL,
	vreme_montaze DATETIME,
	vreme_demontaze DATETIME,
	inventarni_broj INT,	
);

CREATE TABLE obucen (
	radnik_maticni_broj VARCHAR(13) NOT NULL,
	tip_masine_id INT NOT NULL,
	naziv VARCHAR(255)
);

ALTER TABLE rad_angazovan
	ADD 
		CONSTRAINT FK_rad_angazovan_gradiliste
		FOREIGN KEY (gradiliste_sifra)
		REFERENCES gradiliste(sifra)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
		
		CONSTRAINT FK_rad_angazovan_radnik
		FOREIGN KEY (radnik_maticni_broj)
		REFERENCES radnik(maticni_broj)
		ON DELETE CASCADE
		ON UPDATE CASCADE,

		CONSTRAINT PK_rad_angazovan
		PRIMARY KEY (gradiliste_sifra, radnik_maticni_broj);

ALTER TABLE obucen
	ADD 
		CONSTRAINT FK_obucen_radnik
		FOREIGN KEY (radnik_maticni_broj)
		REFERENCES radnik(maticni_broj)
		ON DELETE CASCADE
		ON UPDATE CASCADE,

		CONSTRAINT FK_obucen_tip_masine
		FOREIGN KEY (tip_masine_id)
		REFERENCES tip_masine(id)
		ON DELETE CASCADE
		ON UPDATE CASCADE,

		CONSTRAINT PK_obucen
		PRIMARY KEY(radnik_maticni_broj, tip_masine_id);

ALTER TABLE masina
	ADD
		CONSTRAINT FK_masina_tip_masine
		FOREIGN KEY (tip_masine_id)
		REFERENCES tip_masine(id)
		ON DELETE CASCADE
		ON UPDATE CASCADE;

ALTER TABLE mas_angazovan
	ADD
		CONSTRAINT FK_mas_angazovan_gradiliste
		FOREIGN KEY (gradiliste_sifra)
		REFERENCES gradiliste(sifra)
		ON DELETE CASCADE
		ON UPDATE CASCADE,

		CONSTRAINT FK_mas_angazovan_masina
		FOREIGN KEY (masina_registracioni_broj)
		REFERENCES masina(registracioni_broj)
		ON DELETE CASCADE
		ON UPDATE CASCADE,

		CONSTRAINT PK_mas_angazovan
		PRIMARY KEY (gradiliste_sifra, masina_registracioni_broj);