#load library to read excel file
library(readxl)
#read data
official_data <- read_excel(path = "../official_dataset.xlsx", sheet = "clean_data", skip = 1)
uuid <- as.character(official_data$`_uuid`)
audit_check <- data.frame( uuid,
                           official_data$enumerator_name,
                           official_data$organisation_name,
                           official_data$point_code,
                           official_data$displacement_status,
                           official_data$baladiya_label
)

for(i in 1:nrow(official_data)){
  
  if(substr(as.character(official_data$point_code[i]), 1, 1)!= substr(as.character(official_data$displacement_status[i]), 1, 1)){
    audit_check[i,7] <-"TRUE"
  }else audit_check[i,7] <-""
  
  if(file.exists(paste0("../audit/", uuid[i],"/audit.csv"))) {
    audit <-read.csv(paste0("../audit/", uuid[i],"/audit.csv"))
    audit$node <- sub("/.*/","",audit$node)
    length_interview <- round(sum(((audit$end - audit$start)/60000),na.rm = T),digits = 2)
    audit_check[i,8] <- length_interview
    length_interview_without <- round(sum(((audit$end[audit$node!= "geolocation"] - audit$start[audit$node!= "geolocation"])/60000),na.rm = T),digits = 2)
    audit_check[i,9] <- length_interview_without
    
  }
}
names(audit_check) <-c("uuid", "enumerator_name","organisation_name" ,"point_code", "displacement_status","baladiya","wrong popuation" ,"length_interview (mins)", "length_interview_withoutGPS (mins)")
audit_check <- audit_check[order(audit_check$length_interview_withoutGPS),] 
write.csv(x = audit_check,file = "../audit_check.csv")

