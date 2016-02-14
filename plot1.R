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
