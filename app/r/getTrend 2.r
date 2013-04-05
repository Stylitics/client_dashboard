library(RPostgreSQL)
library(lubridate)
library(xlsx)
library(rjson)


# Create a sample based on the following parameters. A table called "selected_items" is added to the DB

population <- vector("list", 25)
names(population) <- c("gender", "ageRange", "studentOpt", "locationOpt", "expensiveOpt", "priceRange", 
                       "influencerOpt", "staffOpt", "styleOpt", "eventType", "colorOpt", "retailerOpt", 
                       "brandOpt", "patternOpt", "fabricOpt", "sortOpt", "studentOpt", "styleTxt", 
                       "colorTxt", "brandTxt", "startDateTxt", "endDateTxt", "retailerTxt", "patternTxt", 
                       "fabricTxt")

population$gender <- "Female"
population$ageRange <- c(10,100) # 73
population$studentOpt <- "All"
population$locationOpt <- "All"
population$expensiveOpt <- "All"
population$priceRange <- c("0", "100000")
population$influencerOpt <- "Include"
population$staffOpt <- "Include"
population$styleOpt <- "All"
population$eventType <- "All"
population$colorOpt <- "All"
population$retailerOpt <- "All"
population$brandOpt <- "All"
population$patternOpt <- "All"
population$fabricOpt <- "All"
population$sortOpt <- "User ID"
population$studentOpt <- "All"
population$styleTxt <- ""
population$colorTxt <- ""
population$brandTxt <- ""
population$startDateTxt <- as.Date(now() - months(6))
population$endDateTxt <- as.Date(now())
population$retailerTxt <- "" 
population$patternTxt <- ""
population$fabricTxt <- ""

lQuery <- createSample(p=population)

ageGroups <- c(" (selected_items.age>=0) ",
               " (selected_items.age>=13 AND selected_items.age<=17) ",
               " (selected_items.age>=18 AND selected_items.age<=22) ",
               " (selected_items.age>=13 AND selected_items.age<=22) ",
               " (selected_items.age>=23 AND selected_items.age<=27) ",
               " (selected_items.age>=28 AND selected_items.age<=34) ",
               " (selected_items.age>=35 AND selected_items.age<=49) ")
ageGroupsTitle <- c(" All ages ",
                    " Ages 13 to 17 ",
                    " Ages 18 to 22 ",
                    " Ages 13 to 22 ",
                    " Ages 23 to 27 ",
                    " Ages 28 to 34 ",
                    " Ages 35 to 49 ")

plotTitle <- c("Zara", "Forever 21", "Retro glasses","Blue, Royal Blue, Neon Blue","Mini Dress and Skirt", "Ralph Lauren", 
               "Pastels", "Metallic", "J.Crew", 
               "Tangerine", "Maxi Dress, Skirt", "Ankle Boots", "Burgundy", "Skinny Jeans", 
               "Peplum", "Velvet", "Emerald", "Stripes", "Heels", "Floral", "Michael Kors", "H&M",
               "Ann Taylor", "Red", "Dark Red", "Black", "Green", "Yellow", "Gold", "Dark Blue", "Royal Blue",
               "Orange", "White, Off White")

