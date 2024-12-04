-- 1. Kupac
CREATE TABLE Kupac (
    ID_Kupca NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    Ime VARCHAR2(50) NOT NULL,
    Prezime VARCHAR2(50) NOT NULL,
    Kontakt VARCHAR2(20),
    Email VARCHAR2(100) UNIQUE,
    Adresa VARCHAR2(200)
);

-- 2. Zaposleni
CREATE TABLE Zaposleni (
    ID_Zaposlenog NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    Ime VARCHAR2(50) NOT NULL,
    Prezime VARCHAR2(50) NOT NULL,
    Pozicija VARCHAR2(50),
    Plata NUMBER(10, 2),
    Datum_Zaposlenja DATE,
    Kontakt VARCHAR2(20)
);

-- 3. Vozilo
CREATE TABLE Vozilo (
    ID_Vozila NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    Sasija VARCHAR2(50) NOT NULL UNIQUE,
    Marka VARCHAR2(50) NOT NULL,
    Model VARCHAR2(50) NOT NULL,
    Godina_Proizvodnje NUMBER(4) NOT NULL,
    Kilometraza NUMBER,
    Gorivo VARCHAR2(20),
    Snaga NUMBER,
    Cena NUMBER(10, 2),
    Status VARCHAR2(20) CHECK (Status IN ('Na prodaju', 'Rezervisano', 'Prodato'))
);

-- 4. KategorijaVozila
CREATE TABLE KategorijaVozila (
    ID_Kategorije NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    Naziv VARCHAR2(50) NOT NULL
);

-- 5. Dobavljac
CREATE TABLE Dobavljac (
    ID_Dobavljaca NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    Naziv VARCHAR2(100) NOT NULL,
    Kontakt VARCHAR2(20),
    Adresa VARCHAR2(200)
);

-- 6. Oprema
CREATE TABLE Oprema (
    ID_Opreme NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    Naziv VARCHAR2(50) NOT NULL,
    Opis VARCHAR2(200)
);

-- 7. Prodaja
CREATE TABLE Prodaja (
    ID_Prodaje NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    ID_Vozila NUMBER NOT NULL,
    ID_Kupca NUMBER NOT NULL,
    ID_Zaposlenog NUMBER NOT NULL,
    Datum_Prodaje DATE NOT NULL,
    Cena NUMBER(10, 2) NOT NULL,
    Nacin_Plate VARCHAR2(20) CHECK (Nacin_Plate IN ('Gotovina', 'Kredit', 'Leasing')),
    FOREIGN KEY (ID_Vozila) REFERENCES Vozilo(ID_Vozila),
    FOREIGN KEY (ID_Kupca) REFERENCES Kupac(ID_Kupca),
    FOREIGN KEY (ID_Zaposlenog) REFERENCES Zaposleni(ID_Zaposlenog)
);

-- 8. Placanje
CREATE TABLE Placanje (
    ID_Placanja NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    ID_Prodaje NUMBER NOT NULL,
    Iznos NUMBER(10, 2) NOT NULL,
    Tip_Placanja VARCHAR2(20) CHECK (Tip_Placanja IN ('Gotovina', 'Kartica', 'Transfer')),
    FOREIGN KEY (ID_Prodaje) REFERENCES Prodaja(ID_Prodaje)
);

-- 9. Nabavka
CREATE TABLE Nabavka (
    ID_Nabavke NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    ID_Dobavljaca NUMBER NOT NULL,
    Datum DATE NOT NULL,
    Ukupna_Cena NUMBER(10, 2),
    FOREIGN KEY (ID_Dobavljaca) REFERENCES Dobavljac(ID_Dobavljaca)
);

-- 10. NabavkaVozila
CREATE TABLE NabavkaVozila (
    ID_Nabavke NUMBER NOT NULL,
    ID_Vozila NUMBER NOT NULL,
    PRIMARY KEY (ID_Nabavke, ID_Vozila),
    FOREIGN KEY (ID_Nabavke) REFERENCES Nabavka(ID_Nabavke),
    FOREIGN KEY (ID_Vozila) REFERENCES Vozilo(ID_Vozila)
);

