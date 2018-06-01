##### Exploratory Data Analysis - Course Project 1
### Plot 3

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

### Plot 3 - plot of daily energy usage conditioned by sub meter
# Create time stamp of dates and time
timestamp <- dmy_hms(paste(subpower$Date, subpower$Time)) 
subpower <- mutate(subpower, 
            timestamp = dmy_hms(paste(Date, Time))
      )
str(subpower)

# Using with to identify the dataset we want to use, we use "plot" to
# plot the sub-metering1 on the y-axis and the time on the x-axis
# we use type = "l" to note we want a line graph and not scatterplot
# we also use the lines command to add the additional conditions for the 
# other submeters

## Note that the dev.copy() function did not produce an adequate png
# because the legend was cut off. Here, we open the png graphics device
# first, make the plot, and shut off the device rather than copy.
png("plot3.png")
with(subpower, {
      plot(Sub_metering_1 ~ timestamp, type = "l",
           ylab = "Global Active Power (kilowatts)", xlab = "")
      lines(Sub_metering_2 ~ timestamp, col = 'Red')
      lines(Sub_metering_3 ~ timestamp, col = 'Blue')
})
# Create the legend
legend("topright", col=c("black", "red", "blue"), lty=1, lwd=2, 
       legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
dev.off()  # Close the PNG device


