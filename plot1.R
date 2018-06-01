##### Exploratory Data Analysis - Course Project 1
### Plot 1


### Download and read in datafiles
filename <- "Course_Project_Data.zip"

if(!file.exists("Data")) {
      create.dir("Data")
}

setwd("Data")

if (!file.exists(filename)) {
      fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
      download.file(fileURL, filename, method = "curl")
}

if(!file.exists("Data")) {
      unzip(filename)
}

##### Look at the files
list.files()
library(data.table)
library(dplyr)
library(lubridate)

# Read in the dataset and look at the data
power <- read.table("household_power_consumption.txt", sep = ";", header = TRUE,
                    na.strings = "?")
head(power)
str(power)

# Convert each column to the proper class (c(Date, Time, numeric, ...))
power$Date <- dmy(as.character(power$Date))
power$Time <- hms(as.character(power$Time))
for (i in 3:9) {
      power[ ,i] <- as.numeric(as.character(power[ ,i]))
}
str(power)

## Subset the data for 1/2/2007 to 2/2/2007
subpower <- subset(power, Date == "1/2/2007" | Date == "2/2/2007")
head(subpower)

### Create plot 1 - histogram of Global Active Power
hist(subpower$Global_active_power, col = "red",
     xlab = "Global Active Power (kilowatts)", main = "Global Active Power")
dev.copy(png, file = "plot1.png") ## Copy the histogram plot to a PNG file
dev.off()  # Close the PNG device
