library(tidyverse)
library(lubridate)
library(ggplot2)
getwd()
setwd('E:/DA_Course/CaseStudy_Cyclistics/Extraction/')

##adding datasets
aug2022 <- read_csv("202208-divvy-tripdata.csv")
sep2022 <- read_csv("202209-divvy-tripdata.csv")
oct2022 <- read_csv("202210-divvy-tripdata.csv")
nov2022 <- read_csv("202211-divvy-tripdata.csv")
dec2022 <- read_csv("202212-divvy-tripdata.csv")
jan2023 <- read_csv("202301-divvy-tripdata.csv")
feb2023 <- read_csv("202302-divvy-tripdata.csv")
mar2023 <- read_csv("202303-divvy-tripdata.csv")
apr2023 <- read_csv("202304-divvy-tripdata.csv")
may2023 <- read_csv("202305-divvy-tripdata.csv")
jun2023 <- read_csv("202306-divvy-tripdata.csv")
jul2023 <- read_csv("202307-divvy-tripdata.csv")

str(aug2022)
library(dplyr)

feb2023<- mutate(feb2023,started_at=as_datetime(started_at))
feb2023<- mutate(feb2023,ended_at=as_datetime(ended_at))

##stacking all data into one large dataframe

alltrips <- bind_rows(aug2022,sep2022,oct2022,nov2022,dec2022,jan2023,feb2023,mar2023,apr2023,may2023,jun2023,jul2023)

## CLEANING

colnames(alltrips)
nrow(alltrips)
dim(alltrips)
head(alltrips)
str(alltrips)
alltrips<- mutate(alltrips,started_at=as_datetime(started_at),ended_at=as_datetime(ended_at))
summary(alltrips)
table(alltrips$member_casual)
## lets say our company wanted to retag casuals to customers and members as subscribers
alltrips<- alltrips %>%
  mutate(member_casual=recode(member_casual,"casual"="customer","member"="subscriber"))  
table(alltrips$member_casual)
alltrips$date <- as.Date(alltrips$started_at)
head(alltrips)
alltrips$month <-format(as.Date(alltrips$started_at),"%m")
alltrips$year <- format(as.Date(alltrips$started_at),"%Y")
alltrips$day <- format(as.Date(alltrips$started_at),"%d")
alltrips$day_of_week <- format(as.Date(alltrips$started_at),"%A")
alltrips$ride_length<-difftime(alltrips$ended_at,alltrips$started_at)
alltrips$ride_length<-seconds_to_period(alltrips$ride_length)
is.numeric(alltrips2$ride_length)
alltrips %>% filter(alltrips$ride_length<0) %>% select(ride_length) ##There seem to be negative values in ride_length,turns out, it was because of some maintenance job
alltrips$ride_length <- period_to_seconds(alltrips$ride_length)
mean(alltrips$ride_length)
alltrips$ride_length <-as.numeric(as.character(alltrips$ride_length))
alltrips2<-(alltrips[!(alltrips$ride_length<0),])
str(alltrips2)
is.numeric(alltrips2$ride_length)
alltrips2<- data.frame(alltrips2)

##Analysing Data
mean(alltrips2$ride_length)
median(alltrips2$ride_length)
max(alltrips2$ride_length)
min(alltrips2$ride_length)

summary(alltrips2$ride_length)

aggregate(alltrips2$ride_length ~ alltrips2$member_casual,FUN=mean)
aggregate(alltrips2$ride_length ~ alltrips2$member_casual,FUN=median)
aggregate(alltrips2$ride_length ~ alltrips2$member_casual,FUN=max)
aggregate(alltrips2$ride_length ~ alltrips2$member_casual,FUN=min)
aggregate(alltrips2$ride_length ~ alltrips2$member_casual + alltrips2$day_of_week,FUN=mean)

alltrips2$day_of_week <- ordered(alltrips2$day_of_week, levels=c("Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"))
wday(alltrips2$started_at,label=TRUE)

alltrips2 %>% 
  mutate(weekday=wday(started_at,label=TRUE)) %>%
  group_by(member_casual,weekday) %>%
  summarise(no_of_rides=n(),
            average_duration=mean(ride_length)) %>%
  arrange(member_casual,weekday)

##Visualizing

#on the basis of no. of rides
alltrips2 %>% 
  mutate(weekday=wday(started_at,label=TRUE)) %>%
  group_by(member_casual,weekday) %>%
  summarise(no_of_rides=n(),average_duration=mean(ride_length)) %>%
  ggplot(aes(x=weekday,y=no_of_rides,fill=member_casual)) +
  geom_col(position="dodge")

#on the basis of average trip duration

alltrips2 %>%
  mutate(weekday=wday(started_at,label=TRUE)) %>%
  group_by(member_casual,weekday) %>%
  summarize(average_duration=mean(ride_length)) %>%
  ggplot(aes(x=weekday,y=average_duration,fill=member_casual)) + geom_col(position="dodge") 

##Export to csv
counts <- aggregate(alltrips2$ride_length ~ alltrips2$member_casual + alltrips2$day_of_week,FUN=mean)
write.csv(counts,file="E:/DA_Course/CaseStudy_Cyclistics/avg_ride_length_r.csv")
