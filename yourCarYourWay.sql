CREATE DATABASE yourCarYourWay5;

USE yourCarYourWay5;

-- Table des agences de location
CREATE TABLE Agency (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    address VARCHAR(255),
    city VARCHAR(100),
    postcode VARCHAR(20),
    country VARCHAR(100),
    phone VARCHAR(50) UNIQUE,
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Table des langues
CREATE TABLE Language (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) UNIQUE NOT NULL,
    code VARCHAR(10) UNIQUE NOT NULL
);

-- Table des utilisateurs avec rôle unique
CREATE TABLE User (
    id INT PRIMARY KEY AUTO_INCREMENT,
    firstname VARCHAR(100),
    lastname VARCHAR(100),
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    address VARCHAR(255),
    phone VARCHAR(50) UNIQUE,
    role ENUM('client', 'employee', 'admin') DEFAULT 'client' NOT NULL,
    has_driving_license BOOLEAN DEFAULT FALSE,
    agency_id INT NULL, -- Pour les employés uniquement
    language_id INT,
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (agency_id) REFERENCES Agency(id) ON DELETE SET NULL,
    FOREIGN KEY (language_id) REFERENCES Language(id) ON DELETE SET NULL
);

-- Table des véhicules
CREATE TABLE Vehicle (
    id INT PRIMARY KEY AUTO_INCREMENT,
    category VARCHAR(100),
    model VARCHAR(100),
    brand VARCHAR(100),
    plate_number VARCHAR(50) UNIQUE,
    fuel_type ENUM('diesel', 'electric', 'hybrid', 'petrol'),
    transmission ENUM('manual', 'automatic'),
    mileage INT,
    availability BOOLEAN DEFAULT TRUE,
    agency_id INT,
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (agency_id) REFERENCES Agency(id) ON DELETE CASCADE
);

-- Table des offres de location
CREATE TABLE RentalOffer (
    id INT PRIMARY KEY AUTO_INCREMENT,
    vehicle_id INT,
    price DECIMAL(10,2) NOT NULL,
    description TEXT,
    available_from TIMESTAMP NOT NULL,
    available_to TIMESTAMP NOT NULL,
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (vehicle_id) REFERENCES Vehicle(id) ON DELETE CASCADE
);

-- Table des réservations
CREATE TABLE Reservation (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    offer_id INT,
    agency_pickup_id INT,
    agency_dropoff_id INT,
    date_start TIMESTAMP NOT NULL,
    date_end TIMESTAMP NOT NULL,
    status ENUM('pending', 'confirmed', 'cancelled') DEFAULT 'pending',
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES User(id) ON DELETE CASCADE,
    FOREIGN KEY (offer_id) REFERENCES RentalOffer(id) ON DELETE CASCADE,
    FOREIGN KEY (agency_pickup_id) REFERENCES Agency(id) ON DELETE CASCADE,
    FOREIGN KEY (agency_dropoff_id) REFERENCES Agency(id) ON DELETE CASCADE
);

-- Table des paiements
CREATE TABLE Payment (
    id INT PRIMARY KEY AUTO_INCREMENT,
    reservation_id INT UNIQUE,
    amount DECIMAL(10,2) NOT NULL,
    status ENUM('paid', 'failed', 'pending') DEFAULT 'pending',
    payment_method ENUM('credit_card', 'paypal', 'bank_transfer'),
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (reservation_id) REFERENCES Reservation(id) ON DELETE CASCADE
);

-- Table des factures
CREATE TABLE Invoice (
    id INT PRIMARY KEY AUTO_INCREMENT,
    reservation_id INT UNIQUE,
    amount DECIMAL(10,2) NOT NULL,
    file_pdf VARCHAR(255),
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (reservation_id) REFERENCES Reservation(id) ON DELETE CASCADE
);

-- Table des avis
CREATE TABLE Review (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    vehicle_id INT,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    comment TEXT,
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES User(id) ON DELETE CASCADE,
    FOREIGN KEY (vehicle_id) REFERENCES Vehicle(id) ON DELETE CASCADE
);

