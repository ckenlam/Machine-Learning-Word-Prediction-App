library(shiny)
library(markdown)


shinyUI(
  
  navbarPage("Data Science Specialization SwiftKey Capstone",
             tabPanel("Application",
                      
                      titlePanel("Word Prediction App"),
                      
                      sidebarLayout(
                        
                        sidebarPanel( 
                        helpText("Type a few words or a fragment sentence and press ENTER to start predicting the next word."),
                        textInput("user_text","Input message:", "Type something")
                                
                        ),
                        
                        mainPanel(
                        helpText("Here are the five most possible predictions:"),
                        tableOutput("candidates")

                        )
                      )
              ),
             
             tabPanel("About",
                      mainPanel(
                        includeMarkdown("include.md")
                      )
              )
  )
)