# Load your data (your actual submissions)
mydata <- read.csv(file = "....")

#Extract UUID column
uuid <- as.character(mydata$`_uuid`)
audit_check <-data.frame(uuid)

#put all your audit files in a folder called audit
for(i in 1:nrow(mydata)){

    audit <-read.csv(paste0("../audit/", uuid[i],"/audit.csv"))
    audit$node <- sub("/.*/","",audit$node)
    length_interview <- round(sum(((audit$end - audit$start)/60000),na.rm = T),digits = 2)
    audit_check[i,2] <- length_interview
    length_interview_withoutGPS <- round(sum(((audit$end[audit$node!= "geolocation"] - audit$start[audit$node!= "geolocation"])/60000),na.rm = T),digits = 2)
    audit_check[i,3] <- length_interview_withoutGPS

}

names(audit_check) <-c("uuid","length_interview (mins)", "length_interview_withoutGPS (mins)")
audit_check <- audit_check[order(audit_check$length_interview_withoutGPS),]
write.csv(x = audit_check,file = "../audit_check.csv")

