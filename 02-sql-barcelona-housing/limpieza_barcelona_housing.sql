USE PortfolioProject
GO

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
GO


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


USE PortfolioProject
GO

SELECT TOP 10 Barrio, NombreCalle, NumeroCalle, condition, price, sq_m_built
FROM BarcelonaHousing
GO

SELECT COUNT(*) AS TotalFinal FROM BarcelonaHousing
GO

SELECT DISTINCT condition, COUNT(*) AS Total
FROM BarcelonaHousing
GROUP BY condition
GO

SELECT * FROM BarcelonaHousing