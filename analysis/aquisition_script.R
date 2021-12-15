# EEOB590
# Script to read in multiple files from a single folder and combine into one data frame

# Make sure the path indicated in the first line of each pipe is correct for your files

# For CSV files 
df_csv <- list.files(path = "data/raw/acquisition_examplescripts", pattern='.csv', full.names = TRUE) %>% 
  setNames(., sub("\\.csv$", "", basename(.))) %>% # to add filename as a column
  map_dfr(read_csv, .id = "source") 

# For XLSX files                   
df_xlsx <- list.files(path = "data/raw/acquisition_examplescripts", pattern='.xls', full.names = TRUE) %>% 
  setNames(., sub("\\.xlsx$", "", basename(.))) %>% # to add filename as a column
  map_dfr(read_xlsx, .id = "source") 

