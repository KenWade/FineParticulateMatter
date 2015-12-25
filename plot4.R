####
#
#   plot4.R
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
#   Question:  Across the United States, how have emissions from coal combustion-related sources changed from 1999-2008?
#
#   Answer:    Coal combustion-related sources have decreased from 1999-2008.
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
# Plot 4
#

# Isolate coal sources from SCC data frame and collect only SCC contributers from NEI
coal <- SCC[grepl("Coal", SCC$EI.Sector),]
coalSCC <- unique(coal$SCC)

coalEmissions <- NEI[NEI$SCC %in% coalSCC, ]
coalEmissionsByYear <- aggregate(coalEmissions$Emissions, by = list(coalEmissions$year), FUN=sum, na.rm=TRUE)
names(coalEmissionsByYear) <- c("year", "total")

png(filename = "plot4.png", width = 480, height = 480, units = "px")
plot(coalEmissionsByYear$year, coalEmissionsByYear$total/1000, type="b", main="Total PM2.5 Emission From Coal",
     xlab="Year", ylab="Total Coal Emissions (1,000 Tons)", ylim=c(0, max(coalEmissionsByYear$total/1000)))
dev.off()
