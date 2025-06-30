CREATE TABLE IF NOT EXISTS firma (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    adresse TEXT,
    branche VARCHAR(100),
    ansprechpartner VARCHAR(255),
    email VARCHAR(255) UNIQUE NOT NULL,
    telefon VARCHAR(50),
    einladungsstatus VARCHAR(50) CHECK (einladungsstatus IN ('AUSSTEHEND', 'ZUGESAGT', 'ABGELEHNT', 'BESTÄTIGT')),
    erstelltdatum TIMESTAMP DEFAULT CURRENT_TIMESTAMP
)

CREATE TABLE IF NOT EXISTS veranstaltung (
    id SERIAL PRIMARY KEY,
    titel VARCHAR(255) NOT NULL,
    beschreibung TEXT,
    startzeit TIMESTAMP NOT NULL,
    endzeit TIMESTAMP NOT NULL,
    raum VARCHAR(100),
    maximale_teilnehmer INTEGER,
    zielgruppe VARCHAR(255), -- zum Beispiel "3. Jahrgang, Medientechnik"
    stream_url VARCHAR(255), -- Für Live-Streams
    video_url VARCHAR(255),  -- Für aufgezeichnete Videos
    firma_id INTEGER REFERENCES firma(id),
    CHECK (endzeit > startzeit)
);

CREATE TABLE IF NOT EXISTS teilnehmer (
    id SERIAL PRIMARY KEY,
    vorname VARCHAR(100) NOT NULL,
    nachname VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    klasse VARCHAR(50), -- zum Beispiel "3AHIT"
    registrierungsdatum TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS veranstaltung_teilnahme (
    veranstaltung_id INTEGER REFERENCES veranstaltung(id),
    teilnehmer_id INTEGER REFERENCES teilnehmer(id),
    anwesenheit BOOLEAN DEFAULT FALSE, -- Für Anwesenheitskontrolle
    PRIMARY KEY (veranstaltung_id, teilnehmer_id)
);

CREATE TABLE IF NOT EXISTS feedback (
    id SERIAL PRIMARY KEY,
    veranstaltung_id INTEGER REFERENCES veranstaltung(id),
    teilnehmer_id INTEGER REFERENCES teilnehmer(id),
    bewertung INTEGER CHECK (bewertung BETWEEN 1 AND 5), -- 1-5 Sterne
    kommentar TEXT,
    abgegeben_am TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS ressourcen (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL, -- zum Beispiel "Beamer", "Raum HS1"
    typ VARCHAR(100) NOT NULL,
    status VARCHAR(50) DEFAULT 'VERFÜGBAR',
    reservierungs_start TIMESTAMP,
    reservierungs_ende TIMESTAMP,
    veranstaltung_id INTEGER REFERENCES veranstaltung(id)
);