CREATE DATABASE yourCarYourWay2;

USE yourCarYourWay2;

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

CREATE TABLE User (
    id INT PRIMARY KEY AUTO_INCREMENT,
    firstname VARCHAR(100),
    lastname VARCHAR(100),
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    address VARCHAR(255),
    phone VARCHAR(50) UNIQUE,
    has_driving_license BOOLEAN DEFAULT FALSE,
    role ENUM('admin', 'manager', 'client', 'user') DEFAULT 'user' NOT NULL,
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE Admin (
    id INT PRIMARY KEY AUTO_INCREMENT,
    agency_id INT,
    user_id INT,
    firstname VARCHAR(100),
    lastname VARCHAR(100),
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role ENUM('superadmin', 'manager') DEFAULT 'manager' NOT NULL,
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (agency_id) REFERENCES Agency(id) ON DELETE SET NULL,
    FOREIGN KEY (user_id) REFERENCES User(id) ON DELETE CASCADE
);

CREATE TABLE Reservation (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    vehicle_id INT,
    agency_pickup_id INT,
    agency_dropoff_id INT,
    city_pickup VARCHAR(100),
    city_dropoff VARCHAR(100),
    date_start TIMESTAMP NOT NULL,
    date_end TIMESTAMP NOT NULL,
    status ENUM('pending', 'confirmed', 'cancelled') DEFAULT 'pending',
    price DECIMAL(10,2),
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES User(id) ON DELETE CASCADE,
    FOREIGN KEY (vehicle_id) REFERENCES Vehicle(id) ON DELETE CASCADE,
    FOREIGN KEY (agency_pickup_id) REFERENCES Agency(id) ON DELETE CASCADE,
    FOREIGN KEY (agency_dropoff_id) REFERENCES Agency(id) ON DELETE CASCADE
);

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

CREATE TABLE Invoice (
    id INT PRIMARY KEY AUTO_INCREMENT,
    reservation_id INT UNIQUE,
    amount DECIMAL(10,2) NOT NULL,
    file_pdf VARCHAR(255),
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (reservation_id) REFERENCES Reservation(id) ON DELETE CASCADE
);

CREATE TABLE Contract (
    id INT PRIMARY KEY AUTO_INCREMENT,
    reservation_id INT UNIQUE,
    date_signed TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    file_pdf VARCHAR(255),
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (reservation_id) REFERENCES Reservation(id) ON DELETE CASCADE
);

CREATE TABLE Support (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    message TEXT NOT NULL,
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    type ENUM('chat', 'email') NOT NULL,
    FOREIGN KEY (user_id) REFERENCES User(id) ON DELETE CASCADE
);

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

CREATE TABLE Notification (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    message TEXT NOT NULL,
    type ENUM('email', 'SMS', 'push') NOT NULL,
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES User(id) ON DELETE CASCADE
);

CREATE TABLE Conversation (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    agent_id INT,
    status ENUM('open', 'closed') DEFAULT 'open',
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES User(id) ON DELETE CASCADE,
    FOREIGN KEY (agent_id) REFERENCES Admin(id) ON DELETE CASCADE
);

CREATE TABLE Chat (
    id INT PRIMARY KEY AUTO_INCREMENT,
    conversation_id INT,
    user_id INT,
    message TEXT NOT NULL,
    date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (conversation_id) REFERENCES Conversation(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES User(id) ON DELETE CASCADE
);

SHOW TABLES;

DESC Admin;
DESC Agency;
DESC Chat;
DESC Contract;
DESC Conversation;
DESC Invoice;
DESC Notification;
DESC Payment;
DESC Reservation;
DESC Review;
DESC Support;
DESC User;
DESC Vehicle;

-- TEST --

INSERT INTO User (firstname, lastname, email, password, address, phone, has_driving_license, role, createdAt, updatedAt)
VALUES ('John', 'Doe', 'johndoe@email.com', 'hashedpassword', '123 Main Street', '1234567890', TRUE, 'client', NOW(), NOW());

INSERT INTO Agency (name, address, city, postcode, country, phone, createdAt, updatedAt)
VALUES ('Agence Centrale', '45 Rue de Paris', 'Paris', '75001', 'France', '0145678910', NOW(), NOW());

INSERT INTO Vehicle (category, model, brand, plate_number, fuel_type, transmission, mileage, availability, agency_id, createdAt, updatedAt)
VALUES ('SUV', 'Tiguan', 'Volkswagen', 'AB-123-CD', 'diesel', 'automatic', 50000, TRUE, 1, NOW(), NOW());

INSERT INTO Reservation (user_id, vehicle_id, agency_pickup_id, agency_dropoff_id, city_pickup, city_dropoff, date_start, date_end, status, price, createdAt, updatedAt) 
VALUES (1, 1, 1, 1, 'Paris', 'Lyon', '2025-03-20 10:00:00', '2025-03-25 10:00:00', 'pending', 299.99, NOW(), NOW());

INSERT INTO Payment (reservation_id, amount, status, payment_method, createdAt, updatedAt) 
VALUES (1, 299.99, 'paid', 'credit_card', NOW(), NOW());

INSERT INTO Invoice (reservation_id, amount, file_pdf, createdAt) 
VALUES (1, 299.99, 'invoice_1.pdf', NOW());

INSERT INTO Contract (reservation_id, file_pdf, createdAt) 
VALUES (1, 'contract_1.pdf', NOW());

INSERT INTO Support (user_id, message, type, createdAt) 
VALUES (1, 'J’ai une question sur ma réservation.', 'chat', NOW());

INSERT INTO Notification (user_id, message, type, createdAt) 
VALUES (1, 'Votre réservation a été confirmée.', 'email', NOW());

INSERT INTO Review (user_id, vehicle_id, rating, comment, createdAt) 
VALUES (1, 1, 5, 'Super expérience, voiture impeccable !', NOW());

INSERT INTO Admin (agency_id, user_id, firstname, lastname, email, password, role, createdAt) 
VALUES (1, 1, 'Admin', 'Agence', 'admin@email.com', 'hashedpassword', 'manager', NOW());

INSERT INTO Conversation (user_id, agent_id, status, createdAt) 
VALUES (1, 1, 'open', NOW());

INSERT INTO Chat (conversation_id, user_id, message, date) 
VALUES (1, 1, 'Bonjour, j’ai un problème avec ma réservation.', NOW());

SELECT * FROM User;
SELECT * FROM Agency;
SELECT * FROM Vehicle;
SELECT * FROM Reservation;
SELECT * FROM Payment;
SELECT * FROM Invoice;
SELECT * FROM Contract;
SELECT * FROM Support;
SELECT * FROM Notification;
SELECT * FROM Review;
SELECT * FROM Conversation;
SELECT * FROM Chat;