-- 11. NabavkaDelova
CREATE TABLE NabavkaDelova (
    ID_Nabavke NUMBER NOT NULL,
    ID_Dela NUMBER NOT NULL,
    PRIMARY KEY (ID_Nabavke, ID_Dela),
    FOREIGN KEY (ID_Nabavke) REFERENCES Nabavka(ID_Nabavke),
    FOREIGN KEY (ID_Dela) REFERENCES RezervniDelovi(ID_Dela)
);

-- 12. VoziloKategorija
CREATE TABLE VoziloKategorija (
    ID_Vozila NUMBER NOT NULL,
    ID_Kategorije NUMBER NOT NULL,
    PRIMARY KEY (ID_Vozila, ID_Kategorije),
    FOREIGN KEY (ID_Vozila) REFERENCES Vozilo(ID_Vozila),
    FOREIGN KEY (ID_Kategorije) REFERENCES KategorijaVozila(ID_Kategorije)
);

-- 13. VoziloOprema
CREATE TABLE VoziloOprema (
    ID_Vozila NUMBER NOT NULL,
    ID_Opreme NUMBER NOT NULL,
    PRIMARY KEY (ID_Vozila, ID_Opreme),
    FOREIGN KEY (ID_Vozila) REFERENCES Vozilo(ID_Vozila),
    FOREIGN KEY (ID_Opreme) REFERENCES Oprema(ID_Opreme)
);

-- 14. Servis
CREATE TABLE Servis (
    ID_Servisa NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    ID_Vozila NUMBER NOT NULL,
    ID_Zaposlenog NUMBER,
    Datum DATE NOT NULL,
    Opis VARCHAR2(500),
    Cena NUMBER(10, 2),
    FOREIGN KEY (ID_Vozila) REFERENCES Vozilo(ID_Vozila),
    FOREIGN KEY (ID_Zaposlenog) REFERENCES Zaposleni(ID_Zaposlenog)
);

-- 15. RezervniDelovi
CREATE TABLE RezervniDelovi (
    ID_Dela NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    Naziv VARCHAR2(50) NOT NULL,
    Cena NUMBER(10, 2),
    Zaliha NUMBER
);

-- 16. ZakazivanjeServisa
CREATE TABLE ZakazivanjeServisa (
    ID_Termina NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    ID_Vozila NUMBER NOT NULL,
    ID_Zaposlenog NUMBER NOT NULL,
    Datum DATE NOT NULL,
    FOREIGN KEY (ID_Vozila) REFERENCES Vozilo(ID_Vozila),
    FOREIGN KEY (ID_Zaposlenog) REFERENCES Zaposleni(ID_Zaposlenog)
);

-- 17. MarketingKampanja
CREATE TABLE MarketingKampanja (
    ID_Kampanje NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    Naziv VARCHAR2(100) NOT NULL,
    Pocetak DATE NOT NULL,
    Kraj DATE NOT NULL,
    Budzet NUMBER(10, 2)
);

-- 18. Promocija
CREATE TABLE Promocija (
    ID_Kampanje NUMBER NOT NULL,
    ID_Vozila NUMBER NOT NULL,
    ProcenatPopusta NUMBER(3, 2) CHECK (ProcenatPopusta BETWEEN 0 AND 100),
    PRIMARY KEY (ID_Kampanje, ID_Vozila),
    FOREIGN KEY (ID_Kampanje) REFERENCES MarketingKampanja(ID_Kampanje),
    FOREIGN KEY (ID_Vozila) REFERENCES Vozilo(ID_Vozila)
);

-- 19. Popusti
CREATE TABLE Popusti (
    ID_Popusta NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    ID_Kupca NUMBER NOT NULL,
    ID_Kampanje NUMBER NOT NULL,
    ProcenatPopusta NUMBER(3, 2) CHECK (ProcenatPopusta BETWEEN 0 AND 100),
    FOREIGN KEY (ID_Kupca) REFERENCES Kupac(ID_Kupca),
    FOREIGN KEY (ID_Kampanje) REFERENCES MarketingKampanja(ID_Kampanje)
);

