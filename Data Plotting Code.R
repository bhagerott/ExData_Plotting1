#download data
file.name<-"./household_power_consumption.txt"
url<-"http://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
zip.file<-"./data.zip"
if (!file.exists("./household_power_consumption.txt")) {
  download.file(url, destfile = zip.file)
  unzip(zip.file)
  file.remove(zip.file)
}

#open the file and isolate relevent data
library(data.table)
DT<-fread(file.name, sep=";", header=TRUE, colClasses=rep("character",9))
DT[DT=="?"]<-NA
DT$Date<-as.Date(DT$Date, format="%d/%m/%Y")
DT<-DT[DT$Date>=as.Date("2007-02-01")& DT$Date<=as.Date("2007-02-02")]
DT$posix <- as.POSIXct(strptime(paste(DT$Date, DT$Time, sep = " "),format = "%Y-%m-%d %H:%M:%S"))

#create graphs
DT$Global_active_power<-as.numeric(DT$Global_active_power)
#Graph 1
png(file = "plot1.png", width = 480, height = 480, units = "px")
hist(DT$Global_active_power, col = "red", main = "Global Active Power", xlab = "Global Active Power (kilowatts)")
dev.off()

#Graph 2
png(file = "plot2.png", width = 480, height = 480, units = "px")
with(DT, plot(posix, Global_active_power, type = "l", xlab = "", ylab = "Global Active Power (kilowatts)"))
dev.off()

#Graph 3
png(file = "plot3.png", width = 480, height = 480, units = "px")
with(DT, plot(posix, Sub_metering_1, type = "l", xlab = "", ylab = "Energy sub metering"))
with(DT, points(posix, type = "l", Sub_metering_2, col = "red"))
with(DT, points(posix, type = "l", Sub_metering_3, col = "blue"))
legend("topright", col = c("black", "blue", "red"), legend = c("Sub_metering_1","Sub_metering_2", "Sub_metering_3"), lty = 1)
dev.off()

#Graph 4
png(file = "plot4.png", width = 480, height = 480, units = "px")
par(mfrow = c(2, 2))
# Graph 4.1
with(DT, plot(posix, Global_active_power, type = "l", xlab = "", ylab = "Global Active Power"))
# Graph 4.2
with(DT, plot(posix, Voltage, type = "l", xlab = "datetime", ylab = "Voltage"))
# Graph 4.3
with(DT, plot(posix, Sub_metering_1, type = "l", xlab = "", ylab = "Energy sub metering"))
with(DT, points(posix, type = "l", Sub_metering_2, col = "red"))
with(DT, points(posix, type = "l", Sub_metering_3, col = "blue"))
legend("topright", col = c("black", "blue", "red"), legend = c("Sub_metering_1","Sub_metering_2", "Sub_metering_3"), lty = 1)
# Graph 4.4
with(DT, plot(posix, Global_reactive_power, type = "l", xlab = "datetime", ylab = "Global_reactive_power"))
dev.off()