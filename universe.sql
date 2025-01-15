CREATE DATABASE universe;

\c universe;

CREATE TABLE galaxy (
    galaxy_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    distance_from_earth NUMERIC NOT NULL,
    is_spiral BOOLEAN NOT NULL
);

CREATE TABLE star (
    star_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    brightness INT NOT NULL,
    age_in_million_years NUMERIC NOT NULL,
    is_main_sequence BOOLEAN NOT NULL,
    galaxy_id INT NOT NULL REFERENCES galaxy(galaxy_id)
);

CREATE TABLE planet (
    planet_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    size INT NOT NULL,
    gravity NUMERIC NOT NULL,
    has_life BOOLEAN NOT NULL,
    star_id INT NOT NULL REFERENCES star(star_id)
);

CREATE TABLE moon (
    moon_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    radius INT NOT NULL,
    orbital_period NUMERIC NOT NULL,
    is_habitable BOOLEAN NOT NULL,
    planet_id INT NOT NULL REFERENCES planet(planet_id)
);

CREATE TABLE additional_info (
    additional_info_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT NOT NULL,
    category VARCHAR(50) NOT NULL UNIQUE
);


INSERT INTO galaxy (name, description, distance_from_earth, is_spiral) VALUES
('Milky Way', 'Our home galaxy', 0, TRUE),
('Andromeda', 'Nearest large galaxy', 2.537, TRUE),
('Triangulum', 'Small spiral galaxy', 3.0, TRUE),
('Large Magellanic Cloud', 'Satellite galaxy', 0.163, FALSE),
('Small Magellanic Cloud', 'Another satellite galaxy', 0.200, FALSE),
('Whirlpool Galaxy', 'Famous spiral galaxy', 23.0, TRUE);

INSERT INTO star (name, brightness, age_in_million_years, is_main_sequence, galaxy_id) VALUES
('Sun', 100, 4600, TRUE, 1),
('Proxima Centauri', 10, 4900, FALSE, 1),
('Betelgeuse', 1000, 10000, FALSE, 1),
('Sirius', 500, 250, TRUE, 2),
('Rigel', 800, 8500, FALSE, 2),
('Vega', 350, 450, TRUE, 2);

INSERT INTO planet (name, size, gravity, has_life, star_id) VALUES
('Earth', 12742, 9.8, TRUE, 1),
('Mars', 6779, 3.7, FALSE, 1),
('Venus', 12104, 8.87, FALSE, 1),
('Jupiter', 139820, 24.79, FALSE, 1),
('Saturn', 116460, 10.44, FALSE, 1),
('Neptune', 49244, 11.15, FALSE, 2),
('Uranus', 50724, 8.69, FALSE, 2),
('Kepler-22b', 24000, 9.8, TRUE, 2),
('Gliese 581g', 21000, 8.2, TRUE, 2),
('Proxima b', 15000, 0.6, TRUE, 3),
('HD 209458b', 14360, 3.5, FALSE, 4),
('Kepler-452b', 14600, 10.0, TRUE, 5);

INSERT INTO moon (name, radius, orbital_period, is_habitable, planet_id) VALUES
('Moon', 1737, 27.3, FALSE, 1),
('Phobos', 11.3, 0.3, FALSE, 2),
('Deimos', 6.2, 1.3, FALSE, 2),
('Io', 1821, 1.8, FALSE, 4),
('Europa', 1560, 3.5, TRUE, 4),
('Ganymede', 2634, 7.2, FALSE, 4),
('Callisto', 2410, 16.7, FALSE, 4),
('Titan', 2576, 16.0, TRUE, 5),
('Enceladus', 252, 1.4, TRUE, 5),
('Mimas', 198, 0.9, FALSE, 5),
('Triton', 1353, 5.9, FALSE, 6),
('Nereid', 170, 360.1, FALSE, 6),
('Charon', 606, 6.4, FALSE, 7),
('Styx', 5, 3.2, FALSE, 7),
('Nix', 22, 9.2, FALSE, 7),
('Kerberos', 10, 32.2, FALSE, 7),
('Hydra', 31, 38.2, FALSE, 7),
('Oberon', 761, 13.4, FALSE, 8),
('Titania', 789, 8.7, FALSE, 8),
('Miranda', 471, 1.4, FALSE, 8);


INSERT INTO additional_info (name, description, category) VALUES
('Universe', 'All of space and time and their contents', 'General'),
('Solar System', 'The Sun and its planetary system', 'Astronomical System'),
('Exoplanet Discovery', 'Planets found outside our solar system', 'Astronomical Research');
