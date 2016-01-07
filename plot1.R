

## Check if data file is present exists and download it if not 

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

## Add a DateTime variable as "POSIXlt" "POSIXt" and convert Date to class "Date"
dataFile$DateTime <- strptime( paste( dataFile$Date, dataFile$Time, sep = " " ), format = "%d/%m/%Y %H:%M:%S" )
dataFile$Date <- as.Date( dataFile$Date, format = "%d/%m/%Y")

## Create the histogram for global active power and export as PNG
png( filename = "plot1.png", width = 480, height = 480, units = "px" )
hist( dataFile$Global_active_power, col = "red", xlab = "Global Active Power (kilowatts)", main = "Global Active Power" )
dev.off()
