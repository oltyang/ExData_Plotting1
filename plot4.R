fnData <- "household_power_consumption.txt"

if (!file.exists(fnData)) {                                         # Checking the existence of the files
  stop(paste("The <", fnData, "> input file is missing!", sep=""))  # Concatenating and displaying the error message  
}

# Loading the data
dfData <- read.table(fnData, header = TRUE, na.strings = "?", sep=";", comment.char = "", 
                     colClasses = append(rep("character", 2), rep("numeric", 7)))

# Selecting only the relevant date interval, and creating a variable, which contains the Date and Time in POSIXct format
dfFiltered <- transform(subset(dfData, Date == "1/2/2007" | Date == "2/2/2007"), 
                        DateTime = as.POSIXct(strptime(paste(Date, Time, sep="_"), "%d/%m/%Y_%H:%M:%S")))

# Setting English regional settings
Sys.setlocale(locale="C")

# Creating the plot on the png graphical device
png("plot4.png", width = 480, height = 480)

par(mfrow = c(2,2), mar = c(4,4,3,1),                               # 4 diagrams in 2 rows, and 2 columns with proper
    bg = "transparent")                                             # margin sizes and transparent background color
                                                                    
with(dfFiltered, {
  plot(Global_active_power ~ DateTime, xlab = "", 
       ylab = "Global Active Power", type = "n")                    
  lines(DateTime, Global_active_power)})                            # Topleft      

with(dfFiltered, {
  plot(Voltage ~ DateTime, xlab = "datetime", type = "n")
  lines(DateTime, Voltage)})                                        # Topright

with(dfFiltered, {
  plot(Sub_metering_1 + Sub_metering_2 + Sub_metering_3 ~ DateTime, 
       xlab = "", ylab = "Energy sub metering", type = "n")
  lines(DateTime, Sub_metering_1)
  lines(DateTime, Sub_metering_2, col = "red")
  lines(DateTime, Sub_metering_3, col = "blue")
  legend("topright", cex = 0.95, lty=1, col = c("black", "red", "blue"), 
         legend=c("Sub_metering_1", "Sub_metering_2", 
                  "Sub_metering_3"), bty = "n")})                   # Bottomleft

with(dfFiltered, {
  plot(Global_reactive_power ~ DateTime, xlab = "datetime", type = "n")
  lines(DateTime, Global_reactive_power)})                          # Bottomright

dev.off()

# Setting back the regional settings to the system default
Sys.setlocale(locale = "")
