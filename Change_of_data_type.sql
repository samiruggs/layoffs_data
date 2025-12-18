ALTER TABLE dbo.cleaned
ALTER COLUMN Date_Reported DATE;

ALTER TABLE dbo.cleaned
ALTER COLUMN Country_Code VARCHAR(50);

ALTER TABLE dbo.cleaned
ALTER COLUMN WHO_Region VARCHAR(50);

ALTER TABLE dbo.cleaned
ALTER COLUMN New_Cases INT;

ALTER TABLE dbo.cleaned
ALTER COLUMN Cummulative_Cases BIGINT;

ALTER TABLE dbo.cleaned
ALTER COLUMN New_Death INT;

ALTER TABLE dbo.cleaned
ALTER COLUMN Cummulative_Death BIGINT;

ALTER TABLE dbo.cleaned
ALTER COLUMN Year INT;

ALTER TABLE dbo.cleaned
ALTER COLUMN Month VARCHAR(15);
