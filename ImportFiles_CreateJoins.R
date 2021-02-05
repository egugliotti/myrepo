# install.packages("plyr")
# install.packages("readr")
# install.packages("dplyr")
# install.packages("networkD3")
library(plyr)
library(readr)
library(dplyr)
library(tidyverse)
library(sjmisc)
library(stringr)

myfiles = list.files(path="/Users/elizabethgugliotti/Desktop/EORES v1.6 Files (PROD-NOSIA-II)", pattern="*.csv", full.names=TRUE)

ElementsMeasureParameters<-read.csv(myfiles[1])
GroupstoSource<-read.csv(myfiles[2])
IsContributingMember<-read.csv(myfiles[3])
IsContributingMember<- IsContributingMember[-1,]
IsContributingMember$surveyed_product_elicitation_id<-as.integer(IsContributingMember$surveyed_product_elicitation_id)
IsDirectContributer<-read.csv(myfiles[4])
NetworkConsistsOfSystem<-read.csv(myfiles[5])
PlatformHasSensingElements<-read.csv(myfiles[6])
POCtoPrd<-read.csv(myfiles[7])               
POCtoReq<-read.csv(myfiles[8])               
POCtoSystem<-read.csv(myfiles[9])               
POCtoVT<-read.csv(myfiles[10])                  
POHtoReq<-read.csv(myfiles[11])                  
POHtoSystem<-read.csv(myfiles[12])              
ProductToTree<-read.csv(myfiles[13])             
ReqtoVT<-read.csv(myfiles[14])                   
SystemHasPlatform<-read.csv(myfiles[15])         
DataSource<-read.csv(myfiles[16])                
Elements<-read.csv(myfiles[17])
GCMDMaster<-read.csv(myfiles[18])
Networks<-read.csv(myfiles[19])  
ObservingSystemCostInformation<-read.csv(myfiles[20])
Parameters<-read.csv(myfiles[22])                
Person<-read.csv(myfiles[23])                    
Platforms<-read.csv(myfiles[24])                 
POH<-read.csv(myfiles[25])
Products<-read.csv(myfiles[26])
Requirements<-read.csv(myfiles[27])              
SourceGroups<-read.csv(myfiles[28])  
Systems<-read.csv(myfiles[29])                   
VTraw<-read.csv(myfiles[36])

EOS<- Systems %>%
  full_join(SystemHasPlatform, by="system_id") %>%
  full_join(Platforms, by="platform_id") %>%
  full_join(PlatformHasSensingElements, by="platform_id") %>%
  full_join(Elements, by="sensing_element_id") %>%
  full_join(ElementsMeasureParameters, by="sensing_element_id") %>%
  full_join(Parameters, by="environmental_parameter_id")%>%
  unite(palma_id, c(palma_id.x ,palma_id.y), sep="") %>% select(-country_names.x, -country_names.y) %>% na_if("") %>%
  select(-system_description,-system_deployment_plans, -system_platform_id, -platform_description,-platform_deployment_plans, -orbit_type, -orbit_altitude_km, 
         -orbit_inclination_deg, -orbit_period_min, -sun_side_equatorial_crossing_mode, -orbit_crossing_time, -nadir_repeat, -nadir_repeat_units, 
         -satellite_longitude_deg, -orbit_eccentricity, -perigee_altitude_km,-apogee_altitude_km, -platform_sensing_element_id, -sensing_element_description, 
         -sensing_element_deployment_plans, -swath_km, -revisit, -revisit_units, -acquisition_mode, -data_cost, -data_policy, -data_latency,-radar_bands,
         -data_latency_units, -country_names, -sensing_element_environmental_parameter_id, -gcmd_variable_l3, -ods_flt_hrs_hods, -ods_flt_hrs_hods_units)
write.csv(EOS, "/Users/elizabethgugliotti/Desktop//EORES v1.6 Files (PROD-NOSIA-II)/Output/EOS.csv", row.names = FALSE)

# Make a "slimmer" version of requirements data with less needed information excluded like comments columns
Req_slim<-Requirements %>%
  select(1:2,4:7,13:15,28:29,31:32,40:42,45:47,60:62,65:67,80:82,85:87,100:102,105:107)
write.csv(Req_slim, "/Users/elizabethgugliotti/Desktop/EORES v1.6 Files (PROD-NOSIA-II)/Output/Req_slim.csv", row.names = FALSE)

# Connect Requirements to EOS
ReqToEOS<- Req_slim %>%
  select(-geographic_coverage_threshold_weight, -geographic_coverage_objective_weight, -horizontal_resolution_objective_weight, -horizontal_resolution_threshold_weight, 
         -vertical_resolution_objective_weight, -vertical_resolution_threshold_weight, -measurement_accuracy_threshold_weight, -measurement_accuracy_objective_weight, -sampling_interval_threshold_weight, 
         -sampling_interval_objective_weight) %>%
  full_join(EOS, by = c("primary_gcmd_variable" = "gcmd_variable")) %>%
  select(-system_id, -platform_id, -sensing_element_id, -sensing_capabilities_remarks, -environmental_parameter_id, -rating)
write.csv(ReqToEOS, "/Users/elizabethgugliotti/Desktop/EORES v1.6 Files (PROD-NOSIA-II)/Output/ReqToEOS.csv", row.names = FALSE)
# Remove stored data frames to free up memory
rm(EOS, Req_slim, ReqToEOS, SystemHasPlatform, Platforms, PlatformHasSensingElements, Elements, ElementsMeasureParameters, Parameters)
# Read in .csvs
EOS<- read.csv("/Users/elizabethgugliotti/Desktop/EORES v1.6 Files (PROD-NOSIA-II)/Output/EOS.csv", header = TRUE)
Req_slim<- read.csv("/Users/elizabethgugliotti/Desktop/EORES v1.6 Files (PROD-NOSIA-II)/Output/Req_slim.csv", header = TRUE)
ReqToEOS<-read.csv("/Users/elizabethgugliotti/Desktop/EORES v1.6 Files (PROD-NOSIA-II)/Output/ReqToEOS.csv", header = TRUE)