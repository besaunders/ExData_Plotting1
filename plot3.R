# This R code reads in a data file from the UC Irvine Machine Learning Repository, detailing the
# power consumption in one household over a period of a few years. The data will be trimmed to
# that of February 1 and 2, 2007, for analysis.

# The data.table library is is being used for the fread function, which reads in large data files
# very quickly compared to other methods. This program uses memory quite inefficiently, but since
# there is more than enough on most modern machines to handle the data file, I am using the fread
# and trim methodology rather than reading in line by line and only loading what is required -
# which would require more coding and likely be less efficient. If the data set is much larger
# than memory, preprocessing with Unix tools would probably be the most efficient mechanism.

# The data is read as character for all columns because the data set uses question marks for
# unavailable marks. Fortunately, none exist for the two days in question, so after trimming
# to those days the numerical columns can be made the numeric data type

# The date and time are combined to obtain one date/time measure called "datetime" for graphing
# purposes

# The data file "household_power_consumption.txt" is at the following URL:
# https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip
# It needs to be uncompressed, and the data should be in the same place as the working directory
# of the program.


library(data.table)
epcd <- fread("household_power_consumption.txt",sep=";",colClasses="character")
epcf2 <- data.frame(epcd[Date=="1/2/2007" | Date=="2/2/2007",])
for (col in 3:9) {
   epcf2[,col] = as.numeric(epcf2[,col])
}
epcf2$datetime <- strptime(paste(epcf2$Date,epcf2$Time),"%d/%m/%Y %H:%M:%S")

png(filename="plot3.png",width=480,height=480)
with(epcf2,plot(datetime,Sub_metering_1,type="l",xlab="",ylab="Energy sub metering"))
lines(epcf2$datetime,epcf2$Sub_metering_2,col="red")
lines(epcf2$datetime,epcf2$Sub_metering_3,col="blue")
legend("topright",lty=1,lwd=2,col=c("black","red","blue"),legend=names(epcf2)[7:9])
dev.off()
