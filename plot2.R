##### Exploratory Data Analysis - Course Project 1
### Plot 2

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

### Plot 2 - plot of daily usage of Global Active Power
# Create time stamp of dates and time
timestamp <- dmy_hms(paste(subpower$Date, subpower$Time)) 
subpower <- mutate(subpower, 
            timestamp = dmy_hms(paste(Date, Time))
      )
str(subpower)

# Using with to identify the dataset we want to use, we use "plot" to
# plot the Power usage on the y-axis and the time on the x-axis
# we use type = "l" to note we want a line graph and not scatterplot
par(mfrow = c(1, 1), mar = c(4, 4, 2, 2))
with(subpower, plot(timestamp, Global_active_power, type = "l",
     xlab = "", ylab = "Global Active Power (kilowatts)"))
# Create the copy in a png file
dev.copy(png, file = "plot2.png") ## Copy the histogram plot to a PNG file
dev.off()  # Close the PNG device
