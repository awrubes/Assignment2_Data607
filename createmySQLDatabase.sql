DROP TABLE IF EXISTS survey_responses;

CREATE TABLE survey_responses(
    `timestamp` VARCHAR(255),
    name VARCHAR(255),
    gender VARCHAR(10),
    age_range VARCHAR(20),
    favorite_genres VARCHAR(255),
    Beetlejuice_rating INT,
    Alien_Romulus_rating INT,
    Twisters_rating INT,
    Despicable_Me_4_rating INT,
    Trap_rating INT,
    Deadpool_Wolverine_rating INT
);

SET GLOBAL local_infile = 1;

LOAD DATA LOCAL INFILE 'YOUR FILE PATH HERE'
INTO TABLE survey_responses
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(@timestamp, @name, @gender, @age_range, @favorite_genres, @Beetlejuice_rating, @Alien_Romulus_rating, @Twisters_rating, @Despicable_Me_4_rating, @Trap_rating, @Deadpool_Wolverine_rating)
SET
    `timestamp` = @timestamp,
    name = @name,
    gender = @gender,
    age_range = @age_range,
    favorite_genres = @favorite_genres,
    Beetlejuice_rating = NULLIF(@Beetlejuice_rating, ''),
    Alien_Romulus_rating = NULLIF(@Alien_Romulus_rating, ''),
    Twisters_rating = NULLIF(@Twisters_rating, ''),
    Despicable_Me_4_rating = NULLIF(@Despicable_Me_4_rating, ''),
    Trap_rating = NULLIF(@Trap_rating, ''),
    Deadpool_Wolverine_rating = NULLIF(@Deadpool_Wolverine_rating, '');

DROP TABLE IF EXISTS respondents;

CREATE TABLE respondents (
    respondent_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255),
    gender VARCHAR(10),
    age_range VARCHAR(20),
    favorite_genres VARCHAR(255)
);

INSERT INTO respondents (name, gender, age_range, favorite_genres)
SELECT DISTINCT name, gender, age_range, favorite_genres
FROM survey_responses;

DROP TABLE IF EXISTS movie_ratings;

CREATE TABLE movie_ratings (
    rating_id INT AUTO_INCREMENT PRIMARY KEY,
    respondent_id INT,
    movie_name VARCHAR(255),
    rating INT NULL,
    FOREIGN KEY (respondent_id) REFERENCES respondents(respondent_id)
);

INSERT INTO movie_ratings (respondent_id, movie_name, rating)
SELECT r.respondent_id, 'Beetlejuice', sr.Beetlejuice_rating
FROM survey_responses sr
JOIN respondents r ON sr.name = r.name;

INSERT INTO movie_ratings (respondent_id, movie_name, rating)
SELECT r.respondent_id, 'Alien_Romulus', sr.Alien_Romulus_rating
FROM survey_responses sr
JOIN respondents r ON sr.name = r.name;

INSERT INTO movie_ratings (respondent_id, movie_name, rating)
SELECT r.respondent_id, 'Twisters', sr.Twisters_rating
FROM survey_responses sr
JOIN respondents r ON sr.name = r.name;

INSERT INTO movie_ratings (respondent_id, movie_name, rating)
SELECT r.respondent_id, 'Despicable_Me_4', sr.Despicable_Me_4_rating
FROM survey_responses sr
JOIN respondents r ON sr.name = r.name;

INSERT INTO movie_ratings (respondent_id, movie_name, rating)
SELECT r.respondent_id, 'Trap', sr.Trap_rating
FROM survey_responses sr
JOIN respondents r ON sr.name = r.name;

INSERT INTO movie_ratings (respondent_id, movie_name, rating)
SELECT r.respondent_id, 'Deadpool_Wolverine', sr.Deadpool_Wolverine_rating
FROM survey_responses sr
JOIN respondents r ON sr.name = r.name;