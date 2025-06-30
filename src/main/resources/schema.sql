-- Lösche alle Tabellen in korrekter Reihenfolge (wichtig!)
DROP TABLE IF EXISTS ressourcen CASCADE;
DROP TABLE IF EXISTS feedback CASCADE;
DROP TABLE IF EXISTS veranstaltung_teilnahme CASCADE;
DROP TABLE IF EXISTS veranstaltung CASCADE;
DROP TABLE IF EXISTS teilnehmer CASCADE;
DROP TABLE IF EXISTS firma CASCADE;

-- Erstelle Tabellen neu
CREATE TABLE firma (
                       id SERIAL PRIMARY KEY,
                       name VARCHAR(255) NOT NULL,
                       adresse TEXT,
                       branche VARCHAR(100),
                       ansprechpartner VARCHAR(255),
                       email VARCHAR(255) UNIQUE NOT NULL,
                       telefon VARCHAR(50),
                       einladungsstatus VARCHAR(50) CHECK (einladungsstatus IN ('AUSSTEHEND', 'ZUGESAGT', 'ABGELEHNT', 'BESTÄTIGT')),
                       erstelltdatum TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE veranstaltung (
                               id SERIAL PRIMARY KEY,
                               titel VARCHAR(255) NOT NULL,
                               beschreibung TEXT,
                               startzeit TIMESTAMP NOT NULL,
                               endzeit TIMESTAMP NOT NULL,
                               raum VARCHAR(100),
                               maximale_teilnehmer INTEGER,
                               zielgruppe VARCHAR(255),
                               stream_url VARCHAR(255),
                               video_url VARCHAR(255),
                               firma_id INTEGER REFERENCES firma(id),
                               CHECK (endzeit > startzeit)
);

CREATE TABLE teilnehmer (
                            id SERIAL PRIMARY KEY,
                            vorname VARCHAR(100) NOT NULL,
                            nachname VARCHAR(100) NOT NULL,
                            email VARCHAR(255) UNIQUE NOT NULL,
                            klasse VARCHAR(50),
                            registrierungsdatum TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE veranstaltung_teilnahme (
                                         veranstaltung_id INTEGER REFERENCES veranstaltung(id) ON DELETE CASCADE,
                                         teilnehmer_id INTEGER REFERENCES teilnehmer(id) ON DELETE CASCADE,
                                         anwesenheit BOOLEAN DEFAULT FALSE,
                                         PRIMARY KEY (veranstaltung_id, teilnehmer_id)
);

CREATE TABLE feedback (
                          id SERIAL PRIMARY KEY,
                          veranstaltung_id INTEGER REFERENCES veranstaltung(id) ON DELETE CASCADE,
                          teilnehmer_id INTEGER REFERENCES teilnehmer(id) ON DELETE CASCADE,
                          bewertung INTEGER CHECK (bewertung BETWEEN 1 AND 5),
                          kommentar TEXT,
                          abgegeben_am TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE ressourcen (
                            id SERIAL PRIMARY KEY,
                            name VARCHAR(255) NOT NULL,
                            typ VARCHAR(100) NOT NULL,
                            status VARCHAR(50) DEFAULT 'VERFÜGBAR',
                            reservierungs_start TIMESTAMP,
                            reservierungs_ende TIMESTAMP,
                            veranstaltung_id INTEGER REFERENCES veranstaltung(id) ON DELETE CASCADE
);