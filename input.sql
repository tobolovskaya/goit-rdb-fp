CREATE SCHEMA IF NOT EXISTS pandemic;
USE pandemic;

SELECT * FROM pandemic.infectious_cases;

DROP TABLE IF EXISTS infectious_cases;
DROP TABLE IF EXISTS diseases;
DROP TABLE IF EXISTS countries;

CREATE TABLE countries (
                           country_id INT AUTO_INCREMENT PRIMARY KEY,
                           entity VARCHAR(255) NOT NULL,
                           code VARCHAR(10) NULL
);

CREATE TABLE diseases (
                          disease_id INT AUTO_INCREMENT PRIMARY KEY,
                          name VARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE infectious_cases (
                                  case_id INT AUTO_INCREMENT PRIMARY KEY,
                                  country_id INT NOT NULL,
                                  year INT NOT NULL,
                                  disease_id INT NOT NULL,
                                  number FLOAT NOT NULL,
                                  FOREIGN KEY (country_id) REFERENCES countries(country_id),
                                  FOREIGN KEY (disease_id) REFERENCES diseases(disease_id)
);

INSERT INTO countries (entity, code)
SELECT DISTINCT entity, code
FROM infectious_cases_csv;


INSERT INTO diseases (name)
VALUES
    ('Number_yaws'),
    ('polio_cases'),
    ('cases_guinea_worm'),
    ('Number_rabies'),
    ('Number_malaria'),
    ('Number_hiv'),
    ('Number_tuberculosis'),
    ('Number_smallpox'),
    ('Number_cholera_cases');

SELECT * FROM countries;
SELECT * FROM diseases;
SELECT * FROM infectious_cases LIMIT 10;

SELECT
    infectious_cases.year,
    DATE(CONCAT(infectious_cases.year, '-01-01')) AS `first_jan_date`,
    CURDATE() AS `current_date`,
    TIMESTAMPDIFF(YEAR, DATE(CONCAT(infectious_cases.year, '-01-01')), CURDATE()) AS `years_diff`
FROM
    infectious_cases
LIMIT 10;

DELIMITER //

CREATE FUNCTION calculate_year_diff(input_year INT)
    RETURNS INT
    DETERMINISTIC
BEGIN
    DECLARE first_jan_date DATE;
    DECLARE years_diff INT;

    SET first_jan_date = DATE(CONCAT(input_year, '-01-01'));
    SET years_diff = TIMESTAMPDIFF(YEAR, first_jan_date, CURDATE());

    RETURN years_diff;
END //

DELIMITER ;

SELECT
    infectious_cases.year,
    calculate_year_diff(infectious_cases.year) AS years_diff
FROM
    infectious_cases
# ORDER if needed
ORDER BY year
LIMIT 10;