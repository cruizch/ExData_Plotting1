data <- data.frame()

# date range to read from the household power consumption file
begin <- as.Date("2007-02-01")
end   <- as.Date("2007-02-02")

# open the data file
data.file <- file("household_power_consumption.txt", "r")

# read the header to start to populate the data frame
column.names <- readLines(data.file, n = 1)

# read the file line by line 
while (length(row <- readLines(data.file, n = 1)) > 0) {
    
    row <- strsplit(row, ";")[[1]]
    row.date <- as.Date(row[1], format = "%d/%m/%Y")
    
    # accept just those rows between the begin and the end dates
    if (row.date >= begin & row.date <= end) {
        
        # add a correctly parsed row
        data <- rbind(
            data, 
            data.frame(
                row.date,
                row[2],
                as.numeric(row[3]),
                as.numeric(row[4]),
                as.numeric(row[5]),
                as.numeric(row[6]),
                as.numeric(row[7]),
                as.numeric(row[8]),
                as.numeric(row[9])
            )
        )
        
    }
    
}

# assign column names
column.names <- strsplit(column.names, ";")[[1]]
names(data) <- column.names

# close the data file
close(data.file)

# specify the locale to show the weekday names in english
Sys.setlocale("LC_TIME", "English")

# create graphic
png(filename = "plot4.png", width = 480, height = 480)

par(mfrow = c(2, 2))

with (data, {

    plot(
        as.POSIXlt(paste(Date, Time)), 
        Global_active_power, 
        xlab = "",
        ylab = "Global Active Power",
        type = "l"
    )
    
    plot(
        as.POSIXlt(paste(Date, Time)), 
        Voltage, 
        xlab = "datetime",
        ylab = "Voltage",
        type = "l"
    )
    
    plot(
        as.POSIXlt(paste(Date, Time)), 
        Sub_metering_1, 
        xlab = "",
        ylab = "Energy Sub Metering",
        type = "l",
        col = "black"
    )
    
    lines(
        as.POSIXlt(paste(Date, Time)), 
        Sub_metering_2, 
        col = "red"
    )
    
    lines(
        as.POSIXlt(paste(Date, Time)), 
        Sub_metering_3, 
        col = "blue"
    )
    
    legend("topright", lty = 1, col = c("black", "red", "blue"), 
                legend = c("Sub Metering 1", "Sub Metering 2", "Sub Metering 3"),
                    cex = 0.9, bty = "n")
    
    plot(
        as.POSIXlt(paste(Date, Time)), 
        Global_reactive_power, 
        xlab = "datetime",
        ylab = "Global Reactive Power",
        type = "l"
    )

})

# save graphic
dev.off()