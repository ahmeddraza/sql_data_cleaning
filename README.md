# sql_data_cleaning
This project involves cleaning and transforming a raw, unstructured laptop dataset using **pure SQL** queries. The goal was to make the dataset analysis-ready by fixing inconsistencies, normalizing values, and extracting useful features — without using Python or external tools.

---

## 📁 Dataset Overview

The original dataset contained issues such as:

- Merged columns (e.g., screen resolution, CPU, memory)
- Mixed units (e.g., “GHz”, “GB”, “kg”)
- Null values and potential duplicates
- Ambiguous column names
- Inconsistent data formats

---

## 🧠 Objectives

✅ Clean and structure the dataset using SQL  
✅ Extract meaningful features (like CPU brand, storage type, GPU model)  
✅ Normalize formats for consistency and accuracy  
✅ Make the data analysis-ready for further visualization or modeling  

---

## 🛠️ SQL Cleaning Steps

### 🔹 1. General Cleaning
- Renamed `Unnamed: 0` ➝ `ItemNo`
- Dropped rows with NULL values
- Removed duplicates if any
- Standardized numeric formats (e.g., Inches ➝ Decimal)

### 🔹 2. Feature Extraction & Transformation

#### 📺 **Screen Resolution**
- Split into `ResolutionHeight` and `ResolutionWidth`
- Extracted `TouchScreen` as a separate boolean column

#### 🧠 **CPU**
- Split into `CpuBrand`, `CpuName`, and `CpuSpeed`
- Removed “GHz” and converted speed to float

#### 💾 **Memory & Storage**
- Separated `Memory` into:
  - `MemoryType` (e.g., SSD, HDD, Hybrid)
  - `PrimaryStorage` and `SecondaryStorage` (converted TB to GB)
  
#### 🎮 **GPU**
- Extracted `GpuBrand` and `GpuName`

#### 💻 **Operating System**
- Normalized values like “macOS” ➝ “Mac OS”, “No OS” ➝ “N/A”

#### ⚖️ **Weight**
- Removed "kg" and converted to float

---

## 📊 Final Columns (Sample)

| ItemNo | Company | TypeName | Inches | ResolutionWidth | ResolutionHeight | TouchScreen | CpuBrand | CpuName | CpuSpeed | Ram | MemoryType | PrimaryStorage | SecondaryStorage | GpuBrand | GpuName | OpSys | Weight | Price |
|--------|---------|----------|--------|------------------|------------------|--------------|-----------|---------|-----------|-----|-------------|----------------|------------------|-----------|----------|--------|--------|--------|
| 0      | Apple   | Ultrabook| 13.3   | 1600             | 2560             | No           | Intel     | Core i5 | 2.3       | 8   | SSD         | 128            | 0                | Intel     | Iris Plus Graphics 640 | Mac OS | 1.37   | 71378.68 |

---

## 🧠 What I Learned

- Deep understanding of string functions in SQL (`SUBSTRING_INDEX`, `REGEXP_SUBSTR`, `REPLACE`)
- SQL data wrangling best practices
- Feature engineering using only SQL logic
- Importance of consistent and clean data for analysis

---

## 📌 Next Steps

This cleaned dataset can now be used for:
- Exploratory Data Analysis (EDA)
- Visualizations with Python (Seaborn/Matplotlib)
- Machine Learning modeling
- Dashboards in Power BI or Tableau

---
