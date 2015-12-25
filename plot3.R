####
#
#   plot3.R
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
#   Question:  Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) variable, which of
#               these four sources have seen decreases in emissions from 1999-2008 for Baltimore City?
#               Which have seen increases in emissions from 1999-2008?
#
#               Use the ggplot2 plotting system to make a plot answer this question.
#
#   Answer:     Decreases seen for NON-ROAD, NONPOINT, and ON-ROAD sources.
#               Increase seen for POINT sources.
#

####
#
#   Setup Libraries, Directories, and URLs
#

library(ggplot2)

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
# Plot 3
#

emissionsByYearFipsType <- aggregate(NEI$Emissions, by = list(NEI$year, NEI$fips, NEI$type), FUN=sum, na.rm=TRUE)
names(emissionsByYearFipsType) <- c("year", "fips", "type", "total")
emissionsByYearType_BaltimoreCity <- emissionsByYearFipsType[emissionsByYearFipsType$fips == "24510",]

png(filename = "plot3.png", width = 480, height = 480, units = "px")
plotgraphic <- ggplot(data = emissionsByYearType_BaltimoreCity, aes(x = year, y = total, color = type))
plotgraphic <- plotgraphic + geom_line()
plotgraphic <- plotgraphic + geom_point(shape=1, fill="white") + xlab("Year") + ylab("Emissions (Tons)")
plotgraphic
dev.off()