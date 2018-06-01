##### Exploratory Data Analysis - Course Project 1
### Plot 4

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

### Plot 4 - panel of plots
# Create time stamp of dates and time
timestamp <- dmy_hms(paste(subpower$Date, subpower$Time)) 
subpower <- mutate(subpower, 
            timestamp = dmy_hms(paste(Date, Time))
      )
str(subpower)

## We need to set the parameters to build the format for the 4 plots
# We want a 2x2 set of plots so we'll use mfrow to create 2 rows and 2 columns

# Start panel plots within this expression below
{ 
# open the png graphics device
png("plot4.png")

# Define parameters
par(mfrow = c(2, 2), mar = c(4, 4, 2, 2))

# Plot 1 - From Plot2.r (in position 1,1)
with(subpower, plot(timestamp, Global_active_power, type = "l",
                    xlab = "", ylab = "Global Active Power (kilowatts)"))

# Plot 2 - Daily voltage - similar to above but with Voltage on y-axis
with(subpower, plot(timestamp, Voltage, type = "l",
                    xlab = "", ylab = "Voltage"))
mtext("datetime", side = 1, line = 2)

# Plot 3 - From Plot 3.r (in position 2,1)
with(subpower, {
      plot(Sub_metering_1 ~ timestamp, type = "l",
           ylab = "Global Active Power (kilowatts)", xlab = "")
      lines(Sub_metering_2 ~ timestamp, col = 'Red')
      lines(Sub_metering_3 ~ timestamp, col = 'Blue')
})
# Create the legend
legend("topright", col=c("black", "red", "blue"), lty=1, lwd=1, 
       legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

# Plot 4 - Daily global reactive power
with(subpower, plot(timestamp, Global_reactive_power, type = "l",
                    xlab = "", ylab = "Global Reactive Power"))
mtext("datetime", side = 1, line = 2)

#dev.copy(png, file = "plot4.png") ## Copy the histogram plot to a PNG file
dev.off()  # Close the PNG device

}

