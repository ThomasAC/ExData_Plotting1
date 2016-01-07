## Check if data file is present exists and downloads it if not 

if( !file.exists("household_power_consumption.txt") ) {
  temp <- tempfile()
  download.file( "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",temp, method = "curl" ) ## works also without specifying the method
  file <- unzip(temp)
  unlink(temp)
}

## Read data ( only for 1/2/2007 and 2/2/2007 : lines 66637 to 69516 of complete file )
dataFileName <- "household_power_consumption.txt"

dataFile <- read.table( dataFileName, header = FALSE, sep = ";", na.strings = "?",
                        colClasses = c( rep("character", 2), rep("numeric", 7) ),
                        skip = 66637, nrows = 2880, 
                        col.names = c( "Date", "Time", "Global_active_power", "Global_reactive_power", "Voltage", 
                                       "Global_intensity", "Sub_metering_1", "Sub_metering_2", "Sub_metering_3") )

## Add a DateTime variable as POSIXlT and convert Date to class "Date"
dataFile$DateTime <- strptime( paste( dataFile$Date, dataFile$Time, sep = " " ), format = "%d/%m/%Y %H:%M:%S" )
dataFile$Date <- as.Date( dataFile$Date, format = "%d/%m/%Y")

### Creates the 4 plots on the same figure and export to PNG
png( filename = "plot4.png", width = 480, height = 480, units = "px" )

par( mfrow = c(2,2) )

plot( dataFile$DateTime, dataFile$Global_active_power, type = "n", ann = FALSE )
title( ylab = "Global Active Power (kilowatts)" )
lines( dataFile$DateTime, dataFile$Global_active_power )

plot( dataFile$DateTime, dataFile$Voltage, type = "n", ann = FALSE )
title( ylab = "Voltage", xlab = "datetime" )
lines( dataFile$DateTime, dataFile$Voltage )

plot( dataFile$DateTime, dataFile$Sub_metering_1, type = "n", ann = FALSE )
lines( dataFile$DateTime, dataFile$Sub_metering_1, col = "black" )
lines( dataFile$DateTime, dataFile$Sub_metering_2, col = "red" )
lines( dataFile$DateTime, dataFile$Sub_metering_3, col = "blue" )
legend("topright", c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), col = c( "black", "red", "blue") , lwd = 1, bty = "n")  
title( ylab = "Energy sub metering" )

plot( dataFile$DateTime, dataFile$Global_reactive_power, type = "n", ann = FALSE )
title( ylab = "Global_reactive_power", xlab = "datetime" )
lines( dataFile$DateTime, dataFile$Global_reactive_power )
dev.off()