-- Table des conversations (Chat entre Employé et Client)
CREATE TABLE Conversation (
    id INT PRIMARY KEY AUTO_INCREMENT,
    client_id INT,
    employee_id INT,
    status ENUM('open', 'closed') DEFAULT 'open',
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (client_id) REFERENCES User(id) ON DELETE CASCADE,
    FOREIGN KEY (employee_id) REFERENCES User(id) ON DELETE CASCADE
);

-- Table des messages de chat
CREATE TABLE ChatMessage (
    id INT PRIMARY KEY AUTO_INCREMENT,
    conversation_id INT,
    sender_id INT,
    message TEXT NOT NULL,
    sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (conversation_id) REFERENCES Conversation(id) ON DELETE CASCADE,
    FOREIGN KEY (sender_id) REFERENCES User(id) ON DELETE CASCADE
);

-- Insertion des données pour tester toutes les tables
INSERT INTO Language (name, code) VALUES ('Français', 'FR'), ('English', 'EN'), ('Español', 'ES'), ('Deutsch', 'DE'), ('Italiano', 'IT'), ('Português', 'PT');
INSERT INTO Agency (name, address, city, postcode, country, phone) VALUES ('Agence Centrale', '45 Rue de Paris', 'Paris', '75001', 'France', '0145678910');
INSERT INTO User (firstname, lastname, email, password, address, phone, role, has_driving_license, agency_id, language_id) VALUES 
('John', 'Doe', 'johndoe@email.com', 'hashedpassword', '123 Main St', '1234567890', 'client', TRUE, NULL, 1),
('Alice', 'Smith', 'alice@email.com', 'hashedpassword', '456 Elm St', '0987654321', 'employee', FALSE, 1, 1),
('Bob', 'Admin', 'admin@email.com', 'hashedpassword', '789 Oak St', '1122334455', 'admin', FALSE, NULL, 1);
INSERT INTO Vehicle (category, model, brand, plate_number, fuel_type, transmission, mileage, availability, agency_id) VALUES
('SUV', 'Tiguan', 'Volkswagen', 'AB-123-CD', 'diesel', 'automatic', 50000, TRUE, 1),
('SUV', 'Q3', 'Audi', 'XY-987-ZT', 'petrol', 'automatic', 30000, TRUE, 1),
('Sedan', 'Model 3', 'Tesla', 'EV-456-RT', 'electric', 'automatic', 15000, TRUE, 1),
('Hatchback', 'Clio', 'Renault', 'GH-321-PL', 'petrol', 'manual', 40000, TRUE, 1);
INSERT INTO RentalOffer (vehicle_id, price, description, available_from, available_to) VALUES (1, 299.99, 'Offre spéciale', NOW(), DATE_ADD(NOW(), INTERVAL 30 DAY));
INSERT INTO Reservation (user_id, offer_id, agency_pickup_id, agency_dropoff_id, date_start, date_end, status) VALUES (1, 1, 1, 1, NOW(), DATE_ADD(NOW(), INTERVAL 7 DAY), 'confirmed');
INSERT INTO Payment (reservation_id, amount, status, payment_method) VALUES (1, 299.99, 'paid', 'credit_card');
INSERT INTO Invoice (reservation_id, amount, file_pdf) VALUES (1, 299.99, 'facture_1.pdf');
INSERT INTO Review (user_id, vehicle_id, rating, comment) VALUES (1, 1, 5, 'Super voiture, très propre !');
INSERT INTO Conversation (client_id, employee_id, status) VALUES (1, 2, 'open');
INSERT INTO ChatMessage (conversation_id, sender_id, message) VALUES (1, 1, 'Bonjour, j’ai une question sur ma réservation.'), (1, 2, 'Bonjour, comment puis-je vous aider ?');


SELECT * FROM Agency;
SELECT * FROM Language;
SELECT * FROM User;
SELECT * FROM Vehicle;
SELECT * FROM RentalOffer;
SELECT * FROM Reservation;
SELECT * FROM Payment;
SELECT * FROM Invoice;
SELECT * FROM Review;
SELECT * FROM Conversation;
SELECT * FROM ChatMessage;
