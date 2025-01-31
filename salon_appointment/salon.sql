-- Create the database
CREATE DATABASE salon;

-- Connect to the database
\c salon;

-- Create the customers table
CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    phone VARCHAR(20) UNIQUE NOT NULL
);

-- Create the services table
CREATE TABLE services (
    service_id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL
);

-- Create the appointments table
CREATE TABLE appointments (
    appointment_id SERIAL PRIMARY KEY,
    customer_id INT NOT NULL,
    service_id INT NOT NULL,
    time VARCHAR(20) NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (service_id) REFERENCES services(service_id)
);

-- Insert services
INSERT INTO services (name) VALUES ('Cut'), ('Color'), ('Shave');
