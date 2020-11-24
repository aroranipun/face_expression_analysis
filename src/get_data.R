#Get Data-------------------------
library("R.matlab")
library("stringr")
files_paths = list.files(path = "data/mat files/",pattern = "processed",full.names = T)
files_names = list.files(path = "data/mat files/",pattern = "processed")

data_list=list()
for(i in 1:length(files_paths)){
  temp = readMat(files_paths[i])
  
  name = gsub(x = files_names[i] ,pattern = "_processed_segmented_processed.mat",replacement = "")
  name = str_split(string = name,pattern = "_")
  subject =tolower( name[[1]][1])
  emotion = tolower( name[[1]][2])
  
  if(!subject %in% names(data_list)){
    data_list[[subject]] <- list()
  }
  data_list[[subject]][[emotion]] <- temp
}

save(data_list,file = "data/face_emotions.RDATA")
