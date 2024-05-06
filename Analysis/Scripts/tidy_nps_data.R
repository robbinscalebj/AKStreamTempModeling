library(tidyverse)
library(arrow)
library(here)
# combine data

files_location <- here("Data/Raw_Data/NPS WaterTemp/")

files_list <- list.files(files_location)

site_names <- files_list|>str_remove("Water_Temp.Temp@")|>str_remove(".EntireRecord.csv")|>
  str_remove("Water_Temp.TW2-3_Temp@")|>str_remove("Water_Temp.TW1_Temp@")
site_names

temp_df <- map2(.x = files_list, .y = site_names, ~read_csv(paste0(files_location,"/", .x), skip = 14)|>mutate(site_code = .y))|>
  list_rbind()|>
  rename(datetime_utc = "ISO 8601 UTC", Temp_C = "Value")|>
  mutate(nMonth = month(datetime_utc),
         day_of_year = yday(datetime_utc), 
         Year = year(datetime_utc))

temp_df|>write_parquet(here("Data/Transformed_Data/nps_watertemp.parquet"))


ggplot(blah|>filter(n()>12),aes(x = Year, y = max))+
  geom_point()+
  geom_smooth(method = "lm", se = FALSE)+
  facet_wrap(.~site_code, scales = "free")


