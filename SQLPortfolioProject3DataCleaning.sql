--Data Cleaning Project


Select *
From Portfolio_Project_2.dbo.NashvilleHousing


--Standardize Date Format

Select SaleDateConverted, CONVERT(Date,SaleDate)
From Portfolio_Project_2.dbo.NashvilleHousing


Alter Table NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
Set SaleDateConverted = CONVERT(date,SaleDate)

---------------------------------------------------------------------------------------------------------------

--Populate Property Address Data

Select *
From NashvilleHousing
Where PropertyAddress is Null


Select *
From NashvilleHousing
--Where PropertyAddress is Null
order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From Portfolio_Project_2.dbo.NashvilleHousing a
JOIN Portfolio_Project_2.dbo.NashvilleHousing b
on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is Null

Update a
Set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From Portfolio_Project_2.dbo.NashvilleHousing a
JOIN Portfolio_Project_2.dbo.NashvilleHousing b
on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is Null


--Confirm table updated correctly with no Null for PropertyAddress
Select *
From NashvilleHousing
Where PropertyAddress is Null



-- Breaking Out Addres int Individual Columns

Select PropertyAddress
From NashvilleHousing

Select
SUBSTRING(PropertyAddress, 1, Charindex(',', PropertyAddress) -1) as Address
, SUBSTRING(PropertyAddress, Charindex(',', PropertyAddress) +1, LEN(PropertyAddress)) as Address
From NashvilleHousing


Alter Table NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update NashvilleHousing
Set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, Charindex(',', PropertyAddress) -1)

Alter Table NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update NashvilleHousing
Set PropertySplitCity = SUBSTRING(PropertyAddress, Charindex(',', PropertyAddress) +1, LEN(PropertyAddress)) 


Select*
From NashvilleHousing


Select OwnerAddress
From NashvilleHousing


Select
Parsename(Replace(OwnerAddress, ',', '.') ,3)
,Parsename(Replace(OwnerAddress, ',', '.') ,2)
,Parsename(Replace(OwnerAddress, ',', '.') ,1)
From NashvilleHousing


Alter Table NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
Set OwnerSplitAddress = Parsename(Replace(OwnerAddress, ',', '.') ,3)

Alter Table NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
Set OwnerSplitCity = Parsename(Replace(OwnerAddress, ',', '.') ,2) 


Alter Table NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update NashvilleHousing
Set OwnerSplitState = Parsename(Replace(OwnerAddress, ',', '.') ,1)



--Change Y and N to Yes and No in Sold as Vacant

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From NashvilleHousing
Group by SoldAsVacant
order by 2

Select SoldAsVacant
, Case When SoldAsVacant = 'Y' Then 'Yes'
	   When SoldAsVacant = 'N' Then 'No'
	   Else SoldAsVacant
	   End
From NashvilleHousing

Update NashvilleHousing
Set SoldAsVacant =  Case When SoldAsVacant = 'Y' Then 'Yes'
	   When SoldAsVacant = 'N' Then 'No'
	   Else SoldAsVacant
	   End
From NashvilleHousing


-----------------------------------------------------------------------------------------------------------------------------------------------------------

--Remove Duplicates

With RowNumCTE AS(
Select *,
	ROW_NUMBER() Over (
	Partition By ParcelID,
				PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				Order By
					UniqueID
					) row_num
From NashvilleHousing
--Order by ParcelID
)
Delete 
From RowNumCTE
Where row_num > 1
--order by PropertyAddress

------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Delete Unused Columns

Select *
From NashvilleHousing

Alter Table NashvilleHousing
Drop Column OwnerAddress, TaxDistrict, PropertyAddress

Alter Table NashvilleHousing
Drop Column

