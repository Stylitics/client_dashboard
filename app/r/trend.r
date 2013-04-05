library(RPostgreSQL)

# mean of non-zero values
nzmean <- function(x) {
  if (all(x==0)) 0 else mean(x[x!=0], na.rm = T)
}

# this function forms the SQL querry based on the filter's parameters
query <- function(pop) {
  if (pop$gender=="All") {
    genderStr <- paste(" ", sep="")
  }
  else {
    genderStr <- paste(" AND users.gender='", pop$gender, "' ", sep="")
  }

  ################

  # ageRange is a vector of two values: the upper and the lower bounds for age
  ageStr <- paste(" WHERE ((SELECT EXTRACT(year FROM AGE(NOW(), users.date_of_birth)))<",
                  pop$ageRange[2],
                  " AND (SELECT EXTRACT(year FROM AGE(NOW(), users.date_of_birth)))>",
                  pop$ageRange[1], ") ", sep="")

  ################

  if (pop$studentOpt=="All") {
    studentStr <- paste(" ", sep="")
  }
  else {
    if (pop$studentOpt=="Student") {
      studentStr <- paste(" AND users.student='true' ", sep="")
    }
    else {
      studentStr <- paste(" AND users.student='false' ", sep="")
    }
  }
  ################

  # it is assumed that the location is given in a form of a string that
  # contains values such as "NYC", "LA", "DC", "SF", "Dallas", "Chicago"
  if ("All" %in% pop$locationOpt | length(pop$locationOpt)==0) {
    locationStr <- paste(" ", sep="")
  }
  else{
    metroAreas <- c("NYC", "LA", "DC", "SF", "Dallas", "Chicago")

    zips <- list(" (users.zipcode_id::int in (SELECT id FROM zipcodes WHERE zipcodes.code::int BETWEEN 10001 AND 11697)) ",
                 " (users.zipcode_id::int in (SELECT id FROM zipcodes WHERE zipcodes.code::int BETWEEN 90001 AND 93591)) ",
                 " (users.zipcode_id::int in (SELECT id FROM zipcodes WHERE zipcodes.code::int BETWEEN 20001 AND 20599)) ",
                 " (users.zipcode_id::int in (SELECT id FROM zipcodes WHERE zipcodes.code::int BETWEEN 94102 AND 94134)) ",
                 " (users.zipcode_id::int in (SELECT id FROM zipcodes WHERE zipcodes.code::int BETWEEN 75201 AND 75398)) ",
                 " (users.zipcode_id::int in (SELECT id FROM zipcodes WHERE zipcodes.code::int BETWEEN 60601 AND 60701)) ")


    names(zips) <- metroAreas

    if (length(pop$locationOpt)>=1) {
      locationStr <- paste(" AND ( ", sep="")
      for (i in 1:length(pop$locationOpt)) {
        locationStr <- paste(locationStr, zips[pop$locationOpt[i]], sep="")
        if (i<length(pop$locationOpt)) {
          locationStr <- paste(locationStr, " or ", sep="")
        }
        else {
          locationStr <- paste(locationStr, " ) ", sep="")
        }
      }
    }
    else {
      locationStr <- paste(" ", sep="")
    }
  }
  ################

  # expensiveOpt is a flag that controls the inclusion of items priced above $3,000
  # priceRange is a vector of two variables. First one is lower bound for the price
  # and second one is the upper bound for the price
  pop$priceRange <- as.character(pop$priceRange)
  expensiveStr <- paste(" ", sep="")
  # PROBLEM WITH RELOADING AFTER CHECKING ONE OF THESE OPTIONS Temporarily disabled
  expensiveStr <- " "
  #   if (("Items with no price" %in% pop$expensiveOpt) & ("Items over $3,000" %in% pop$expensiveOpt)) {
  #     expensiveStr <- paste(" AND (items.price>= ", pop$priceRange[1],
  #                           " or items.price is null)", sep="")
  #   }
  #   if (("Items with no price" %in% pop$expensiveOpt) & !("Items over $3,000" %in% pop$expensiveOpt)) {
  #     expensiveStr <- paste(" AND ((items.price<= ", pop$priceRange[2],
  #                           " AND items.price>= ", pop$priceRange[1],
  #                           " ) or items.price is null)", sep="")
  #   }
  #   if (!("Items with no price" %in% pop$expensiveOpt) & ("Items over $3,000" %in% pop$expensiveOpt)) {
  #     expensiveStr <- paste(" AND items.price>= ", pop$priceRange[1], " ", sep="")
  #   }
  #   if (!("Items with no price" %in% pop$expensiveOpt) & !("Items over $3,000" %in% pop$expensiveOpt)) {
  #     expensiveStr <- paste(" AND items.price<= ", pop$priceRange[2],
  #                           " AND items.price>= ", pop$priceRange[1], " ", sep="")
  #   }


  ################

  staffStr <- paste(" ", sep="") # default empty clause
  influencerStr <- paste(" ", sep="")

  if (pop$influencerOpt=="Include") {
    influencerStr <- paste(" ", sep="")
  }
  else { if (pop$influencerOpt=="Exclude") {
    influencerStr <- paste(" AND users.influencer='false' ", sep="")
  }
         else {
           influencerStr <- paste(" AND users.influencer='true' ", sep="")
         }
  }

  if (pop$staffOpt=="Include") {
    staffStr <- paste(" ", sep="") # default empty clause
  }
  else {
    staffStr <- paste(" AND users.admin='FALSE' ", sep="")
  }


  ################
  # styleTxt is the field for specifying the style. Multiple keywords are allowed -- they must
  # be separated by coma, and no spaces in between
  # styleOpt can be either "All", "Include", "Exclude"
  strSt <- unlist(strsplit(pop$styleTxt, split=','))
  if (pop$styleOpt=="All" | length(strSt)==0) {
    styleStr <- paste("  ", sep="") # default empty clause
  }
  else {
    styleStr <- paste(" ((lower(item_styles.name) LIKE '%",
                      tolower(strSt[1]), "%')", sep="")
    if (length(strSt)>1) {
      for (i in 2:length(strSt)) {
        styleStr <- paste(styleStr, " or (lower(item_styles.name) LIKE '%",
                          tolower(strSt[i]), "%')", sep="")
      }
    }
    styleStr <- paste(styleStr, ")", sep="")

    if (pop$styleOpt=="Exclude") {
      styleStr <- paste(" not ", styleStr, sep="")
    }
    styleStr <- paste(" AND ", styleStr, sep="")
  }

  ################

  # eventType can take on "All", "Bought", "Added", "Last_worn" or "Worn"
  # endDateTxt and startDateTxt specify the end points of the time interval
  # and are in the yyyy-mm-dd format
  if (pop$eventType=="All") {
    eventStr <- paste(" ", sep="") # default empty clause
  }
  else {
    switch(pop$eventType,
           Bought =  eventStr <- paste(" AND items.bought_on <= '", pop$endDateTxt, "' ",
                                       " AND items.bought_on >= '", pop$startDateTxt, "' ", sep=""),
           Added = eventStr <- paste(" AND items.created_at <= '", pop$endDateTxt, "' ",
                                     " AND items.created_at >= '", pop$startDateTxt, "' ", sep=""),
           Last_worn = eventStr <- paste(" AND items.last_worn <= '", pop$endDateTxt, "' ",
                                         " AND items.last_worn >= '", pop$startDateTxt, "' ", sep=""),
           Worn = eventStr <- paste(" AND items.id in ( SELECT wearings.item_id FROM wearings ",
                                    " WHERE day_id in ( SELECT days.id FROM days ",
                                    " WHERE days.date <='", pop$endDateTxt, "' ",
                                    " AND days.date >  >= '", pop$startDateTxt, "')) ", sep="")
    )
  }


  ################
  # colorTxt is the field for specifying the color Multiple keywords are allowed -- they must
  # be separated by coma, and no spaces in between
  # colorOpt can be either "All", "Include", "Exclude"
  strC <- unlist(strsplit(pop$colorTxt, split=','))
  if (pop$colorOpt=="All" | length(strC)==0) {
    colorStr <- paste(" ", sep="")
  }
  else {
    colorStr <- paste(" ((lower(colors.name) LIKE '%",
                      tolower(strC[1]), "%')", sep="")
    if (length(strC)>1) {
      for (i in 2:length(strC)) {
        colorStr <- paste(colorStr, " or (lower(colors.name) LIKE '%",
                          tolower(strC[i]), "%')", sep="")
      }
    }
    colorStr <- paste(colorStr, ")", sep="")

    if (pop$colorOpt=="Exclude") {
      colorStr <- paste(" NOT ", colorStr, sep="")
    }
    colorStr <- paste(" AND ", colorStr, sep="")
  }

  ################
  # retailerTxt is the field for specifying the retailer. Multiple keywords are allowed -- they must
  # be separated by coma, and no spaces in between
  # retailerOpt can be either "All", "Include", "Exclude"
  str <- unlist(strsplit(pop$retailerTxt, split=','))
  if (pop$retailerOpt=="All" | length(str)==0) {
    retailerStr <- paste("  ", sep="")
  }
  else {
    retailerStr <- paste(" ((lower(items.retailer_name) LIKE '%",
                         tolower(str[1]), "%')", sep="")
    if (length(str)>1) {
      for (i in 2:length(str)) {
        retailerStr <- paste(retailerStr, " or (lower(items.retailer_name) LIKE '%",
                             tolower(str[i]), "%')", sep="")
      }
    }
    retailerStr <- paste(retailerStr, ")", sep="")

    if (pop$retailerOpt=="Exclude") {
      retailerStr <- paste(" NOT ", retailerStr, sep="")
    }
    retailerStr <- paste(" AND ", retailerStr, sep="")
  }

  ################
  # brandTxt is the field for specifying the brand Multiple keywords are allowed -- they must
  # be separated by coma, and no spaces in between
  # brandOpt can be either "All", "Include", "Exclude"
  str <- unlist(strsplit(pop$brandTxt, split=','))
  if (pop$brandOpt=="All" | length(str)==0) {
    brandStr <- paste(" ", sep="")
  }
  else {
    brandStr <- paste(" ((lower(items.brand_name) LIKE '%",
                      tolower(str[1]), "%')", sep="")
    if (length(str)>1) {
      for (i in 2:length(str)) {
        brandStr <- paste(brandStr, " or (lower(items.brand_name) LIKE '%",
                          tolower(str[i]), "%')", sep="")
      }
    }
    brandStr <- paste(brandStr, ")", sep="")

    if (pop$brandOpt=="Exclude") {
      brandStr <- paste(" not ", brandStr, sep="")
    }
    brandStr <- paste(" AND ", brandStr, sep="")
  }


  ################
  # patternTxt is the field for specifying the pattern. Multiple keywords are allowed -- they must
  # be separated by coma, and no spaces in between
  # patternOpt can be either "All", "Include", "Exclude"
  strP <- unlist(strsplit(pop$patternTxt, split=','))
  if (pop$patternOpt=="All" | length(strP)==0) {
    patternStr <- paste(" ", sep="")
  }
  else {
    patternStr <- paste(" ((lower(patterns.name) LIKE '%",
                        tolower(strP[1]), "%')", sep="")
    if (length(strP)>1) {
      for (i in 2:length(strP)) {
        patternStr <- paste(patternStr, " or (lower(patterns.name) LIKE '%",
                            tolower(strP[i]), "%')", sep="")
      }
    }
    patternStr <- paste(patternStr, ")", sep="")

    if (pop$patternOpt=="Exclude") {
      patternStr <- paste(" NOT ", patternStr, sep="")
    }
    patternStr <- paste(" AND ", patternStr, sep="")
  }
  ################
  # fablicTxt is the field for specifying the fabric Multiple keywords are allowed -- they must
  # be separated by coma, and no spaces in between
  # fabricOpt can be either "All", "Include", "Exclude"
  strF <- unlist(strsplit(pop$fabricTxt, split=','))
  if (pop$fabricOpt=="All" | length(strF)==0) {
    fabricStr <- paste(" ", sep="")
  }
  else {
    fabricStr <- paste(" ((lower(fabrics.name) LIKE '%",
                       tolower(strF[1]), "%')", sep="")
    if (length(strF)>1) {
      for (i in 2:length(strF)) {
        fabricStr <- paste(fabricStr, " or (lower(fabrics.name) LIKE '%",
                           tolower(strF[i]), "%')", sep="")
      }
    }
    fabricStr <- paste(fabricStr, ")", sep="")

    if (pop$fabricOpt=="Exclude") {
      fabricStr <- paste(" not ", fabricStr, sep="")
    }
    fabricStr <- paste(" AND ", fabricStr, sep="")
  }


  ################
  # sortOpt contains the sorting field. It can take on the following values
  # "User ID", "Item ID", "Style", "Color", "Retailer", "Brand", "Pattern", "Fabric"
  # A combination of them can be used, but they must be separated with coma with no spaces
  if (length(pop$sortOpt)==0) {
    sortStr <- paste(" ", sep="")
  }
  else{
    sortFieldNames <- c("User ID", "Item ID", "Style", "Color", "Retailer",
                        "Brand", "Pattern", "Fabric")
    sortFields <- c("users.id", "items.id", "items.item_style_id", "items.color_id",
                    "items.retailer_id", "items.brand_id", "items.pattern_id",
                    "items.fabric_id")
    names(sortFields) <- sortFieldNames

    # if (locationOpt[i]!=metroAreas[length(locationOpt)])

    if (length(pop$sortOpt)>=1) {
      sortStr <- paste(" ORDER BY  ", sep="")
      for (i in 1:length(pop$sortOpt)) {
        sortStr <- paste(sortStr, sortFields[pop$sortOpt[i]], sep="")
        if (i<length(pop$sortOpt)) {
          sortStr <- paste(sortStr, ", ", sep="")
        }
        else {
          sortStr <- paste(sortStr, "  ", sep="")
        }
      }
    }
    else {
      sortStr <- paste(" ", sep="")
    }
  }


  ################
  stat <- paste(
    " SELECT DISTINCT users.id AS user_id, users.user_name AS uname, items.id AS item_id, users.gender, ",
    " (SELECT EXTRACT(year FROM AGE(NOW(), users.date_of_birth))) AS age, ",
    " items.name AS item, item_styles.name AS style, ",
    " items.item_style_id AS item_style_id, ",
    " items.brand_name AS brand, ",
    " colors.name AS color, ",
    " patterns.name AS pattern, ",
    " fabrics.name AS fabric, retailers.name AS retailer, ",
    " items.favorite AS fav, items.price AS price, ",
    " items.last_worn AS last_worn , ",
    " (SELECT items.created_at::date) AS ct, ",
    " items.like_count AS like_cnt ",
    " FROM items ",
    " LEFT JOIN users on items.user_id=users.id ",
    " LEFT JOIN item_styles on item_styles.id=items.item_style_id ",
    " LEFT JOIN colors on (colors.id=items.color_id OR colors.id=items.color2_id OR colors.id=items.color3_id) ",
    " LEFT JOIN patterns on (patterns.id=items.pattern_id OR  patterns.id=items.pattern2_id) ",
    " LEFT JOIN fabrics on (fabrics.id=items.fabric_id OR fabrics.id=items.fabric2_id) ",
    " LEFT JOIN retailers on retailers.id=items.retailer_id ",
    ageStr, # this string includes "WHERE" keyword
    expensiveStr,
    genderStr,
    studentStr,
    staffStr,
    influencerStr,
    eventStr,
    styleStr,
    brandStr,
    retailerStr,
    colorStr,
    patternStr,
    fabricStr,
    locationStr,
    sortStr,
    sep="")
  return(stat)
}


