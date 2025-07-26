SELECT * FROM projects.laptop;

-- ISSUES:
-- Incorrect Name for Index
-- Add Decimal in all Inches Values
-- Screen and Resolution are both Merged
-- Cpu merged with type, processor and speed also remove GHx from Speed
-- Extract GB from RAM
-- Memory and Memory type merged also Remove GB
-- Remove kg from Weight
-- Remove Null Values
-- Remove Duplicates if exist

-- Fixing Index Column Name
ALTER TABLE projects.laptop
CHANGE COLUMN `Unnamed: 0` ItemNo INTEGER;

-- Removing Null Values
SELECT * FROM projects.laptop
WHERE ItemNo IS NULL;

DELETE FROM projects.laptop
WHERE ItemNo IS NULL;

-- Fixing Decimals in Inches
ALTER TABLE projects.laptop MODIFY COLUMN Inches DECIMAL(10,1);

-- Fixing ScreenResolution
SELECT ScreenResolution,SUBSTRING_INDEX(SUBSTRING_INDEX(ScreenResolution, ' ', -1),'x',1) AS 'ResolutionHeight',
SUBSTRING_INDEX(SUBSTRING_INDEX(ScreenResolution, ' ', -1),'x',-1)	AS 'ResolutionWidght'
FROM projects.laptop;

ALTER TABLE projects.laptop
ADD COLUMN ResolutionHeight INTEGER AFTER Inches;


ALTER TABLE projects.laptop
ADD COLUMN ResolutionWidght INTEGER AFTER Inches;

UPDATE projects.laptop
SET ResolutionHeight = SUBSTRING_INDEX(SUBSTRING_INDEX(ScreenResolution, ' ', -1),'x',1);

UPDATE projects.laptop
SET ResolutionWidght = SUBSTRING_INDEX(SUBSTRING_INDEX(ScreenResolution, ' ', -1),'x',-1);

ALTER TABLE projects.laptop
MODIFY COLUMN ResolutionWidght INTEGER;

ALTER TABLE projects.laptop
MODIFY COLUMN ResolutionHeight INTEGER;

-- Adding TouchScreen Yes or No
SELECT ScreenResolution LIKE '%Touch%' FROM projects.laptop;

ALTER TABLE projects.laptop
ADD COLUMN TouchScreen VARCHAR(255) AFTER ResolutionHeight;

UPDATE projects.laptop
SET TouchScreen  = ScreenResolution LIKE '%Touch%';

UPDATE projects.laptop
SET TouchScreen  = 
CASE WHEN TouchScreen  = 0 THEN 'No'
	 WHEN TouchScreen  = 1 THEN 'Yes'
END;

-- Fixing Cpu Column (brand, cpu, speed)

ALTER TABLE projects.laptop
ADD COLUMN CpuName VARCHAR(255) AFTER Cpu,
ADD COLUMN CpuBrand VARCHAR(255) AFTER CpuName,
ADD COLUMN CpuSpeed VARCHAR(255) AFTER CpuBrand;

SELECT Cpu,
SUBSTRING_INDEX(Cpu, ' ', -1) AS 'CpuSpeed',
SUBSTRING_INDEX(Cpu, ' ', 1) AS 'CpuBrand',
REPLACE(REPLACE(Cpu,SUBSTRING_INDEX(Cpu, ' ', 1),''),
SUBSTRING_INDEX(REPLACE(Cpu,SUBSTRING_INDEX(Cpu, ' ', 1),''),' ',-1),'') AS 'CpuName'
FROM projects.laptop;

UPDATE projects.laptop
SET CpuName = REPLACE(REPLACE(Cpu,SUBSTRING_INDEX(Cpu, ' ', 1),''),
SUBSTRING_INDEX(REPLACE(Cpu,SUBSTRING_INDEX(Cpu, ' ', 1),''),' ',-1),'');

UPDATE projects.laptop
SET CpuBrand = SUBSTRING_INDEX(Cpu, ' ', 1);

UPDATE projects.laptop
SET CpuSpeed = SUBSTRING_INDEX(Cpu, ' ', -1);

UPDATE projects.laptop 
SET CpuSpeed = REPLACE(CpuSpeed, 'GHz', '');

ALTER TABLE projects.laptop
MODIFY COLUMN CpuSpeed FLOAT;

-- Fixing Ram Column

UPDATE projects.laptop
SET Ram  = REPLACE(Ram,'GB', '');

ALTER TABLE projects.laptop
MODIFY COLUMN Ram INTEGER;

-- Fixing Memory column

ALTER TABLE projects.laptop
ADD COLUMN MemoryType VARCHAR(255) AFTER Memory,
ADD COLUMN PrimaryStorage INTEGER AFTER MemoryType,
ADD COLUMN SecondaryStorage INTEGER AFTER PrimaryStorage;

