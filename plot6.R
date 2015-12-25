####
#
#   plot6.R
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
#   Question:   Compare emissions from motor vehicle sources in Baltimore City with emissions from motor vehicle sources
#                   in Los Angeles County, California (fips == "06037")
#
#               Which city has seen greater changes over time in motor vehicle emissions?
#
#   Answer:     Interesting question...
#               Without question LA County has more total motor vehicle emissions than Baltimore City.
#               LA has seen more change in motor vehicle emissions between maximum and minimum emission years than Baltimore.
#                   However, from 1999 to 2008 the overall change has been less for LA than Baltimore.
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
# Plot 6
#

# Isolate vehicle sources from SCC data frame and collect only SCC contributers from NEI
vehicle <- SCC[grepl("Vehicle", SCC$EI.Sector),]
vehicleSCC <- unique(vehicle$SCC)

vehicleEmissions <- NEI[NEI$SCC %in% vehicleSCC, ]
vehicleEmissionsByYearByFips <- aggregate(vehicleEmissions$Emissions, 
                                          by = list(vehicleEmissions$year, vehicleEmissions$fips), FUN=sum, na.rm=TRUE)
names(vehicleEmissionsByYearByFips) <- c("year", "fips", "total")

vehicleEmissionsByYear_BaltimoreCity <- vehicleEmissionsByYearByFips[vehicleEmissionsByYearByFips$fips == "24510",]
vehicleEmissionsByYear_LA <- vehicleEmissionsByYearByFips[vehicleEmissionsByYearByFips$fips == "06037",]


png(filename = "plot6.png", width = 480, height = 480, units = "px")
plot(vehicleEmissionsByYear_BaltimoreCity$year, vehicleEmissionsByYear_BaltimoreCity$total, type="b", col="red",
     main="Total Motor Vehicle PM2.5 Emission From Baltimore City & LA",
     xlab="Year", ylab="Motor Vehicle Emissions (Tons)",
     ylim=c(0, max(max(vehicleEmissionsByYear_BaltimoreCity$total), max(vehicleEmissionsByYear_LA$total))))
lines(vehicleEmissionsByYear_LA$year, vehicleEmissionsByYear_LA$total, type="b", col="green")
legend("right", c("LA", "Baltimore"), lty=c(1,1), lwd=c(2.5,2.5), col=c("green", "red"))
dev.off()


