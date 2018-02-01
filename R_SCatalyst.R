install.packages("RSiteCatalyst")
library(RSiteCatalyst)
SCAuth("username:company", "cd1d234dee56e8202da6f7d3213eb1ef")
library(RSiteCatalyst)
SCAuth("username:company", "cd1d234dee56e8202da6f7d3213eb1ef")
GetReportSuites()
key <- "username:company>"
secret <- "https://sc.omniture.com/p/suite/1.3/index.html?a=User.GetAccountInfo >"
SCAuth(key, secret)

## --- example1 ---- Retrieving Adobe SiteCatalyst data with R ----
dailyStats <- QueueOvertime(my.rsid,
                           date.from = "2016-01-01",
                           date.to = "2016-06-30",
                           metrics = c("pageviews","visits"),
                           date.granularity = "day"
)



####---end ---- example 2

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



####---- example3 Visualization ----

library("RSiteCatalyst")
install.packages("d3Network")
library("d3Network")

#### Authentication
SCAuth("username", "secret")

#### Get Pathing data using ::anything:: wildcards
# Results are limited by the API to 50000
pathpattern <- c("::anything::", "::anything::")

queue_pathing_pages <- QueuePathing("zwitchdev",
                                    "2014-01-01",
                                    "2014-08-31",
                                    metric="pageviews",
                                    element="page",
                                    pathpattern,
                                    top = 50000)


#Optional step: Cleaning my pagename URLs to remove to domain for graph clarity
queue_pathing_pages$step.1 <- sub("http://randyzwitch.com/","",
                                  queue_pathing_pages$step.1, ignore.case = TRUE)
queue_pathing_pages$step.2 <- sub("http://randyzwitch.com/","",
                                  queue_pathing_pages$step.2, ignore.case = TRUE)

#### Remove Enter and Exit site values
#This information is important for analysis, but not related to website structure
graph_links <- subset(queue_pathing_pages, step.1 != "Entered Site" & step.2 != "Exited Site")

#### First pass - Simple Network
# Setting standAlone = TRUE creates a full HTML file to view graph
# Set equal to FALSE to just get the d3 JavaScript
simpleoutput1 = "C:/Users/rzwitc200/Desktop/simpleoutput1.html"
d3SimpleNetwork(graph_links, Source = "step.1", Target = "step.2", height = 600,
                width = 750, fontsize = 12, linkDistance = 50, charge = -50,
                linkColour = "#666", nodeColour = "#3182bd",
                nodeClickColour = "#E34A33", textColour = "#3182bd", opacity = 0.6,
                standAlone = TRUE, file = simpleoutput1)


