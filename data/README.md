# Data (`data/`)

**IMPORTANT: Do not push any data to public repositories like GitHub.** This folder is for local data storage only. Pushing data could lead to serious privacy violations and compromise sensitive information.

This directory is dedicated to storing the data used for this project. Please adhere to the following guidelines to ensure data integrity and security:

**Key Guidelines:**

- **Raw Data Storage:**
  - Save the original, raw data file received (e.g., from the client) directly in this folder.
  - Use a clear and descriptive identifier in the filename to indicate it's the original, untouched data (e.g., `data_raw.csv`, `original_data.xlsx`).
- **Never Modify Original Data:**
  - **DO NOT** alter the original raw data file in any way.
  - Maintaining an untouched copy is crucial for having a reliable backup and ensuring the integrity of the source data.
- **Processing and Derived Data:**
  - Create scripts within the `src/` folder to process the data.
  - If you save processed or derived data, store it within this `data/` folder as well.
  - **Crucially, use different filenames for processed data** to distinguish it from the original raw data (e.g., `data_processed.csv`, `cleaned_data.rds`).

**In summary:**

This folder is your local workspace for data. Keep the original data pristine and clearly separate from any processed versions. **Always ensure this folder is excluded from version control (see the project's** `**.gitignore**` **file).**

If you have any questions about data handling procedures, please consult your mentor.
