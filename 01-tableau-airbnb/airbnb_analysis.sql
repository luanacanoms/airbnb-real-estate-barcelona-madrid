/*
===============================================
PROYECTO: Análisis de Datos de Airbnb — Barcelona y Madrid
Autora: Luana de Morais Cano
Fuente de datos: Inside Airbnb (insideairbnb.com)
Técnicas: JOIN, CTE, Window Functions, Temp Tables, Views
===============================================
*/

USE PortfolioProject
GO

-- Unir Barcelona + Madrid (Listings y Reviews)

DROP TABLE IF EXISTS AirbnbListings
DROP TABLE IF EXISTS AirbnbReviews
GO

SELECT * INTO AirbnbListings FROM (
    SELECT * FROM Listings_Barcelona
    UNION ALL
    SELECT * FROM Listings_Madrid
) AS combined
GO

SELECT * INTO AirbnbReviews FROM (
    SELECT * FROM Reviews_Barcelona
    UNION ALL
    SELECT * FROM Reviews_Madrid
) AS combined
GO

-- Confirmación de los datos

SELECT COUNT(*) AS TotalAnuncios FROM AirbnbListings
SELECT COUNT(*) AS TotalResenas FROM AirbnbReviews
SELECT city, COUNT(*) AS Total FROM AirbnbListings GROUP BY city
GO


-- Indicadores generales por ciudad

SELECT city,
    COUNT(*) AS TotalAnuncios,
    AVG(price) AS PrecioPromedio,
    AVG(review_scores_rating) AS ValoracionPromedio
FROM AirbnbListings
GROUP BY city
GO

-- % de actividad reciente (Barcelona)

SELECT neighbourhood_cleansed, city, number_of_reviews, number_of_reviews_ltm,
    (CAST(number_of_reviews_ltm AS FLOAT) / NULLIF(number_of_reviews, 0)) * 100 AS PorcentajeActividadReciente
FROM AirbnbListings
WHERE city = 'Barcelona'
ORDER BY 1, 2
GO

-- PARTE 5: Tasa de actividad por barrio (Barcelona)

SELECT neighbourhood_cleansed, city, COUNT(*) AS TotalAnuncios,
    MAX(number_of_reviews) AS MaxResenas,
    (MAX(number_of_reviews) * 1.0 / COUNT(*)) * 100 AS TasaActividad
FROM AirbnbListings
WHERE city = 'Barcelona'
GROUP BY neighbourhood_cleansed, city
ORDER BY TasaActividad DESC
GO

-- PARTE 6: Barrios con el precio más alto (Barcelona)

SELECT neighbourhood_cleansed, MAX(price) AS PrecioMaximo
FROM AirbnbListings
WHERE city = 'Barcelona'
GROUP BY neighbourhood_cleansed
ORDER BY PrecioMaximo DESC
GO

-- PARTE 7: Comparación entre ciudades

SELECT city, MAX(price) AS PrecioMaximo
FROM AirbnbListings
GROUP BY city
ORDER BY PrecioMaximo DESC
GO

-- PARTE 8: Números globales de reseñas por fecha

SELECT date, COUNT(*) AS TotalResenas
FROM AirbnbReviews
GROUP BY date
ORDER BY 1, 2
GO

-- PARTE 9: CTE - Reseñas acumuladas (Rolling)

WITH AnunciosVsResenas (city, neighbourhood_cleansed, date, ResenasEseDia, ResenasAcumuladas)
AS
(
    SELECT l.city, l.neighbourhood_cleansed, r.date, 
        COUNT(*) AS ResenasEseDia,
        SUM(COUNT(*)) OVER (PARTITION BY l.city, l.neighbourhood_cleansed ORDER BY r.date) AS ResenasAcumuladas
    FROM AirbnbReviews r
    JOIN AirbnbListings l
        ON r.listing_id = l.id
    GROUP BY l.city, l.neighbourhood_cleansed, r.date
)
SELECT *, (ResenasAcumuladas * 1.0 / NULLIF(ResenasEseDia, 0)) AS RatioCrecimiento
FROM AnunciosVsResenas
ORDER BY 1, 2
GO

-- PARTE 10: Tabla Temporal (misma lógica)

DROP TABLE IF EXISTS #ResenasAcumuladas
GO

CREATE TABLE #ResenasAcumuladas
(
    Ciudad nvarchar(255),
    Barrio nvarchar(255),
    Fecha date,
    ResenasEseDia int,
    ResenasAcumuladas int
)
GO

INSERT INTO #ResenasAcumuladas
SELECT l.city, l.neighbourhood_cleansed, r.date,
    COUNT(*),
    SUM(COUNT(*)) OVER (PARTITION BY l.city, l.neighbourhood_cleansed ORDER BY r.date)
FROM AirbnbReviews r
JOIN AirbnbListings l
    ON r.listing_id = l.id
GROUP BY l.city, l.neighbourhood_cleansed, r.date
GO

SELECT *, (ResenasAcumuladas * 1.0 / NULLIF(ResenasEseDia, 0)) AS RatioCrecimiento
FROM #ResenasAcumuladas
ORDER BY Ciudad, Barrio, Fecha
GO

-- PARTE 11: Vista para visualización (Tableau)

DROP VIEW IF EXISTS VistaResenasAcumuladas
GO

CREATE VIEW VistaResenasAcumuladas AS
SELECT l.city, l.neighbourhood_cleansed, r.date,
    COUNT(*) AS ResenasEseDia,
    SUM(COUNT(*)) OVER (PARTITION BY l.city, l.neighbourhood_cleansed ORDER BY r.date) AS ResenasAcumuladas
FROM AirbnbReviews r
JOIN AirbnbListings l
    ON r.listing_id = l.id
GROUP BY l.city, l.neighbourhood_cleansed, r.date
GO

SELECT TOP (1000) *
FROM VistaResenasAcumuladas

-- Tabla 1 — KPIs por ciudad

SELECT city,
    COUNT(*) AS TotalAnuncios,
    AVG(price) AS PrecioPromedio,
    AVG(review_scores_rating) AS ValoracionPromedio
FROM AirbnbListings
GROUP BY city

-- Tabla 2 — Top barrios por precio

SELECT neighbourhood_cleansed, city, MAX(price) AS PrecioMaximo, COUNT(*) AS TotalAnuncios
FROM AirbnbListings
GROUP BY neighbourhood_cleansed, city

-- Tabla 3 — Datos geográficos

SELECT neighbourhood_cleansed, neighbourhood_group_cleansed, city, 
    latitude, longitude, price, room_type, number_of_reviews,
    host_is_superhost, availability_365
FROM AirbnbListings

-- Tabla 4 — Tendencia de reseñas

SELECT city, neighbourhood_cleansed, date, ResenasEseDia, ResenasAcumuladas
FROM VistaResenasAcumuladas

SELECT * FROM AirbnbListings WHERE city = 'Barcelona'


USE PortfolioProject
GO

SELECT id,  neighbourhood_cleansed, room_type, price, number_of_reviews, 
    number_of_reviews_ltm, availability_365, review_scores_rating, host_is_superhost
FROM AirbnbListings
WHERE city = 'Barcelona'