library(shiny)

shinyUI(fluidPage(

  # Application title
  titlePanel("Maternal, Newborn and Child Health"),

  # Sidebar with a slider input for the number of bins
  sidebarLayout(
    sidebarPanel(
	  h6("Please allow up to one minute for data to load."),
      selectInput("year",h5("Choose a year:"),
                  choices = c("2010-2011","2011-2012","2012-2013")),
      radioButtons("radio",h5("Select a ratio:"),
		choices=c("Births","Maternal mortality")
	  ),
	  h6("Data sources:"),
	  tags$div(class="header", checked=NA,
		tags$table(),
		tags$td(img(src="DFATD.jpg")),
		tags$td(img(src="MNCH.png")),
		tags$td(img(src="UNICEF.png",width=100)),
		tags$td(img(src="WorldBank.png",width=100)),
		tags$table()
		)
    ),

    # Show a plot of the generated distribution
    mainPanel(
 tabsetPanel(type="tabs",
    tabPanel("About", h3("Objective"),
		"In 2010, Canada announced the ",
		tags$b("Muskoka Initiative"),
		".  The Initiative sought to mobilize global action to reduce maternal mortality",
		"and improve the health of mothers and children in the world's poorest countries.",
		"Hundreds of thousands of women die each year due to complications ",
		"consecutive to pregnancy or childbirth.",
		"In addition, 6.6 million children died before reaching the age of five in 2012.",
		tags$br(),
		"Over the period covering 2010 to 2015, $1.1 billion will be added to $1.75 billion",
		"budgeted to improve the situation of mothers and children.",
		h3("Focus on three paths"),
		tags$li("Strengthening health systems"),
		tags$li("Reducing the burden of leading diseases"),
		tags$li("Improving nutrition"),
		h3("Focus on 10 countries"),
		tags$li("Afghanistan"),
		tags$li("Bangladesh"),
		tags$li("Ethiopia"),
		tags$li("Haiti"),
		tags$li("Malawi"),
		tags$li("Mali"),
		tags$li("Mozambique"),
		tags$li("Nigeria"),
		tags$li("Sudan"),
		tags$li("Tanzania")
		),
    tabPanel("MNCH", plotOutput("distPlot")),
    tabPanel("By ratio", plotOutput("distPlot2")),
    tabPanel("Data", 	  h5("MNCH funds spent"),
	  tableOutput("view"),
	  h5("Live births"),
	  tableOutput("view2"),
	  h5("Maternal deaths (modeled linear estimate)"),
	  tableOutput("view3")
		)
	)
#	h1(verbatimTextOutput("radval")),
#      plotOutput("distPlot"),
#      plotOutput("distPlot2"),
 ))
))

