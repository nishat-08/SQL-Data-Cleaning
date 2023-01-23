/*

Data Cleaning in SQL Queries

*/

Select*
From PortfolioProject..Housing


-- Change Existing Date Format

Select SaleDateConverted, CONVERT(Date,SaleDate)
from PortfolioProject..Housing

ALTER TABLE Housing
Add SaleDateConverted Date;

Update Housing
Set SaleDateConverted = CONVERT(Date,SaleDate)

-- Populate Property Address Data

Select *
From PortfolioProject..Housing
Order By ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject..Housing a
Join PortfolioProject..Housing b
	On a.ParcelID = b.ParcelID
	And a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

Update a
Set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject..Housing a
Join PortfolioProject..Housing b
	On a.ParcelID = b.ParcelID
	And a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

-- Seperating Address into two individual columns

Select *
From PortfolioProject..Housing

Select 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as City
From PortfolioProject..Housing

ALTER TABLE Housing
Add PropertySplitAddress Nvarchar(255);

Update Housing
Set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

ALTER TABLE Housing
Add PropertySplitCity Nvarchar(255);

Update Housing
Set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))

-- Seperating address using PARSENAME

Select OwnerAddress
From PortfolioProject..Housing


Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From PortfolioProject..Housing

ALTER TABLE Housing
Add OwnerSplitAddress Nvarchar(255);

ALTER TABLE Housing
Add OwnerSplitCity Nvarchar(255);

ALTER TABLE Housing
Add OwnerSplitState Nvarchar(255);

Update Housing
Set OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)

Update Housing
Set OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)

Update Housing
Set OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)

-- Case Statement for changing 'Y' to 'YES' and 'N' to 'No' in a column

Select Distinct(SoldAsVacant), COUNT(SoldAsVacant)
From PortfolioProject..Housing
Group by SoldAsVacant
Order by 2

Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' Then 'Yes'
	   When SoldAsVacant = 'N' Then 'No'
	   Else SoldAsVacant
	   End
From PortfolioProject..Housing


Update Housing
Set SoldAsVacant = CASE When SoldAsVacant = 'Y' Then 'Yes'
	   When SoldAsVacant = 'N' Then 'No'
	   Else SoldAsVacant
	   End


-- Delete Unused Columns (Useful when creating views)

Select *
From PortfolioProject..Housing


ALTER TABLE PortfolioProject..Housing
DROP COLUMN PropertyAddress, SaleDate, OwnerAddress, TaxDistrict