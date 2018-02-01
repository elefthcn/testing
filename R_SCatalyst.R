install.packages("RSiteCatalyst", type = "source")
library(RSiteCatalyst)
SCAuth("username:company", "cd1d234dee56e8202da6f7d3213eb1ef")
library(RSiteCatalyst)
SCAuth("username:company", "cd1d234dee56e8202da6f7d3213eb1ef")
GetReportSuites()
key <- "username:company>"
secret <- "https://sc.omniture.com/p/suite/1.3/index.html?a=User.GetAccountInfo >"
SCAuth(key, secret)
dailyStats <- QueueOvertime(my.rsid,
                           date.from = "2016-01-01",
                           date.to = "2016-06-30",
                           metrics = c("pageviews","visits"),
                           date.granularity = "day"
)

count.limit <- 500000 #the max number of records we're interested in
count.step <- 50000 #how many records to retrieve per request, must not exceed 50k
count.start <- 1 #which record number to start with
CustomerList <- NULL #a variable to store the results in
fromDate <- "2016-12-01"
toDate <- "2016-12-31"

for(i in seq(1, count.limit, by = count.step)) {
  print(paste("Requesting rows",i, "through", i + count.step - 1))
  
  tempCustomerList <- QueueRanked(my.rsid,
                                  date.from = fromDate,
                                  date.to = toDate,
                                  metrics = "visits",
                                  elements = "prop1",
                                  top = count.step,
                                  start = i
  )
  
  if  (nrow(tempCustomerList) == 0 ) {   # no more rows were returned - presumably we have them all now
    print("Last batch had no rows, exiting loop")
    break
  }
  
  tempCustomerList$batch.start.row <- i
  
  CustomerList <- rbind(customerList, tempCustomerList)
  
}