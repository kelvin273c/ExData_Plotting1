#This script checks the current working directory for the household power consumption zip file
#If it doesn't exist, it will download it and unzip it

zipfilename<-paste(getwd(),"household_power_consumption.zip",sep="/")

if (!file.exists(zipfilename)){
  print("Downloading household consumption zip file")
  download.file(url="https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",destfile='./household_power_consumption.zip',method="curl")
  unzip("./household_power_consumption.zip")
}

#Read a subset of the large data file.
#We only need 1/2/2007 and 2/2/2007
consumptiondata<-subset(read.table('household_power_consumption.txt',header=FALSE ,na.strings="?",sep=";",col.names=c("Date","Time","Global_active_power","Global_reactive_power","Voltage","Global_intensity","Sub_metering_1","Sub_metering_2","Sub_metering_3")),Date == "1/2/2007" | Date == "2/2/2007")

#Change the class type of the data table columns
consumptiondata[,"Date"]<-as.Date(consumptiondata[,"Date"],"%d/%m/%Y")
consumptiondata[,"Time"]<-as.character(consumptiondata[,"Time"])
for (i in 3:9){
  consumptiondata[,i]<-as.numeric(consumptiondata[,i])
}

#Creates a POSIXlt class objecgt and bind it to the data frame
datetimecol<-strptime(paste(consumptiondata[,"Date"],consumptiondata[,"Time"]),format="%Y-%m-%d %H:%M:%S")
twodays<-which(consumptiondata[,"Date"] == "2007-02-01" | consumptiondata[,"Date"] == "2007-02-02")
consumptiondata<-cbind(consumptiondata,datetimecol)

#Open a PNG Graphics Device
plotfilename<-paste(getwd(),"plot2.png",sep="/")
png(plotfilename)

#cautionary
par(mfrow=c(1,1))

#plot two
plot(consumptiondata[twodays,10],consumptiondata[twodays,3],xlab='',ylab='Global Active Power (kilowatts)', type="l")

#Close the png device
dev.off()