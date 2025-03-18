library(httr)
library(jsonlite)
library(dplyr)
library(tidyverse)
library(shiny)
library(ggplot2)
library(plotly)
library(bslib)

#load in data
df <- fromJSON("data/data.json")

#layout
heroes <- (df|>select(name))[[1]]

ui <- page_fillable(
  id="layout",
  style = "background-position: center;
          background-size: contain;
          background-repeat: no-repeat;
          background-color:rgba(255, 255, 255, 0.9);
          background-blend-mode: saturation;",
  navbarPage(
    title = span("Mobile Legends Dashboard",style=" color:#ff9f18"),
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
          inputId = "hero_name",
          label = "Select a Hero",
          choices = heroes,
          selected = heroes[126]),
        br(),
        div(
          id = "heroid",
          uiOutput("hero_img", height="100%"),
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
          div()
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
        uiOutput("lanes"),
        uiOutput("speciality"),
        uiOutput("story"),
        uiOutput("pick_rate"),
        uiOutput("win_rate"),
        uiOutput("ban_rate"),
      ),
      card(
        id = "rank_card",
        plotlyOutput("hero_ranking")
      )
    )
  )
)
# Server side callbacks/reactivity
server <- function(input, output, session) {
  # Hero Image
  output$hero_img <- renderUI({
    hero_rank <- which(heroes == input$hero_name)
    hero_id <- df|>filter(rank==hero_rank)
    hero_pic <- hero_id$smallmap
    div(id="hero",
        tags$img(src = hero_pic)
    ) 
  })
  
  # Hero lane
  output$lanes <- renderUI({
    hero_rank <- which(heroes == input$hero_name)
    hero_id <- df|>filter(rank==hero_rank)
    h4(hero_id$Lane1)
  })
  
  # Speciality
  output$speciality <- renderUI({
    hero_rank <- which(heroes == input$hero_name)
    hero_id <- df|>filter(rank==hero_rank)
    h4(paste(hero_id$Spec1,hero_id$Spec2))
  })
  
  # Speciality
  output$story <- renderUI({
    hero_rank <- which(heroes == input$hero_name)
    hero_id <- df|>filter(rank==hero_rank)
    h4(paste(hero_id$story))
  })
  
  # Role 1
  output$role1 <- renderUI({
    hero_rank <- which(heroes == input$hero_name)
    hero_id <- df|>filter(rank==hero_rank)
    role1 <- hero_id$Role1
    span(
      style = paste("border: 2px solid black;",
                    "; padding: 10px;",
                    "margin-right: 10px;",
                    "color: #B7B7CE;",
                    "font-weight: bold;",
                    "text-align: center;",
                    "width: 120px;"),
      str_to_sentence(role1))
  })
  
  # Role2 2
  output$role2 <- renderUI({
    hero_rank <- which(heroes == input$hero_name)
    hero_id <- df|>filter(rank==hero_rank)
    role2 <- hero_id$Role2
    if (role2 != ""){
      span(
        style = paste("border: 2px solid black;",
                      "background-color:",
                      "; padding: 10px;",
                      "margin-right: 10px;",
                      "color: #B7B7CE;",
                      "font-weight: bold;",
                      "text-align: center;",
                      "width: 120px;"),
        str_to_sentence(role2))
    }
  })
  
  # Hero distribution
  output$hero_dist <- renderPlotly({
    hero_rank <- which(heroes == input$hero_name)
    hero_id <- df|>filter(rank==hero_rank)
    hero_plot_chart <- df|>
      ggplot(aes(x = name,y=main_hero_win_rate,color=Role1))+
      geom_point(alpha=0.75)+
      geom_point(data = hero_id,aes(x = name,y=main_hero_win_rate),color="red",size=3)+
      theme_minimal()+
      theme(axis.text.x=element_blank(), 
            axis.ticks.x=element_blank()) +
      xlab("Heroes")+
      ylab("Win Rate")
      scale_fill_brewer(palette="Dark2")
    ggplotly(hero_plot_chart, tooltip = c("name","main_hero_win_rate")) 
  })
  
  # Winrate 
  output$win_rate <- renderUI({
    hero_rank <- which(heroes == input$hero_name)
    hero_id <- df|>filter(rank==hero_rank)
    
      h4(span("Win Rate:",
             style="font-weight: bold;"),
        span(paste(hero_id$main_hero_win_rate*100,"%")))
  })
  
  # Pick rate 
  output$pick_rate <- renderUI({
    hero_rank <- which(heroes == input$hero_name)
    hero_id <- df|>filter(rank==hero_rank)
    
    h4(span("Pick Rate:",
             style="font-weight: bold;"),
        span(paste(hero_id$main_hero_appearance_rate*100,"%")))
  })
  # Ban rate 
  output$ban_rate <- renderUI({
    hero_rank <- which(heroes == input$hero_name)
    hero_id <- df|>filter(rank==hero_rank)
    
    h4(span("Ban Rate:",
             style="font-weight: bold;"),
        span(paste(hero_id$main_hero_ban_rate*100,"%")))
  })
  # Rank Chart
  output$hero_ranking <- renderPlotly({
    hero_rank <- which(heroes == input$hero_name)
    hero_id <- df|>filter(rank==hero_rank)
    hero_ranks <- df|>
      ggplot(aes(x = name,y=rank))+
      geom_bar(stat = "identity",fill="gold")+
      geom_bar(data=hero_id,stat = "identity",fill="red")+
      theme_minimal()+
      theme(axis.text.x=element_blank(), 
            axis.ticks.x=element_blank()) +
      xlab("Heroes")+
      ylab("Ranking")
    scale_fill_brewer(palette="Dark2")
    ggplotly(hero_ranks, tooltip = c("name","rank")) 
  })
}

# Run the app/dashboard
shinyApp(ui, server)