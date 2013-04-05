library(RPostgreSQL)

drv <- dbDriver("PostgreSQL")
con <- dbConnect(drv, host='localhost', port='5432', dbname = "stylitics-dev", user="catalystww", password="")

query <- paste("select days.id from days limit 200", sep="")

idsDB <- dbSendQuery(con, statement=query)
ids <- fetch(idsDB, n = -1)
dbDisconnect(con)

idsList <- unique(rownames(table(ids[,1])))

x <- idsList