SELECT Memory, 
CASE
	WHEN Memory LIKE '%SSD%' AND Memory LIKE '%HDD%' THEN 'Hybird'
    WHEN Memory LIKE '%HDD%' AND Memory LIKE '%Flash Storage%' THEN 'Hybrid'
    WHEN Memory LIKE '%Hybrid%' THEN 'Hybird'
	WHEN Memory LIKE '%SSD%' THEN 'SSD'
	WHEN Memory LIKE '%HDD%' THEN 'HDD'
    WHEN Memory LIKE '%Flash Storage%' THEN 'Flash Storage'
    WHEN Memory LIKE '%SSD%' THEN 'SSD'
    ELSE NULL
    END AS 'MemoryType',
    REGEXP_SUBSTR(SUBSTRING_INDEX(Memory,'+',1),'[0-9]+') AS 'PrimaryStorage',
	CASE WHEN Memory LIKE '%+%' THEN REGEXP_SUBSTR(SUBSTRING_INDEX(Memory,'+',-1),'[0-9]+') ELSE 0 END AS 'Secondary Storage'
FROM projects.laptop;

UPDATE projects.laptop
SET MemoryType = CASE
	WHEN Memory LIKE '%SSD%' AND Memory LIKE '%HDD%' THEN 'Hybird'
    WHEN Memory LIKE '%HDD%' AND Memory LIKE '%Flash Storage%' THEN 'Hybrid'
    WHEN Memory LIKE '%Hybrid%' THEN 'Hybird'
	WHEN Memory LIKE '%SSD%' THEN 'SSD'
	WHEN Memory LIKE '%HDD%' THEN 'HDD'
    WHEN Memory LIKE '%Flash Storage%' THEN 'Flash Storage'
    WHEN Memory LIKE '%SSD%' THEN 'SSD'
    ELSE NULL
    END;
    
UPDATE projects.laptop
SET PrimaryStorage = REGEXP_SUBSTR(SUBSTRING_INDEX(Memory,'+',1),'[0-9]+');

UPDATE projects.laptop
SET SecondaryStorage = CASE WHEN Memory LIKE '%+%' THEN REGEXP_SUBSTR(SUBSTRING_INDEX(Memory,'+',-1),'[0-9]+') ELSE 0 END;

SELECT PrimaryStorage, SecondaryStorage,
CASE WHEN PrimaryStorage <3 THEN PrimaryStorage * 1024
	ELSE PrimaryStorage
    END AS 'Primary',
CASE
	 WHEN SecondaryStorage <3 THEN SecondaryStorage * 1024
     END AS 'Secondary'
FROM projects.laptop;
    
UPDATE projects.laptop
SET PrimaryStorage = CASE WHEN PrimaryStorage <3 THEN PrimaryStorage * 1024
	ELSE PrimaryStorage
    END;

UPDATE projects.laptop
SET SecondaryStorage = CASE
	 WHEN SecondaryStorage <3 THEN SecondaryStorage * 1024
     END;
     
-- Fixing Gpu Column
ALTER TABLE projects.laptop
ADD COLUMN GpuBrand VARCHAR(255) AFTER Gpu,
ADD COLUMN GpuName VARCHAR(255) AFTER GpuBrand;

SELECT Gpu, 
SUBSTRING_INDEX(Gpu,' ',1) AS 'GpuBrand',
SUBSTRING_INDEX(Gpu,SUBSTRING_INDEX(Gpu,' ',1),-1) AS 'GpuName'
FROM projects.laptop;

UPDATE projects.laptop
SET GpuBrand = SUBSTRING_INDEX(Gpu,' ',1);

UPDATE projects.laptop
SET GpuName = SUBSTRING_INDEX(Gpu,SUBSTRING_INDEX(Gpu,' ',1),-1);
     
-- Fixing Operating System
SELECT DISTINCT OpSys,
CASE
	WHEN OpSys LIKE '%mac%' THEN 'Mac OS'
    WHEN OpSys =  'No OS' THEN 'N/A'
    WHEN OpSys LIKE '%Windows%' THEN 'Windows'
    WHEN OpSys = 'Linux' THEN 'Linux'
    ELSE 'Other'
    END AS 'OpSy'
FROM projects.laptop;

UPDATE projects.laptop
SET OpSys = CASE
	WHEN OpSys LIKE '%mac%' THEN 'Mac OS'
    WHEN OpSys =  'No OS' THEN 'N/A'
    WHEN OpSys LIKE '%Windows%' THEN 'Windows'
    WHEN OpSys = 'Linux' THEN 'Linux'
    ELSE 'Other'
    END;

-- Fixing Weight Column

SELECT Weight, REPLACE(Weight,'kg','')
FROM projects.laptop;

UPDATE projects.laptop
SET Weight = REPLACE(Weight,'kg','');

ALTER TABLE projects.laptop
MODIFY COLUMN Weight FLOAT;

-- Dropping Unnessarry column

ALTER TABLE projects.laptop
DROP ScreenResolution,
DROP Cpu,
DROP Memory,
DROP Gpu;

-- Viewing Cleaned Column

SELECT * FROM projects.laptop




