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

# create graphic
png(filename = "plot1.png", width = 480, height = 480)

with (data, 
        hist(
            Global_active_power, 
            main = "Global Active Power",  
            xlab = "Global Active Power (Kilowatts)", 
            ylab = "Frequency",
            col = "red"
        )
)

# save graphic
dev.off()