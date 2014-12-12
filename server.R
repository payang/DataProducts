library(shiny)
library(stringr)

options(shinyapps.http.verbose = TRUE)
options(shiny.maxRequestSize=30*1024^2)

# Establish list of programme's priority countries
list.countries = c(
	"Afghanistan"
    ,"Bangladesh"
    ,"Ethiopia"
    ,"Haiti"
    ,"Malawi"
    ,"Mali"
    ,"Mozambique"
    ,"Nigeria"
    ,"Sudan"
    ,"Tanzania")

# Load data
# Obtaining data on allocated program funds

READ_Fun <- function(x) {
  if(!file.exists(x)) {
    FILE_URL <- paste('http://www.acdi-cida.gc.ca/INET/IMAGES.NSF/vLUImages/Open%20Data/$file/',x,sep="")
    download.file(FILE_URL,x,mode="wb")
  }
# Read CSV file
  df <- read.csv(paste("./",x, sep=""), stringsAsFactors=FALSE, header=FALSE, skip=1)
# Reduce dataset to programme's priority countries  
  df <- df[str_trim(df[,12]) %in% list.countries,]
# Reduce columns used to absolute minimum
  df <- data.frame(df[12],df[26])
  colnames(df) <- c("Country","MNCH_amount_spent")
# To handle a situation where no programme money was spent Sudan in 2011-2012
  df <- rbind(df,list('Sudan',0))
# Convert country name to factor for sum function
  df[1] <- factor(df[[1]])
  
  return(df)
}

# Call function to read various CSV files
# Obtaining numbers from DFATD Canada
df.2010.2011 <- READ_Fun("MNCH-2010-2011.csv")
df.sum.2010.2011 <- tapply(df.2010.2011[[2]],INDEX=df.2010.2011[[1]],sum)
rm(df.2010.2011)
df.2011.2012 <- READ_Fun("MNCH-2011-2012.csv")
df.sum.2011.2012 <- tapply(df.2011.2012[[2]],INDEX=df.2011.2012[[1]],sum)
rm(df.2011.2012)
df.2012.2013 <- READ_Fun("MNCH-2012-2013.csv")
df.sum.2012.2013 <- tapply(df.2012.2013[[2]],INDEX=df.2012.2013[[1]],sum)
rm(df.2012.2013)

df.funds <- data.frame(Country=list.countries,
	X2010=df.sum.2010.2011,
	X2011=df.sum.2011.2012,
	X2012=df.sum.2012.2013)

# Obtaining total population
# http://data.worldbank.org/indicator/SP.POP.TOTL/countries?display=default
#download.file("http://api.worldbank.org/v2/en/indicator/sp.pop.totl?downloadformat=csv","sp.pop.totl_Indicator_en_csv_v2.zip",mode="wb")
#unzip("sp.pop.totl_Indicator_en_csv_v2.zip","sp.pop.totl_Indicator_en_csv_v2.csv")
df.population <- read.csv("./sp.pop.totl_Indicator_en_csv_v2.csv",stringsAsFactors=FALSE,skip=2, header=TRUE)
df.population <- df.population[,c("Country.Name","X2010","X2011","X2012")]
df.population <- df.population[df.population$Country %in% list.countries,]
	
# Obtaining birth rate (crude) per 1000 people
# http://data.worldbank.org/indicator/SP.DYN.CBRT.IN/countries?display=default
#download.file("http://api.worldbank.org/v2/en/indicator/sp.dyn.cbrt.in?downloadformat=csv","sp.dyn.cbrt.in_Indicator_en_csv_v2.zip",mode="wb")
#unzip("sp.dyn.cbrt.in_Indicator_en_csv_v2.zip","sp.dyn.cbrt.in_Indicator_en_csv_v2.csv")
df.birth.rate <- read.csv("./sp.dyn.cbrt.in_Indicator_en_csv_v2.csv",stringsAsFactors=FALSE,skip=2, header=TRUE)
df.birth.rate <- df.birth.rate[,c("Country.Name","X2010","X2011","X2012")]
df.birth.rate <- df.birth.rate[df.birth.rate$Country %in% list.countries,]

