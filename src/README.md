# Source Code (`src/`)

This directory contains the main R scripts for the project.

## Structure

The `src/` directory is organized as follows:

*   **`main.R`**: This is the main script that will be executed to run the project. It might orchestrate the execution of other scripts or contain the core logic.
*   **`functions/`**:  This folder is for storing reusable R functions. Organizing functions here helps keep your main script cleaner and more readable.
    *   `data_loading.R`: Functions related to loading and reading data.
    *   `data_processing.R`: Functions for cleaning, transforming, and manipulating data.
    *   `analysis.R`: Functions that perform the core analysis or modeling tasks.
    *   `visualization.R`: Functions for creating plots and visualizations.
*   **`tests/`**:  This directory can contain R scripts for testing your functions and code. You might use packages like `testthat` for this.
    *   `test_data_processing.R`: Tests for functions in `functions/data_processing.R`.
    *   `test_analysis.R`: Tests for functions in `functions/analysis.R`.

**Note:** This is a suggested structure, and for a simpler project, you might not need all of these folders. Feel free to adjust it as needed. For simpler projects, you might just have `main.R` and potentially a few functions directly in the `src/` folder (specifically, for STAT 450, you do not need a `tests` folder -- unless you want to!)

## Guidelines for Writing R Code

*   **Follow the tidyverse style guide:**  If you're using packages from the tidyverse (like `dplyr`, `ggplot2`), aim to follow their style conventions for readability and consistency.
*   **Write clear and well-commented code:** Explain what your code is doing, especially for complex steps.
*   **Keep functions focused:** Each function should ideally perform a single, logical task.
*   **Consider using RStudio projects:**  Encourage students to use RStudio projects for better organization and workflow management.
*   **Use version control effectively:** Make regular commits with informative messages.

## Getting Started

1. Navigate to the `src/` directory.
2. Open the `main.R` script to see the main workflow of the project.
3. Explore the `functions/` directory to understand the different functions used in the project.
4. If there's a `tests/` directory, you can run the test scripts to check the functionality of the code.

If you have any questions about the project structure or R coding practices, please ask!
