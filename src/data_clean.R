library(tidyverse)

# read raw data
data <- read.csv("../data/raw/data_raw.csv")

# filter data
clean_data <- data %>%
  select("Age","Gender","Country","family_history","work_interfere","treatment","remote_work","benefits","seek_help","obs_consequence") %>%
  filter(Age>17 & Age<80)

# drop na
clean_data <- na.omit(clean_data)

# sex
clean_data <- clean_data %>% mutate(Gender = ifelse(Gender %in% c("Female", "female", "F", "f", "FEMALE"), "Female",
                                     ifelse(Gender %in% c("Male", "male","M","m","MALE","Mail", "maile", "Mal"), "Male", "Other")))

# age group
clean_data$age_group <- cut(clean_data$Age, breaks=c(18, 30, 40, 50, 60, 80), right = FALSE, labels = c("18-30","31-40","41-50","51-60","61-80"))

# export csv
write.csv(clean_data, file = "../data/clean/data_clean.csv")
