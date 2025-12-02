# PlatinumRx Assignment

This repository contains my complete submission for the PlatinumRx Assignment, including SQL scripts, Python scripts, and Spreadsheet-based analysis.

---

## 📁 Repository Structure

PlatinumRx_Assignment/
│
├── SQL/
│ ├── hotel_system.sql
│ ├── clinic_system.sql
│
├── Python/
│ ├── 01_Time_Converter.py
│ └── 02_Remove_Duplicates.py
│
├── Spreadsheet/
│ └── Tickets_Feedbacks.xlsx (or Tickets_Feedbacks_with_formulas.xlsx)
│
└── README.md
---

## 🧠 Phase 1 — SQL Proficiency

### ✔ Hotel Management System (Part A)
- Last booked room per user  
- Total billing amount for bookings in November 2021  
- Bills > 1000 (October 2021)  
- Most & least ordered item each month  
- Second highest bill amount per month  

📄 SQL file: `SQL/hotel_system.sql`  
💡 Uses window functions + aggregates.

---

### ✔ Clinic Management System (Part B)
- Revenue by sales channel  
- Top 10 customers by spend  
- Month-wise revenue, expense, profit, and status  
- Most profitable clinic per city  
- Second least profitable clinic per state  

📄 SQL file: `SQL/clinic_system.sql`

---

## 🐍 Phase 2 — Python Proficiency

### 1️⃣ **Convert minutes to human-readable format**
File: `Python/01_Time_Converter.py`

### 2️⃣ **Remove duplicates from string (using loop only)**
File: `Python/02_Remove_Duplicates.py`

---

## 📊 Phase 3 — Spreadsheet Proficiency

### ✔ Sheets included
- **Tickets sheet** → ticket details  
- **Feedbacks sheet** → user feedback  
- `ticket_created_at` auto-populated via lookup  
- Helper columns for:
  - created_date  
  - closed_date  
  - created_hour  
  - closed_hour  
  - same_day_flag  
  - same_hour_flag  

### ✔ Analysis completed
#### 1. Populate `ticket_created_at`
Used `INDEX/MATCH`:

