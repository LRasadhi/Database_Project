DROP DATABASE save_sri_lanka;
CREATE DATABASE save_sri_lanka;
USE save_sri_lanka;

CREATE TABLE user(
    userId int NOT NULL AUTO_INCREMENT,
    firstName varchar(30),
    lastName varchar(30),
    address varchar(50),
    email varchar(30),
    contact int(10),
    role ENUM('ADMIN', 'DONOR', 'HOSPITAL'),
    primary key (userId)
);

CREATE TABLE aid_package(
    aidPackageId int NOT NULL AUTO_INCREMENT,
    adminId int,
    name varchar(30),
    description varchar(50),
    createdDate datetime DEFAULT(now()),
    PRIMARY KEY (aidPackageId),
    FOREIGN KEY (adminId) REFERENCES user(userId)
);

CREATE TABLE medical_need(
    needId int NOT NULL AUTO_INCREMENT,
    hospitalId int,
    name varchar(30),
    quantity int(10) NOT NULL,
    price int(10) NOT NULL,
    requiredDate date,
    PRIMARY KEY (needId),
    FOREIGN KEY (hospitalId) REFERENCES user(userId)
);

CREATE TABLE donation(
    donationId int NOT NULL AUTO_INCREMENT,
    donorId int,
    aidPackageId int,
    amount int(10) NOT NULL,
    createdDate datetime DEFAULT(now()),
    PRIMARY KEY (donationId),
    FOREIGN KEY (donorId) REFERENCES user(userId),
    FOREIGN KEY (aidPackageId) REFERENCES aid_package(aidPackageId)
);


CREATE TABLE aid_package_item(
    aidPackageId  int,
    medicalNeedId int,
    PRIMARY KEY (aidPackageId, medicalNeedId),
    FOREIGN KEY (aidPackageId) REFERENCES aid_package(aidPackageId),
    FOREIGN KEY (medicalNeedId) REFERENCES medical_need(needId)
);


-- Create a user
INSERT INTO user(firstName, lastName, address, email, contact, role) VALUES
    ('Anjula', 'Shanaka', 'Watapuluwa, Kandy SL', 'anjulashanaka@gmail.com', 772407707, 'ADMIN');

INSERT INTO user(firstName, lastName, address, email, contact, role) VALUES
    ('Chamara', 'Perera', 'Central, Kandy SL', 'fullmetal@gmail.com', 772414707, 'DONOR'),
    ('Sugath', 'Silva', 'Central, Kandy SL', 'al@gmail.com', 752488707, 'DONOR');

INSERT INTO user(firstName, address, email, contact, role) VALUES
    ('Kandy General Hospital', 'Central, Kandy, Sri Lanka', 'kh@gmail.com', 811220707, 'HOSPITAL'),
    ('Colombo General Hospital', 'Western, Colombo, Sri Lanka', 'ch@gmail.com', 812213707, 'HOSPITAL');

SELECT * FROM user;


-- Hospital uploads medical needs
SELECT * FROM user WHERE role='HOSPITAL';

INSERT INTO medical_need(hospitalId, name, quantity, price, requiredDate) VALUES 
    (4, 'GAUZE SWABS - STERILE', 1000, 3199, '2022-08-31'), 
    (4, 'PARACETAMOL TABLETS BP 500MG', 1500, 51300, '2022-08-31'),
    (4, 'BLOOD COLLECTION BAGS', 100, 700, '2023-05-13'),
    (4, 'Panadol', 1500, 51300, '2023-05-13');

INSERT INTO medical_need(hospitalId, name, quantity, price, requiredDate) VALUES 
    (5, 'Cotton Wool', 1200, 5000, '2023-02-07'), 
    (5, 'DEXTROSE INJECTION USP 50%', 1500, 38000, '2023-02-07'),
    (5, 'ABSORBENT COTTON WOOL', 320, 500, '2023-03-31'),
    (5, 'ATROPINE INJECTION BP 0.6MG/ML', 15000, 50000, '2023-03-31');

-- Admin wants to see all the medical needs
SELECT * FROM medical_need;

SELECT * FROM medical_need ORDER BY requiredDate;

-- Admin creates an aid package
INSERT INTO aid_package(adminId, name, description) VALUES 
    (1, 'Gauze paraffin dressing', 'Gauze paraffin dressing (Aug 2022)');

INSERT INTO aid_package_item(aidPackageId, medicalNeedId) VALUES 
    (1, 1), 
    (1, 3), 
    (1, 5);

INSERT INTO aid_package(adminId, name, description) VALUES 
    (1, 'Singapore Help Aid| Atropine', 'Alliance Pharm Pte Ltd');

INSERT INTO aid_package_item(aidPackageId, medicalNeedId) VALUES 
    (2, 2), 
    (2, 4), 
    (2, 6),
    (2, 8);

SELECT * FROM aid_package;

UPDATE aid_package SET description = 'Alliance Pharm' WHERE aidPackageId = 2;

-- Donor donates
INSERT INTO donation(donorId, aidPackageId, amount) VALUES (2, 1, 100);

INSERT INTO donation(donorId, aidPackageId, amount) VALUES (2, 2, 4500);

INSERT INTO donation(donorId, aidPackageId, amount) VALUES (3, 1, 1100);

INSERT INTO donation(donorId, aidPackageId, amount) VALUES (3, 1, 650);

SELECT * FROM donation;

-- Donor donated aid packages
SELECT name, amount, donation.createdDate as donatedDate
FROM donation INNER JOIN aid_package on aid_package.aidPackageId = donation.aidPackageId WHERE donorId = 2;


-- Medical needs in an aid package
SELECT * FROM aid_package_item INNER JOIN medical_need mn on mn.needId = aid_package_item.medicalNeedId WHERE aidPackageId = 1;

-- Donor's total donates
SELECT SUM(amount) FROM donation WHERE donorId = 2;

-- Aid packages total recieve amount
SELECT SUM(amount) FROM donation WHERE aidPackageId = 1;

-- Aid packages total amount
SELECT SUM(price) FROM aid_package_item INNER JOIN medical_need mn on mn.needId = aid_package_item.medicalNeedId WHERE aidPackageId = 1;
