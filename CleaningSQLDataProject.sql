Select* 
From [Portfolio Project 2].[dbo].NashvilleHousing 
--Cleaning SQL Queries 
Select* 
From [Portfolio Project 2].[dbo].NashvilleHousing 
--Standardize Date Format 
Select SaleDate, CONVERT (Date,SaleDate) 
From [Portfolio Project 2].[dbo].NashvilleHousing

UPDATE NashvilleHousing 
SET SaleDate = CONVERT (Date,SaleDate)

--OR--
Select SaleDateConverted, CONVERT(Date,SaleDate) 
From [Portfolio Project 2].[dbo].NashvilleHousing

ALTER TABLE [Portfolio Project 2].[dbo].NashvilleHousing

--Populate Property Address data 
SELECT* 
From [Portfolio Project 2].[dbo].NashvilleHousing
--Where PropertyAddress is null
order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress,ISNULL (a.PropertyAddress,b.PropertyAddress)
From [Portfolio Project 2].[dbo].NashvilleHousing a
JOIN [Portfolio Project 2].[dbo].NashvilleHousing b 
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null 

UPDATE a
SET PropertyAddress = ISNULL (a.PropertyAddress,b.PropertyAddress)
From [Portfolio Project 2].[dbo].NashvilleHousing a
JOIN [Portfolio Project 2].[dbo].NashvilleHousing b 
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null 

--Breaking out Address into Individual Columns (Address, City, State) 

SELECT PropertyAddress
From [Portfolio Project 2].[dbo].NashvilleHousing
--Where PropertyAddress is null
--order by ParcelID

Select 
SUBSTRING (PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as Address
, SUBSTRING (PropertyAddress,CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress)) as Address
FROM [Portfolio Project 2].[dbo].NashvilleHousing

ALTER TABLE [Portfolio Project 2].[dbo].NashvilleHousing
Add PropertySplitAddress Nvarchar (255); 

UPDATE [Portfolio Project 2].[dbo].NashvilleHousing
SET PropertySplitAddress = SUBSTRING (PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) 

ALTER TABLE [Portfolio Project 2].[dbo].NashvilleHousing
Add PropertySplitCity Nvarchar (255); 

UPDATE [Portfolio Project 2].[dbo].NashvilleHousing
SET PropertySplitCity = SUBSTRING (PropertyAddress,CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress))

SELECT* 
FROM [Portfolio Project 2].[dbo].NashvilleHousing

SELECT OwnerAddress
FROM [Portfolio Project 2].[dbo].NashvilleHousing

SELECT 
PARSENAME (REPLACE(OwnerAddress,',','.'), 3)
,PARSENAME (REPLACE(OwnerAddress,',','.'), 2) 
,PARSENAME (REPLACE(OwnerAddress,',','.'), 1)
FROM [Portfolio Project 2].[dbo].NashvilleHousing

ALTER TABLE [Portfolio Project 2].[dbo].NashvilleHousing
Add OwnerSplitAddress Nvarchar (255); 

UPDATE [Portfolio Project 2].[dbo].NashvilleHousing
SET OwnerSplitAddress = PARSENAME (REPLACE(OwnerAddress,',','.'), 3)

ALTER TABLE [Portfolio Project 2].[dbo].NashvilleHousing
Add OwnerSplitCity Nvarchar (255); 

UPDATE [Portfolio Project 2].[dbo].NashvilleHousing
SET OwnerSplitCity = PARSENAME (REPLACE(OwnerAddress,',','.'), 2)

ALTER TABLE [Portfolio Project 2].[dbo].NashvilleHousing
Add OwnerSplitState Nvarchar (255); 

UPDATE [Portfolio Project 2].[dbo].NashvilleHousing
SET OwnerSplitState = PARSENAME (REPLACE(OwnerAddress,',','.'), 1)

Select* 
FROM [Portfolio Project 2].[dbo].NashvilleHousing
--Change Y and N to Yes and No in "Sold as Vacant" field

Select Distinct (SoldAsVacant), COUNT (SoldAsVacant) 
FROM [Portfolio Project 2].[dbo].NashvilleHousing
GROUP BY SoldAsVacant
Order by 2 

Select SoldAsVacant
, CASE WHEN SoldAsVacant = 'Y' THEN 'Yes' 
	When SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
	END
FROM [Portfolio Project 2].[dbo].NashvilleHousing

UPDATE [Portfolio Project 2].[dbo].NashvilleHousing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes' 
	When SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
	END

-- Remove Duplicates
WITH RowNumCTE AS (
Select*, 
ROW_NUMBER() Over (
Partition BY ParcelID,
			PropertyAddress,
			SalePrice, 
			SaleDate, 
			LegalReference
			Order BY 
			UniqueID
			) row_num

FROM [Portfolio Project 2].[dbo].NashvilleHousing
) 
Select*
FROM RowNumCTE
WHERE row_num > 1
Order by PropertyAddress

--DELETE Unused Columns 
Select* 
From [Portfolio Project 2].[dbo].NashvilleHousing

ALTER TABLE [Portfolio Project 2].[dbo].NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE [Portfolio Project 2].[dbo].NashvilleHousing
DROP COLUMN SaleDate