CREATE TABLE automehanicar (
	maticni_broj VARCHAR(13) PRIMARY KEY,
	ime VARCHAR(255) NOT NULL,
	prezime VARCHAR(255) NOT NULL,
	strucna_sprema VARCHAR(255) NOT NULL,
	br_tel VARCHAR(255)
);

CREATE TABLE uradjeno (
	id INT PRIMARY KEY,
	servisna_usluga_sifra INT NOT NULL,
	automehanicar_maticni_broj VARCHAR(13) NOT NULL,
	autobus_registarski_broj INT NOT NULL,
	datum DATE NOT NULL
);

CREATE TABLE servisna_usluga (
	sifra INT PRIMARY KEY,
	naziv VARCHAR(255) NOT NULL,
	br_god INT NOT NULL
);

CREATE TABLE autobus (
	registarski_broj INT PRIMARY KEY,
	tip VARCHAR(255),
	godNabavke DATE NOT NULL,
	aktivan TINYINT,
	autobuska_linija_sifra INT NOT NULL
);

CREATE TABLE vozac (
	maticni_broj VARCHAR(13) PRIMARY KEY,
	ime VARCHAR(255) NOT NULL,
	prezime VARCHAR(255) NOT NULL,
	adresa VARCHAR(255) NOT NULL,
	telefon VARCHAR(255),
	autobus_registarski_broj INT
);

CREATE TABLE autobuska_linija (
	sifra INT PRIMARY KEY,
	polazna_stanica VARCHAR(255),
	krajnja_stanica VARCHAR(255),
	trajanje_voznje TIME
);

CREATE TABLE potrebni_deo (
	id INT PRIMARY KEY,
	servisna_usluga_sifra INT NOT NULL,
	rezervni_deo_sifra INT NOT NULL,
	potrebna_kolicina FLOAT NOT NULL
);

CREATE TABLE rezervni_deo (
	sifra INT PRIMARY KEY,
	naziv VARCHAR(255) NOT NULL,
	min_zalihe FLOAT,
	zalihe FLOAT,
	jedinica_mere VARCHAR(255)
);

CREATE TABLE zamena (
	original_sifra INT NOT NULL,
	zamena_sifra INT NOT NULL
);

CREATE TABLE koriscen (
	uradjeno_id INT NOT NULL,
	potrebni_deo_id INT NOT NULL,
	potrosena_kolicina FLOAT
)

ALTER TABLE zamena 
	ADD 
		CONSTRAINT FK_zamena_original
		FOREIGN KEY (original_sifra)
		REFERENCES rezervni_deo(sifra),

		CONSTRAINT FK_zamena_zamena
		FOREIGN KEY (zamena_sifra)
		REFERENCES rezervni_deo(sifra),
		
		CONSTRAINT PK_zamena
		PRIMARY KEY (original_sifra, zamena_sifra);

ALTER TABLE potrebni_deo
	ADD
		CONSTRAINT FK_potrebni_deo_servisna_usluga
		FOREIGN KEY (servisna_usluga_sifra)
		REFERENCES servisna_usluga(sifra),

		CONSTRAINT FK_potrebni_deo_rezervni_deo
		FOREIGN KEY (rezervni_deo_sifra)
		REFERENCES rezervni_deo(sifra);

ALTER TABLE vozac 
	ADD 
		CONSTRAINT FK_vozac_autobus
		FOREIGN KEY (autobus_registarski_broj)
		REFERENCES autobus(registarski_broj);

ALTER TABLE autobus
	ADD
		CONSTRAINT FK_autobus_autobuska_linija
		FOREIGN KEY (autobuska_linija_sifra)
		REFERENCES autobuska_linija(sifra);

ALTER TABLE uradjeno
	ADD
		CONSTRAINT FK_uradjeno_servisna_usluga
		FOREIGN KEY (servisna_usluga_sifra)
		REFERENCES servisna_usluga(sifra),

		CONSTRAINT FK_uradjeno_automehanicar
		FOREIGN KEY (automehanicar_maticni_broj)
		REFERENCES automehanicar(maticni_broj),

		CONSTRAINT FK_uradjeno_autobus
		FOREIGN KEY (autobus_registarski_broj)
		REFERENCES autobus(registarski_broj);

ALTER TABLE koriscen
	ADD 
		CONSTRAINT FK_koriscen_uradjeno
		FOREIGN KEY (uradjeno_id)
		REFERENCES uradjeno(id),

		CONSTRAINT FK_koriscen_potrebni_deo
		FOREIGN KEY (potrebni_deo_id)
		REFERENCES potrebni_deo(id),

		CONSTRAINT PK_koriscen
		PRIMARY KEY (uradjeno_id, potrebni_deo_id);