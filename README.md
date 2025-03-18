# MLBBDash
This is a dashboard created in shiny using R language about Mobile Legends Bang Bang

----

# Motivation

Target audience: Mobile Legends Players of all levels

Mobile Legends: Bang Bang (MLBB) is a wildly popular multiplayer online battle arena (MOBA) 
MLBB pits two teams of five players against each other in a classic MOBA format.
The goal is to destroy the opposing team's base, known as the "main crystal," located at the heart of their territory. Players control unique heroes, each with distinct roles, abilities, and playstyles.

----

# App Description


![video/demo.mov](https://github.com/agamsanghera/MLBBDash/blob/main/video/demo.mov)

----

# Installation Instructions

This application is deployed online [here](https://agamsanghera.shinyapps.io/MLBB/)

If you would like to run it locally, follow these steps:

1. Clone this repository into a folder by using the following command in the desired directory:

```bash
git clone https://github.com/agamsanghera/MLBBDash.git
```

2. Open [R Studio](https://posit.co/download/rstudio-desktop/) and navigate the to cloned repository.

3. Now that you have opened the project, you now need to install the dependencies. Use the following command in the R console to install these:

```R
renv::restore()
```

4. Once these dependencies are installed, we can now simply run the app! To do this, use this command in the R console:

```R
shiny::runApp('MLBB')
```

Alternatively, you can navigate to the `src` folder, open the `app.R` file and click "Run App" on the R Studio GUI.

5. That's it! Your app should now pop-up in a window or your browser!

----

# Attributions

The dataset obtained for this project was downloaded from [MLBB API](https://mlbb-api-docs.ridwaanhall.me), and the wrangling was done manually to create a dataset.


