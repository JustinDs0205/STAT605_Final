setwd('/Users/zdliu/Desktop/605_2024fall/Data')
mydata = read.csv("DOT_Traffic_Speeds_NBE.csv", header = TRUE)
linkid = unique(mydata$LINK_ID)
for(i in linkid){
  newdata = mydata[mydata$LINK_ID==i, ]
  write.csv(newdata, paste("linkid_", as.character(i), ".csv", sep=""), row.names=FALSE)
}