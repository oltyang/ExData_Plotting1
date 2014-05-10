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
png("plot2.png", width = 480, height = 480)
with(dfFiltered, {
  plot(Global_active_power ~ DateTime, xlab = "", ylab = "Global Active Power (kilowatts)", type = "n")
  lines(DateTime, Global_active_power)})
dev.off()

# Setting back the regional settings to the system default
Sys.setlocale(locale = "")
