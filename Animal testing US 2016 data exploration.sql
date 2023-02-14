SELECT *
FROM ALL_PAINTYPES_2016

-- In this query we will be looking at the animals used in the US states in 2016 for animal testing. 
-- Our source shows data for all US states using cats, dogs, guinea pigs, hamsters, nonhuman primates, pigs, rabbits, sheep and
-- other farm animals used in animal testing. 

-- First let's see which are the top states with most cats and dogs (combined) used for testing. 

SELECT State, SUM(cats) as cats, SUM(dogs) as dogs, SUM(guineapigs) as guineapigs, SUM(hamsters) as hamsters, SUM(Rabbits) as rabbits, SUM(cats + dogs + GuineaPigs + Hamsters + Rabbits) AS TotalPets
FROM ALL_PAINTYPES_2016 
GROUP BY State
ORDER BY TotalPets DESC



-- Now that we've seen pets used for animal testing, let;s take a look at farm animals, too

SELECT State, SUM(otherfarmanimals) as otherfarmanimals, SUM(pig) as pigs, SUM(sheep) as sheep, 
SUM(otherfarmanimals + sheep + pig) AS TotalFarmAnimals
FROM ALL_PAINTYPES_2016 
GROUP BY State
ORDER BY TotalFarmAnimals DESC



-- Let's zoom in on each animal's use for testing purposes and find out which states abuse them the most

-- Cats are most used in testing in California, Ohio and Pennsylvania

SELECT State, SUM(cats) as cats
FROM ALL_PAINTYPES_2016 
GROUP BY State
ORDER BY cats DESC


--Dogs are most abused in animal testing in California, Massachussetts and Ohio

SELECT State, SUM(dogs) as dogs
FROM ALL_PAINTYPES_2016 
GROUP BY State
ORDER BY dogs DESC

-- Guinea Pigs are most abused in Ohio, Minesota and Michigan

SELECT State, SUM(guineapigs) as guineapigs
FROM ALL_PAINTYPES_2016 
GROUP BY State
ORDER BY guineapigs DESC

-- Hamsters are most used in testing in New Jersey, Misouri and Indiana

SELECT State, SUM(Hamsters) as hamsters
FROM ALL_PAINTYPES_2016 
GROUP BY State
ORDER BY hamsters DESC

--Rabbits are most used in California, Pennsylvania and Wisconsin

SELECT State, SUM(rabbits) as rabbits
FROM ALL_PAINTYPES_2016 
GROUP BY State
ORDER BY rabbits DESC

--Pigs are most tested on in California, Massachussetts and Minnesota

SELECT State, SUM(pig) as pigs
FROM ALL_PAINTYPES_2016 
GROUP BY State
ORDER BY pigs DESC


-- Sheep are most tested on in Vermont, California and Pennsylvania 

SELECT State, SUM(sheep) as sheep
FROM ALL_PAINTYPES_2016 
GROUP BY State
ORDER BY sheep DESC

-- Lastly, let's look at which animal is being tested on the most accross the US: guinea pig

SELECT  SUM(guineapigs) as guineapigs, SUM(otherfarmanimals) as otherfarmanimals, SUM(pig) as pigs, SUM(sheep) as sheep, 
SUM(cats) as cats, SUM(dogs) as dogs,  SUM(hamsters) as hamsters, SUM(Rabbits) as rabbits
FROM ALL_PAINTYPES_2016 
--GROUP BY State
ORDER BY 1 DESC