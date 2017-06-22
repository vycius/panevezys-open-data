DROP TABLE
    IF EXISTS savivaldybes_su_kainom;
DROP TABLE
    IF EXISTS socialiniai_su_kainom;
DROP TABLE
    IF EXISTS Bustai;
DROP TABLE
    IF EXISTS KainosBeButu;
-- Savivaldybes bustai su kainomis
CREATE TABLE
    savivaldybes_su_kainom AS
SELECT
    s.[Nr.]                                               AS Id,
    s.[Miestas/Gyvenvietė]                                          AS Miestas,
    s.Gatvė                                                          AS Gatve,
    s.[Namo Nr.]                                                     AS Namas,
    s.[Buto Nr.]                                                     AS Butas,
    ROUND(CAST(REPLACE(s.Plotas, '"', '') AS DECIMAL), 2)                     AS Plotas,
    k.[Patalpų nuomos]                                               AS 'Kaina',
    k.[Patalpų nuomos] / CAST(REPLACE(s.Plotas, '"', '') AS DECIMAL) KainaM2,
    s.Tipas,
    k.lat,
    k.lng
FROM
    savivaldybes s
LEFT JOIN
    kainos k
ON
    s.Gatvė = k.Gatvė || ' g.'
AND s.[Namo Nr.] = k.Namas
AND s.[Buto Nr.] = k.[Butas];
-- Socialiniai bustai su kainomis
CREATE TABLE
    socialiniai_su_kainom AS
SELECT
    s.[Nr.]                                               AS Id,
    s.[Miestas/Gyvenvietė]                                          AS Miestas,
    s.Gatvė                                                          AS Gatve,
    s.[Namo Nr.]                                                     AS Namas,
    s.[Buto Nr.]                                                     AS Butas,
    ROUND(CAST(REPLACE(s.Plotas, '"', '') AS DECIMAL), 2)                      AS Plotas,
    k.[Patalpų nuomos]                                               AS 'Kaina',
    k.[Patalpų nuomos] / CAST(REPLACE(s.Plotas, '"', '') AS DECIMAL) KainaM2,
    s.Tipas,
    k.lat,
    k.lng
FROM
    socialiniai s
LEFT JOIN
    kainos k
ON
    s.Gatvė = k.Gatvė || ' g.'
AND s.[Namo Nr.] = k.Namas
AND s.[Buto Nr.] = k.[Butas];

-- Sanity check
CREATE TABLE
    Bustai AS
SELECT
    *
FROM
    savivaldybes_su_kainom
UNION ALL
SELECT
    *
FROM
    socialiniai_su_kainom;
    
-- 
    
CREATE TABLE
    KainosBeButu AS
SELECT
    k.*
FROM
    kainos AS k
LEFT JOIN
    Bustai b
ON
    b.Gatve = k.Gatvė || ' g.'
AND b.[Namas] = b.Namas
AND b.[Butas] = b.[Butas]
WHERE
    b.Namas IS NULL;
    
-- Statictics
SELECT
    COUNT (*)
FROM
    kainos
UNION ALL
SELECT
    COUNT(*)
FROM
    KainosBeButu
UNION ALL
SELECT
    COUNT(*)
FROM
    Bustai
WHERE
    Kaina IS NULL;