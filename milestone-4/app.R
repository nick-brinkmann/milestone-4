#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(tidyverse)
library(dplyr)
library(lubridate)
all_games <- readRDS("all_games_oct21.RDS")

ui <- navbarPage(
    "Analyzing My Online Chess Games",
    tabPanel("Plot",
             fluidPage(
                 titlePanel("Plots"),
                 sidebarLayout(
                     sidebarPanel(
                         sliderInput("date",
                                     "Starting date: ",
                                     min = min(all_games$Date),
                                     max = max(all_games$Date),
                                     value = min(all_games$Date))),
                     mainPanel(plotOutput("distPlot")))
             )),
    tabPanel("Discussion",
             titlePanel("Methodology"),
             p("Using the R package 'bigchess', I was able to download all
               of my games from both websites. I added a few details through
               minor manipulations and cleaning of the data.")),
    tabPanel("About", 
             titlePanel("About"),
             h3("Project Background and Motivations"),
             p("Hello! I have been a chess enthusiast since I learned the game at the age of 6.
               Following a competitive stint in my early youth, I took a long hiatus from the game,
               and only became seriously interested in chess again in 2018. At that point,
               I made accounts on the two largest chess websites: chess.com &
               lichess.org. This project visualizes trends from all 8000+ of my games since
               then. \n Over the past two years, my (online) rating has increased
               dramatically, from lows of around 1300 to highs of over 2000 Elo.
               I hope to become an expert (2000 Elo in classical, over-the-board
               chess) sometime in the next few years."),
             h3("About Me"),
             p("My name is Nick Brinkmann and I study Applied Mathematics. 
             You can reach me at nickbrinkmann@college.harvard.edu."),
             p("My Github repo  for this Milestone can be found at: https://github.com/nick-brinkmann/milestone-4.")))


# Define server logic required to draw a histogram
server <- function(input, output) {

    output$distPlot <- renderPlot({
        #plot Elo vs time
        all_games %>%
            filter(Date > ymd(input$date)) %>%
        ggplot(aes(x = Date, y = my_elo)) +
            geom_smooth() +
            facet_wrap(~ website + format) +
            labs(title = "Elo Rating Over Time, by Website and Time Control", 
                 y = "Elo Rating",
                 caption = "Source: Self-collected data") +
            ylim(1200,2100) +
            theme_bw()
            
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