# Obtaining maternal mortality ratio (modeled estimate, per 100,000 live births)
# http://api.worldbank.org/v2/en/indicator/sh.sta.mmrt?downloadformat=csv
#download.file("http://api.worldbank.org/v2/en/indicator/sh.sta.mmrt?downloadformat=csv","sh.sta.mmrt_Indicator_en_csv_v2.zip",mode="wb")
#unzip("sh.sta.mmrt_Indicator_en_csv_v2.zip","sh.sta.mmrt_Indicator_en_csv_v2.csv")
df.maternal.mortality.ratio <- read.csv("./sh.sta.mmrt_Indicator_en_csv_v2.csv", skip=2, header=TRUE)
df.maternal.mortality.ratio <- df.maternal.mortality.ratio[,c("Country.Name","X2010","X2011","X2012","X2013")]
df.maternal.mortality.ratio <- df.maternal.mortality.ratio[df.maternal.mortality.ratio$Country.Name %in% list.countries,]
df.maternal.mortality.ratio$X2011 <- df.maternal.mortality.ratio$X2010+(df.maternal.mortality.ratio$X2013-df.maternal.mortality.ratio$X2010)*1/3
df.maternal.mortality.ratio$X2012 <- df.maternal.mortality.ratio$X2010+(df.maternal.mortality.ratio$X2013-df.maternal.mortality.ratio$X2010)*2/3

# Calculating number of births (birth rate * population * adjustment)
df.births <- data.frame(Country=df.population$Country.Name,
	X2010=df.birth.rate$X2010*df.population$X2010/1000,
	X2011=df.birth.rate$X2011*df.population$X2011/1000,
	X2012=df.birth.rate$X2012*df.population$X2012/1000
	)

# Calculating number of maternal deaths (maternal mortality ratio * live births * adjustment)
df.maternal.deaths <- data.frame(Country=df.maternal.mortality.ratio$Country.Name,
	X2010=df.births$X2010*df.maternal.mortality.ratio$X2010/100000,
	X2011=df.births$X2011*df.maternal.mortality.ratio$X2011/100000,
	X2012=df.births$X2012*df.maternal.mortality.ratio$X2012/100000
	)

# Calculating funds per live birth
df.funds.birth <- data.frame(Country=df.funds$Country,
	X2010=df.funds$X2010/df.births$X2010,
	X2011=df.funds$X2011/df.births$X2011,
	X2012=df.funds$X2012/df.births$X2012)
	
# Calculating funds per maternal deaths
df.funds.maternal.death <- data.frame(Country=df.funds$Country,
	X2010=df.funds$X2010/df.maternal.deaths$X2010,
	X2011=df.funds$X2011/df.maternal.deaths$X2011,
	X2012=df.funds$X2012/df.maternal.deaths$X2012)
	
# Define server logic required to draw a bar plot
shinyServer(function(input, output) {

  output$distPlot <- renderPlot({
    var.df <- paste("df.sum.",gsub("-",".",input$year),sep="")
    dt <- get(var.df)
#    dt <- tapply(df[[2]],INDEX=df[[1]],sum)
    
    bp <- barplot(dt,main=paste("Year: ",gsub("[.]","-",input$year),sep="")
		,las=2,cex.axis=.75,cex.names=.75)
    mtext(side=1,"Country",line=4,cex=1.25)
    mtext(side=2,"Funds allocated ($)",line=3,cex=1.25)
  })
  output$radval <- renderPrint({input$radio})
  output$distPlot2 <- renderPlot({
    if (input$year=="2010-2011") { i=2 
	} else if (input$year=="2011-2012") { i=3 
	} else if (input$year=="2012-2013") { i=4 
	}
  if (input$radio=="Births") {
    dt <- df.funds.birth[,i]
    bp <- barplot(dt,main=paste("Year: ",gsub("[.]","-",input$year),sep="")
		,las=2,cex.axis=.75,cex.names=.75)
    mtext(side=1,"Country",line=4,cex=1.25)
    mtext(side=2,"Funds allocated per birth ($)",line=3,cex=1.25)
	}
  else if (input$radio=="Maternal mortality") {
    dt <- df.funds.maternal.death[,i]
    bp <- barplot(dt,main=paste("Year: ",gsub("[.]","-",input$year),sep="")
		,las=2,cex.axis=.75,cex.names=.75)
    mtext(side=1,"Country",line=4,cex=1.25)
    mtext(side=2,"Funds allocated per maternal death ($)",line=3,cex=1.25)
	}
  })
  output$view <- renderTable({
		df.funds
  }, include.rownames=FALSE)
  output$view2 <- renderTable({
		df.births
  }, include.rownames=FALSE)
  output$view3 <- renderTable({
		df.maternal.deaths
  }, include.rownames=FALSE)
})