-- 20. Transport
CREATE TABLE Transport (
    ID_Transporta NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    ID_Vozila NUMBER NOT NULL,
    Destinacija VARCHAR2(200) NOT NULL,
    Datum DATE NOT NULL,
    CenaTransporta NUMBER(10, 2),
    FOREIGN KEY (ID_Vozila) REFERENCES Vozilo(ID_Vozila)
);

-- 21. Osiguranje
CREATE TABLE Osiguranje (
    ID_Osiguranja NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    ID_Vozila NUMBER NOT NULL,
    ID_Osiguravaca NUMBER NOT NULL,
    DatumPocetka DATE NOT NULL,
    DatumIsteka DATE NOT NULL,
    CenaOsiguranja NUMBER(10, 2),
    FOREIGN KEY (ID_Vozila) REFERENCES Vozilo(ID_Vozila),
    FOREIGN KEY (ID_Osiguravaca) REFERENCES Osiguravaci(ID_Osiguravaca)
);

-- 22. Osiguravaci
CREATE TABLE Osiguravaci (
    ID_Osiguravaca NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    Naziv VARCHAR2(100) NOT NULL,
    Kontakt VARCHAR2(20),
    Adresa VARCHAR2(200)
);

-- 23. TestVoznja
CREATE TABLE TestVoznja (
    ID_TestVoznje NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    ID_Vozila NUMBER NOT NULL,
    ID_Kupca NUMBER NOT NULL,
    ID_Zaposlenog NUMBER NOT NULL,
    Datum DATE NOT NULL,
    Komentar VARCHAR2(500),
    FOREIGN KEY (ID_Vozila) REFERENCES Vozilo(ID_Vozila),
    FOREIGN KEY (ID_Kupca) REFERENCES Kupac(ID_Kupca),
    FOREIGN KEY (ID_Zaposlenog) REFERENCES Zaposleni(ID_Zaposlenog)
);

-- 24. Rezervacija
CREATE TABLE Rezervacija (
    ID_Rezervacije NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    ID_Kupca NUMBER NOT NULL,
    ID_Vozila NUMBER NOT NULL,
    Datum DATE NOT NULL,
    Status VARCHAR2(20) CHECK (Status IN ('Aktivna', 'Otkazana', 'Završena')),
    FOREIGN KEY (ID_Kupca) REFERENCES Kupac(ID_Kupca),
    FOREIGN KEY (ID_Vozila) REFERENCES Vozilo(ID_Vozila)
);

-- 25. Logovi
CREATE TABLE Logovi (
    ID_Loga NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    TipAktivnosti VARCHAR2(50),
    Opis VARCHAR2(500),
    Datum DATE DEFAULT SYSDATE
);

-- 26. PoreskeStope
CREATE TABLE PoreskeStope (
    ID_Stope NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    TipTransakcije VARCHAR2(50),
    ProcenaPoreza NUMBER(5, 2) CHECK (ProcenaPoreza BETWEEN 0 AND 100)
);

-- 27. ServisDelovi
CREATE TABLE ServisDelovi (
    ID_Servisa NUMBER NOT NULL,
    ID_Dela NUMBER NOT NULL,
    Kolicina NUMBER NOT NULL,
    PRIMARY KEY (ID_Servisa, ID_Dela),
    FOREIGN KEY (ID_Servisa) REFERENCES Servis(ID_Servisa),
    FOREIGN KEY (ID_Dela) REFERENCES RezervniDelovi(ID_Dela)
);

-- 28. ZakazivanjeDelova
CREATE TABLE ZakazivanjeDelova (
    ID_Termina NUMBER NOT NULL,
    ID_Dela NUMBER NOT NULL,
    Kolicina NUMBER NOT NULL,
    PRIMARY KEY (ID_Termina, ID_Dela),
    FOREIGN KEY (ID_Termina) REFERENCES ZakazivanjeServisa(ID_Termina),
    FOREIGN KEY (ID_Dela) REFERENCES RezervniDelovi(ID_Dela)
);