####
#
#   plot2.R
#
#   Exploratory Data Analysis (class.coursera.org/exdata-035)
#
#                   Further explanation of this database can be found at:
#                   http://www3.epa.gov/ttn/chief/eidocs/basiceipreparationtraining_april2003.pdf
#
#   Course Project 2 - Fine particulate matter
#
#       The overall goal of this assignment is to explore the National Emissions Inventory database and see what it say
#       about fine particulate matter pollution in the United states over the 10-year period 1999-2008. You may use any
#       R package you want to support your analysis.
#
#   Question:   Have total emissions from PM2.5 decreased in Baltimore City, Maryland (fips=="24510") from 1999 to 2008?
#
#               Use the base plotting system to make a plot answering this question.
#
#   Answer:     YES. total emissions from PM2.5 have decreased in Baltimore City from 1999 to 2008.
#

####
#
#   Setup Libraries, Directories, and URLs
#

setwd("C:/Users/Ken/Documents/Ken/Continuing Education/Johns Hopkins School of Public Health - Data Science 4 - Exploratory Data Analysis/FineParticulateMatter")

projectDataURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"

####
#
#    Read in the Course Project 2 data files

## Create the data folder
if(!file.exists("data")) {
    dir.create("data")
    print("Created data folder.")
}
    
## Download the zip file for the course
if(!file.exists("./data/data.zip")) {
    print("Downloading data.zip...")
    download.file(projectDataURL, destfile = "./data/data.zip", mode = "wb")
    print("Downloading data.zip completed.")
}
    
if(!file.exists("./data/zipcontents")) {
    print("Unzipping data.zip...")
    unzip("./data/data.zip", exdir="./data/zipcontents")
    print("Unzipping data.zip completed.")
}

## This first line will likely take a few seconds. Be patient!
print("Reading data files.")
NEI <- readRDS("./data/zipcontents/summarySCC_PM25.rds")
SCC <- readRDS("./data/zipcontents/Source_Classification_Code.rds")
print("Reading data files completed.")




####
#
# Plot 2
#

emissionsByYearByFips <- aggregate(NEI$Emissions, by = list(NEI$year, NEI$fips), FUN=sum, na.rm=TRUE)
names(emissionsByYearByFips) <- c("year", "fips", "total")
emissionsByYear_BaltimoreCity <- emissionsByYearByFips[emissionsByYearByFips$fips == "24510",]

png(filename = "plot2.png", width = 480, height = 480, units = "px")
plot(emissionsByYear_BaltimoreCity$year, emissionsByYear_BaltimoreCity$total/1000, type="b",
     main="Baltimore City Total PM2.5 Emission From All Sources",
     xlab="Year", ylab="Total Emissions (1,000 Tons)", ylim=c(0, max(emissionsByYear_BaltimoreCity$total/1000)))
dev.off()