createAndLoadSample <- function(pop) {
  drv <- dbDriver("PostgreSQL")
  con <- dbConnect(drv, host='localhost', port='5432', dbname = "stylitics-dev", user="catalystww", password="")
  st <- query(pop)
  fQuery <- dbSendQuery(con, statement=query(pop))
  fQueryFrame <- fetch(fQuery, n = -1)
  dbWriteTable(con, "selected_items", fQueryFrame, overwrite=TRUE) # create and auxilary table with the selected sample
  dbDisconnect(con)
  fQueryFrame$age <- as.integer(fQueryFrame$age)
  fQueryFrame$last_worn <- as.character(fQueryFrame$last_worn)
  limitedQueryFrame <- fQueryFrame[1:10,]
  limitedQueryFrame <- limitedQueryFrame[,!(names(limitedQueryFrame) %in% c("ct"))] # exclude the created_at field
  return(limitedQueryFrame)
}

# this is an unnecessary rudiment. There used to be more things done by this function
createSample <- function(p) {

  createAndLoadSample(p)

}




# this funciton creates arrays of add and wear data to be plotted by trendPlot function.
trendSearch <- function(sString, interval, activeChoice) {
  periods <- floor(as.integer(interval$end-interval$start)/7)

  # we consider a user active if he/she has more than activeChoice items in their closet
  activeUsrStatement <-
    paste(" WITH count_table AS (
                                  SELECT items.user_id AS user_id, count(items.user_id) AS count
	                                FROM items
	                                GROUP BY items.user_id
                                 )
             SELECT user_id
             FROM count_table
             WHERE count_table.count >= ", activeChoice, sep="")

  drv <- dbDriver("PostgreSQL") # get id's of all active users and write them into an "active_users" table
  con <- dbConnect(drv, host='localhost', port='5432', dbname = "stylitics-dev", user="catalystww", password="")
  activeUsrsDB <- dbSendQuery(con, statement=activeUsrStatement)
  activeUsrsDF <- fetch(activeUsrsDB, n = -1)
  dbWriteTable(con, "active_users", activeUsrsDF, overwrite=TRUE)
  dbDisconnect(con)


  addedItemsCountStatement <- # num of items added each period by active users
    paste("SELECT series.date, count(date_trunc('week', foo.created_at)) ",
          " FROM (SELECT ddate.date AS date FROM (SELECT current_date-generate_series(0,7*52*100,7)
                                              -extract(dow FROM current_date)::int +1 AS date) AS ddate
              WHERE ddate.date>='", interval$start, "' AND ddate.date<='", interval$end, "'
        ) AS series
          LEFT OUTER JOIN (SELECT selected_items.ct AS created_at
                                     FROM selected_items, active_users
                                     WHERE active_users.user_id=selected_items.user_id
                                 ) AS foo ",
          " ON series.date=date_trunc('week', foo.created_at) ",
          " GROUP BY series.date",
          " ORDER BY series.date ", sep="")

  drv <- dbDriver("PostgreSQL")
  con <- dbConnect(drv, host='localhost', port='5432', dbname = "stylitics-dev", user="catalystww", password="")
  addedItemsCountDB <- dbSendQuery(con, statement=addedItemsCountStatement)
  addedItemsCountDF <- fetch(addedItemsCountDB, n = -1)
  dbDisconnect(con)



  specificAddedItemsCountStatement <-
    paste("SELECT series.date, count(date_trunc('week', specific_item.ct))
             FROM (SELECT ddate.date AS date FROM (SELECT current_date-generate_series(0,7*52*100,7)
                                                        -extract(dow FROM current_date)::int +1 AS date) AS ddate
                    WHERE ddate.date>='", interval$start, "' AND ddate.date<='", interval$end, "'
                  ) AS series
             LEFT OUTER JOIN (SELECT selected_items.ct
                               FROM selected_items, active_users
                               WHERE  ", sString,
          " AND active_users.user_id=selected_items.user_id
                             ) AS specific_item
             ON series.date=date_trunc('week', specific_item.ct)
             GROUP BY series.date
             ORDER BY series.date", sep="")

  drv <- dbDriver("PostgreSQL") # num of specific items added each period by active users
  con <- dbConnect(drv, host='localhost', port='5432', dbname = "stylitics-dev", user="catalystww", password="")
  specificAddedItemsCountDB <- dbSendQuery(con, statement=specificAddedItemsCountStatement)
  specificAddedItemsCountDF <- fetch(specificAddedItemsCountDB, n = -1)
  dbDisconnect(con)


  usersWithSpecificAddedItemsStatement <-
    paste("SELECT DISTINCT specific_item.user_id
             FROM (SELECT ddate.date AS date FROM (SELECT current_date-generate_series(0,7*52*100,7)
                                                        -extract(dow FROM current_date)::int +1 AS date) AS ddate
                    WHERE ddate.date>='", interval$start, "' AND ddate.date<='", interval$end, "'
                  ) AS series
             LEFT OUTER JOIN (SELECT selected_items.ct, selected_items.user_id AS user_id
                               FROM selected_items, active_users
                               WHERE  ", sString,
          " AND active_users.user_id=selected_items.user_id
                             ) AS specific_item
             ON series.date=date_trunc('week', specific_item.ct) ", sep="")
  drv <- dbDriver("PostgreSQL") # users that added each period by active users
  con <- dbConnect(drv, host='localhost', port='5432', dbname = "stylitics-dev", user="catalystww", password="")
  usersWithSpecificAddedItemsDB <- dbSendQuery(con, statement=usersWithSpecificAddedItemsStatement)
  usersWithSpecificAddedItemsDF <- fetch(usersWithSpecificAddedItemsDB, n = -1)
  dbWriteTable(con, "users_with_specific_item", usersWithSpecificAddedItemsDF, overwrite=TRUE)
  dbDisconnect(con)


  specificWornItemsCountStatement <- # num of outfits with specific item worn each period by active users
    paste("SELECT series.date, count(date_trunc('week', foo.outing_date))
             FROM (SELECT ddate.date AS date FROM (SELECT current_date-generate_series(0,7*52*100,7)
                                                        -extract(dow FROM current_date)::int +1 AS date) AS ddate
                    WHERE ddate.date>='", interval$start, "' AND ddate.date<='", interval$end, "'
                  ) AS series
                 LEFT OUTER JOIN (SELECT outings.date AS outing_date
                                     FROM outings
                                     LEFT JOIN outfits ON outfit_id = outfits.id
                                     JOIN lists ON lists.id = outfits.list_id
  		   		                         JOIN list_items ON lists.id = list_items.list_id
					                           JOIN selected_items ON list_items.item_id = selected_items.item_id
  				                           JOIN users_with_specific_item
                                          ON selected_items.user_id=users_with_specific_item.user_id
                                     WHERE ", sString,
          " AND outings.created_at IS NOT NULL
                                   ) AS foo ON series.date=date_trunc('week', foo.outing_date)
                 GROUP BY series.date
                 ORDER BY series.date ", sep="")

  drv <- dbDriver("PostgreSQL")
  con <- dbConnect(drv, host='localhost', port='5432', dbname = "stylitics-dev", user="catalystww", password="")
  specificWornItemsCountDB <- dbSendQuery(con, statement=specificWornItemsCountStatement)
  specificWornItemsCountDF <- fetch(specificWornItemsCountDB, n = -1)
  dbDisconnect(con)



  wornItemsCountStatement <- # num of all outfits worn each period by all users
    paste("SELECT series.date, count(date_trunc('week', foo.outing_date))
             FROM (SELECT ddate.date AS date FROM (SELECT current_date-generate_series(0,7*52*100,7)
                                                        -extract(dow FROM current_date)::int +1 AS date) AS ddate
                    WHERE ddate.date>='", interval$start, "' AND ddate.date<='", interval$end, "'
                  ) AS series
                 LEFT OUTER JOIN (SELECT outings.date AS outing_date
                                     FROM outings
                                       LEFT JOIN outfits ON outings.outfit_id = outfits.id
                                       JOIN lists ON lists.id = outfits.list_id
  		                           		   JOIN list_items ON lists.id = list_items.list_id
					                             JOIN selected_items ON list_items.item_id = selected_items.item_id
  			                               JOIN users_with_specific_item
                                        ON selected_items.user_id=users_with_specific_item.user_id
                                     WHERE outings.created_at IS NOT NULL
                                   ) AS foo
              ON series.date=date_trunc('week', foo.outing_date)
                 GROUP BY series.date
                 ORDER BY series.date ", sep="")

  drv <- dbDriver("PostgreSQL")
  con <- dbConnect(drv, host='localhost', port='5432', dbname = "stylitics-dev", user="catalystww", password="")
  wornItemsCountDB <- dbSendQuery(con, statement=wornItemsCountStatement)
  wornItemsCountDF <- fetch(wornItemsCountDB, n = -1)
  dbDisconnect(con)



  df <- vector("list", 13)

  df[[3]] <- specificAddedItemsCountDF[,2] # specific added items at that time

  df[[5]] <- addedItemsCountDF[,2] # total added items at that time
  df[[5]][df[[5]]==0] <- 1
  df[[6]] <- df[[3]]/df[[5]] # adjusted specific addings

  df[[7]] <- specificWornItemsCountDF[,2] # specific worn outfits count at that time

  df[[8]] <- wornItemsCountDF[,2] # total worn outfits count at that time
  df[[8]][df[[8]]==0] <- 1


  df[[9]] <- df[[7]]/df[[8]] # adjusted specific wearings

  # cut of the last day, since the week is not complete yet
  df[[6]] <- df[[6]][1:(length(df[[6]])-1)] # add
  df[[9]] <- df[[9]][1:(length(df[[9]])-1)] # wear
  df[[3]] <- df[[3]][1:(length(df[[3]])-1)] # add
  df[[7]] <- df[[7]][1:(length(df[[7]])-1)] # wear


  df[[10]] <- lm(df[[6]]~I(1:length(df[[6]]))) # regression line for add
  df[[11]] <- lm(df[[9]]~I(1:length(df[[9]]))) # regression line for wear

  df[[12]] <- specificAddedItemsCountDF[,1] # list of corresponding dates
  df[[12]] <- df[[12]][1:(length(df[[12]])-1)]

  names(df) <- c("", "", "", "", "", "adjustedSpecificItemsAdded", "", "", "adjustedSpecificWearings",
                 "ASIAregr", "ASIWregr", "dates")


  # export the data into a csv file
  write.table(as.data.frame(cbind(unlist(df[[6]]), unlist(df[[9]]))),
              file="dat.csv", sep=",", append=FALSE)

  return(df)
}


trendPlot <- function(sString, interval,
                      activeChoice, plotTitle, type="All", regression="Yes", putTitle="Yes") {

  # compute the number of weeks within the data interval and get rid of the last incomplete week
  periods <- floor(as.integer(interval$end-interval$start)/7) -1

  # the changeFunc returns the percentage change between the start and end values
  changeFunc <- function(start, end) {
    change <- round(end*100/start,0)
    if (end>=start) {
      change <- change - 100
      changeStr <- paste("increased by ", change, "%", sep="")
    }
    else {
      change <- 100 - change
      changeStr <- paste("decreased by ", change, "%", sep="")
    }
    return(changeStr)
  }

  trend.df <- trendSearch(sString=sString, interval=interval,
                          activeChoice=activeChoice)


  trend.df$dates <- as.Date(trend.df$dates, "%Y-%m-%d")
  pVec <- 1:periods
  par(mar=c(3.7,2.5,1.5,2))
  plot(x=trend.df$dates, y=trend.df$adjustedSpecificWearings, type="l", col="blue",
       xlab="", xaxt='n', ylab="",
       ylim=range(c(trend.df$adjustedSpecificWearings[pVec], trend.df$adjustedSpecificItemsAdded[pVec]))
  )
  if (regression=="Yes") {
    regX <- 1:length(trend.df$dates)
    regY <- summary(trend.df$ASIWregr)$coefficients[1]+regX*summary(trend.df$ASIWregr)$coefficients[2]
    lines(trend.df$dates, regY, lty = "dashed", col="blue")
  }
  text(x=trend.df$dates[periods+1], y=trend.df[[9]][periods+1], labels=as.character(trend.df[[7]][periods]),
       col='blue') # wear
  par(new=TRUE)

  plot(x=trend.df$dates, trend.df$adjustedSpecificItemsAdded, type="l", col="red",
       xaxt='n', yaxt='n',
       xlab="", ylab="",
       ylim=range(c(trend.df$adjustedSpecificWearings[pVec], trend.df$adjustedSpecificItemsAdded[pVec]))
  )
  if (regression=="Yes") {
    regX <- 1:length(trend.df$dates)
    regY <- summary(trend.df$ASIAregr)$coefficients[1]+regX*summary(trend.df$ASIAregr)$coefficients[2]
    lines(trend.df$dates, regY, lty = "dashed", col="red")
  }
  text(x=trend.df$dates[periods+1], y=trend.df[[6]][periods+1], labels=as.character(trend.df[[3]][periods]),
       col='red') # add

  axis.Date(side=1, at=trend.df$dates, format="%b %d", las=2)

  if(putTitle=="Yes")
    title(plotTitle, cex=.7)
  if (type=="All") {
    legend("topleft",col=c("red","blue"),lty=1,legend=c("add","wear"), bty='n', cex=.7,
           adj=c(.3, .1))
  }

}


library(lubridate)
library(xlsx)


# Create a sample based on the following parameters. A table called "selected_items" is added to the DB

population <- vector("list", 25)
names(population) <- c("gender", "ageRange", "studentOpt", "locationOpt", "expensiveOpt", "priceRange",
                       "influencerOpt", "staffOpt", "styleOpt", "eventType", "colorOpt", "retailerOpt",
                       "brandOpt", "patternOpt", "fabricOpt", "sortOpt", "studentOpt", "styleTxt",
                       "colorTxt", "brandTxt", "startDateTxt", "endDateTxt", "retailerTxt", "patternTxt",
                       "fabricTxt")

population$gender <- "Male"
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

#         sString <- paste("  (lower(selected_items.style) like '%collar%'
#          or lower(selected_items.style) like '%button%down%') ",
#                          sep="")
#     sString <- paste("(lower(selected_items.style) LIKE '%satchel%'
#                          OR lower(selected_items.item) LIKE '%satchel%')", sep="")
#     sString <- paste("(lower(selected_items.style) LIKE '%tote%bag%'
#                          OR lower(selected_items.item) LIKE '%tote%bag%')", sep="")
#     sString <- paste("(lower(selected_items.style) LIKE '%clutch%'
#                          OR lower(selected_items.item) LIKE '%clutch%')", sep="")
# sString <- paste("selected_items.gender='Female' AND (lower(selected_items.style) = 'wedges'
#                           OR lower(selected_items.style) = 'wedge sandal')", sep="")
#    sString <- paste("(lower(selected_items.style) LIKE '%flats%') ", sep="")
#     sString <- paste(" (lower(selected_items.style) LIKE '%one shoulder%'
#                        OR lower(selected_items.item) LIKE '%one shoulder%') ", sep="")
#     sString <- paste(" (lower(selected_items.style) LIKE '%high%low%'
#                        OR lower(selected_items.item) LIKE '%high%low%') ", sep="")
#      sString <- paste("(lower(selected_items.color) LIKE '%army%green%'
#                           OR lower(selected_items.item) LIKE '%army%green%'
#                           OR lower(selected_items.color) LIKE '%avocado%'
#                           OR lower(selected_items.item) LIKE '%avocado%')", sep="")




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

pdf(file=paste("/Users/ducky/Desktop/", " ", today(), " ",
               hour(now()), "-", minute(now()), ".pdf", sep=""), width=9, height=3.5)
intrvl <- c(1:3) #plot trend lines for the attributes 1 through 3
for (i in intrvl) { #26
  trendPlot(interval=interval, activeChoice=minItems, plotTitle=plotTitle[i],
            sString=watchedTrends(ageIndex=1, ageGroups)[i], regression="Yes", putTitle="Yes")
}
dev.off()
############