watchedTrends <- function(ageIndex=1, ageGroups) {
  searchStr <- 
    c(paste(" lower(selected_items.brand) LIKE '%zara%'", sep=""),
      paste(" lower(selected_items.brand) LIKE '%forever 21%'", sep=""),
      paste(" (lower(selected_items.item) like '%cat%' OR lower(selected_items.item) like '%retro%') 
               AND lower(selected_items.style) like '%glasse%' ", sep=""),
      paste("lower(selected_items.color) = 'blue' OR lower(selected_items.color) = 'neon blue' 
               OR lower(selected_items.color) = 'royal blue' ", sep=""),
      paste(" lower(selected_items.item) LIKE '%mini%' OR lower(selected_items.style) LIKE '%mini%'", sep=""),
      paste(" lower(selected_items.brand) = 'ralph lauren' ", sep=""), 
      paste(" lower(selected_items.color) = 'pastel yellow'
                 OR lower(selected_items.item) = 'pastel red'
                 OR lower(selected_items.color) = 'pastel blue'
                 OR lower(selected_items.color) = 'pastel purple'
                 OR lower(selected_items.color) = 'pastel orange'
                 OR lower(selected_items.color) = 'pastel green'
                 OR lower(selected_items.color) = 'light blue'
                 OR lower(selected_items.color) = 'light yellow'
                 OR lower(selected_items.color) = 'light pink'
                 OR lower(selected_items.item) = 'light green'", sep=""),
      paste("lower(selected_items.color) = 'metallics'", sep=""),
      paste("lower(selected_items.brand) LIKE '%j%crew%'", sep=""), 
      paste(" lower(selected_items.color) LIKE '%tangerine%' 
                  OR lower(selected_items.item) LIKE '%tangerine%' 
                  OR lower(selected_items.color) LIKE '%orange%' 
                  OR lower(selected_items.item) LIKE '%orange%'", sep=""), 
      paste("  lower(selected_items.item) LIKE '%maxi%' OR lower(selected_items.style) LIKE '%maxi%'", sep=""), 
      paste("  lower(selected_items.item) LIKE '%ankle%boot%'
                  OR lower(selected_items.style) LIKE '%ankle%boot%'
                  OR lower(selected_items.item) LIKE '%booties%'
                  OR lower(selected_items.style) LIKE '%booties%'", sep=""), 
      paste(" lower(selected_items.color) LIKE '%burgundy%' OR lower(selected_items.item) LIKE '%burgundy%'", sep=""), 
      paste(" lower(selected_items.style) LIKE '%skinny%jean%'", sep=""), 
      paste(" lower(selected_items.style) LIKE '%peplum%'", sep=""), 
      paste(" lower(selected_items.fabric) LIKE '%velvet%' OR lower(selected_items.item) LIKE '%velvet%'", sep=""), 
      paste(" lower(selected_items.color) = 'green' OR lower(selected_items.color) = 'hunter green' 
                  OR lower(selected_items.color) = 'forest green' OR lower(selected_items.color) = 'emerald'", sep=""),
      paste(" lower(selected_items.item) like '%stripe%' OR lower(selected_items.style) like '%stripe%'
                OR lower(selected_items.pattern) like '%stripe%'", sep=""),
      paste(" lower(selected_items.style) = 'heels' OR lower(selected_items.style) LIKE '%pumps%'
              OR lower(selected_items.style) LIKE '%stilettos%'", sep=""),
      paste(" lower(selected_items.pattern) LIKE '%floral%' OR lower(selected_items.item) LIKE '%floral%'", sep=""),
      paste(" lower(selected_items.brand) LIKE '%michael%kors%'
            OR lower(selected_items.item) LIKE '%michael%kors%'", sep=""),
      paste(" lower(selected_items.brand) LIKE '%h&m%' 
               OR lower(selected_items.item) LIKE '%h&m%'", sep=""),
      paste(" lower(selected_items.brand) LIKE '%ann%taylor%'
            OR lower(selected_items.item) LIKE '%ann%taylor%'", sep=""),
      paste("lower(selected_items.color) = 'red'", sep=""),
      paste("lower(selected_items.color) = 'dark red'", sep=""),
      paste("lower(selected_items.color) = 'black'", sep=""),
      paste("lower(selected_items.color) = 'green'", sep=""),
      paste("lower(selected_items.color) = 'yellow' 
                OR lower(selected_items.color) = 'mustard yellow'", sep=""),
      paste("lower(selected_items.color) = 'gold'  
                OR lower(selected_items.color) = 'dark yellow'", sep=""),
      paste("lower(selected_items.color) = 'dark blue'", sep=""),
      paste("lower(selected_items.color) = 'royal blue'", sep=""),
      paste("lower(selected_items.color) = 'orange' OR lower(selected_items.color) = 'tangerine'", sep=""),
      paste("lower(selected_items.color) = 'white' OR lower(selected_items.color) = 'off white'", sep="")
    )
  return(paste(" ((", searchStr, ") AND ", ageGroups[ageIndex], ") ", sep=""))
}



interval <- list(start=population$startDateTxt, end=population$endDateTxt)
periods <- floor(as.integer(interval$end-interval$start)/7)
nTrend <- length(plotTitle)


minItems <- 5
i <- 1
trnd <- trendSearch(interval=interval, activeChoice=minItems, sString=watchedTrends(ageIndex=1, ageGroups)[i])
trnd$dates <- as.character(trnd$dates)
trndJSON <- toJSON(trnd)


#pdf(file=paste("/Users/david/Desktop/", " ", today(), " ", 
#               hour(now()), "-", minute(now()), ".pdf", sep=""), width=9, height=3.5)
#intrvl <- c(1:3) #plot trend lines for the attributes 1 through 3
#for (i in intrvl) { #26
#  trendPlot(interval=interval, activeChoice=minItems, plotTitle=plotTitle[i], 
#            sString=watchedTrends(ageIndex=1, ageGroups)[i], regression="Yes", putTitle="Yes")
#}
dev.off()
############

