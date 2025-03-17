library(httr)
library(jsonlite)
library(dplyr)
library(tidyverse)
library(shiny)
library(ggplot2)
library(plotly)

#load in data
df <- fromJSON("data.json")


#layout
heroes <- (df|>select(name))[[1]]

ui <- page_fillable(
  id="layout",
#  style = " background: url('background.png');
#          background-position: center;
#          background-size: contain;
#          background-repeat: no-repeat;
#          background-color:rgba(255, 255, 255, 0.9);
#          background-blend-mode: saturation;",
  navbarPage(
    title = "Mobile Legends Dashboard",
    theme = bs_theme(version = 5, bootswatch = "journal"),
    bg = "#007aff",
    position = "fixed-top"
  ),
  fluidRow(
    style="margin-top: 10px; overflow: visible;",
    layout_columns(
      div(
        id = "hero_filters",
        selectInput(
          inputId = "hero",
          label = "Select a Hero",
          choices = heroes,
          selected = heroes[1]),
        br(),
        div(
          id = "heroid",
          imageOutput("hero_img", height="100%"),
          style = "text-align: center;",
          br(),
          div(
            id = "sort_label",
            style = "display: flex; 
          align-items: center; 
          text-align: center;
          justify-content: center;",
            uiOutput("role1"),
            uiOutput("role2")
          ),
          br(),
          div(
            uiOutput("lanes"),
            uiOutput("speciality"),
            uiOutput("story"))
        )
      ),
      card(
        style = "height: 350px;
        align-items: middle; 
        justify-content: center;",
        id = "hero_plot_card",
        plotlyOutput("hero_dist", height = "25%")
      )
    )
  ),
  fluidRow(
    layout_columns(
      card(
        style = "height: 250px;",
        uiOutput("pick_rate"),
        uiOutput("win_rate"),
        uiOutput("ban_rate"),
      ),
      card(
        style = "height: 250px;",
        id = "rank_card",
        tableOutput("hero_ranking")
      )
    )
  )
)
