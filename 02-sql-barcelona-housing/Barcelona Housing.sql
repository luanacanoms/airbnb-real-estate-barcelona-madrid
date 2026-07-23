ALTER TABLE BarcelonaHousing
ADD Barrio NVARCHAR(255)
GO


UPDATE BarcelonaHousing
SET Barrio = CASE 
    WHEN CHARINDEX(',', neighborhood) > 0 
        THEN SUBSTRING(neighborhood, 1, CHARINDEX(',', neighborhood) - 1)
    ELSE neighborhood
    END
GO

SELECT TOP 10 neighborhood, Barrio
FROM BarcelonaHousing


-- PASSO 4: Popular "street" quando repete o bairro

UPDATE BarcelonaHousing
SET street = NULL
WHERE street = Barrio
GO

SELECT COUNT(*) AS AnunciosSemRuaEspecifica
FROM BarcelonaHousing
WHERE street IS NULL
GO


-- ================================================
-- PASSO 5: Separar "street" em Nome da Rua + Número
-- ================================================
ALTER TABLE BarcelonaHousing
ADD NombreCalle NVARCHAR(255), NumeroCalle NVARCHAR(50)
GO

UPDATE BarcelonaHousing
SET NombreCalle = CASE 
        WHEN street IS NULL THEN NULL
        WHEN CHARINDEX(',', street) > 0
            THEN SUBSTRING(street, 1, CHARINDEX(',', street) - 1)
        ELSE street 
        END,
    NumeroCalle = CASE 
        WHEN street IS NULL THEN NULL
        WHEN CHARINDEX(',', street) > 0
            THEN LTRIM(SUBSTRING(street, CHARINDEX(',', street) + 1, LEN(street)))
        ELSE NULL 
        END
GO

SELECT TOP 10 street, NombreCalle, NumeroCalle
FROM BarcelonaHousing
GO


-- ================================================
-- PASSO 6: Padronizar o campo "condition"
-- ================================================
UPDATE BarcelonaHousing
SET condition = CASE
    WHEN condition LIKE '%good condition%' THEN 'Good condition'
    WHEN condition LIKE '%renovating%' THEN 'Needs renovating'
    WHEN condition LIKE '%new development%' THEN 'New development'
    WHEN condition IS NULL THEN 'Not specified'
    ELSE condition
    END
GO

SELECT DISTINCT condition, COUNT(*) AS Total
FROM BarcelonaHousing
GROUP BY condition
GO


-- ================================================
-- PASSO 7: Ver as duplicatas (só conferir, ainda não apaga)
-- ================================================
WITH RowNumCTE AS (
    SELECT *,
        ROW_NUMBER() OVER (
            PARTITION BY Barrio, NombreCalle, price, sq_m_built, n_bedrooms
            ORDER BY id
        ) row_num
    FROM BarcelonaHousing
)
SELECT * FROM RowNumCTE WHERE row_num > 1
ORDER BY Barrio
GO


-- ================================================
-- PASSO 8: Apagar as duplicatas de verdade
-- (rode só depois de conferir o resultado do Passo 7)
-- ================================================
WITH RowNumCTE AS (
    SELECT *,
        ROW_NUMBER() OVER (
            PARTITION BY Barrio, NombreCalle, price, sq_m_built, n_bedrooms
            ORDER BY id
        ) row_num
    FROM BarcelonaHousing
)
DELETE FROM RowNumCTE
WHERE row_num > 1
GO

SELECT COUNT(*) AS TotalAposLimpeza FROM BarcelonaHousing
GO


-- ================================================
-- PASSO 9: Apagar colunas não usadas
-- ================================================
ALTER TABLE BarcelonaHousing
DROP COLUMN neighborhood, street
GO

SELECT * FROM BarcelonaHousing
GO

SELECT * FROM BarcelonaHousing

SELECT TOP 1 * FROM BarcelonaHousing

USE PortfolioProject
GO

-- Query 1 — KPIs gerais
SELECT 
    COUNT(*) AS TotalPisos,
    AVG(CAST(price AS BIGINT)) AS PrecioPromedio,
    AVG(CAST(price AS FLOAT) / NULLIF(sq_m_built, 0)) AS PrecioPromedioM2,
    AVG(CAST(sq_m_built AS FLOAT)) AS M2Promedio,
    AVG(n_bedrooms) AS HabitacionesPromedio
FROM BarcelonaHousing
GO

-- Query 2 — Preço médio por bairro (Top 15)
SELECT TOP 15 Barrio, 
    COUNT(*) AS TotalPisos,
    AVG(CAST(price AS BIGINT)) AS PrecioPromedio,
    AVG(CAST(price AS FLOAT) / NULLIF(sq_m_built, 0)) AS PrecioM2
FROM BarcelonaHousing
GROUP BY Barrio
ORDER BY PrecioPromedio DESC
GO

-- Query 3 — Distribuição por condição
SELECT condition, COUNT(*) AS Total,
    CAST(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER() AS DECIMAL(5,1)) AS Porcentaje
FROM BarcelonaHousing
GROUP BY condition
ORDER BY Total DESC
GO

-- Query 4 — Preço médio por número de quartos
SELECT n_bedrooms, 
    COUNT(*) AS Total,
    AVG(CAST(price AS BIGINT)) AS PrecioPromedio
FROM BarcelonaHousing
WHERE n_bedrooms IS NOT NULL
GROUP BY n_bedrooms
ORDER BY n_bedrooms
GO

-- Query 5 — Impacto do elevador no preço
SELECT lift, 
    COUNT(*) AS Total,
    AVG(CAST(price AS BIGINT)) AS PrecioPromedio,
    AVG(CAST(price AS FLOAT) / NULLIF(sq_m_built, 0)) AS PrecioM2
FROM BarcelonaHousing
GROUP BY lift
GO

-- Query 6 — Distribuição por década de construção
SELECT 
    CASE 
        WHEN year_built IS NULL THEN 'No especificado'
        ELSE CAST((FLOOR(year_built / 10) * 10) AS VARCHAR) + 's'
        END AS Decada,
    COUNT(*) AS Total,
    AVG(CAST(price AS BIGINT)) AS PrecioPromedio
FROM BarcelonaHousing
GROUP BY CASE 
        WHEN year_built IS NULL THEN 'No especificado'
        ELSE CAST((FLOOR(year_built / 10) * 10) AS VARCHAR) + 's'
        END
ORDER BY Decada
GO

-- Query 7 — Relação Preço x Tamanho
SELECT Barrio, sq_m_built, price, n_bedrooms, condition
FROM BarcelonaHousing
WHERE sq_m_built IS NOT NULL AND price IS NOT NULL
ORDER BY sq_m_built
GO

SELECT TOP 50 Barrio, sq_m_built, price, n_bedrooms, condition
FROM BarcelonaHousing
WHERE sq_m_built IS NOT NULL AND price IS NOT NULL
ORDER BY NEWID()