library(shiny)
library(magrittr)
library(tm)
library(stringr)


source("./input_processor.R")

shinyServer(function(input, output){

  candidates<- reactive({
  candidates<- prediction(input$user_text)[,1]
  })
  output$candidates<- renderTable({candidates()}, include.colnames=FALSE)
})