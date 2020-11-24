
re_process_data <- function(list_of_data, mappings){
  # This will process Joe's code and identify steams for various face portions
  list_of_data$Vx = cbind(list_of_data$V1[,,1],list_of_data$V2[,,1],list_of_data$V3[,,1])
  list_of_data$Vy = cbind(list_of_data$V1[,,2],list_of_data$V2[,,2],list_of_data$V3[,,2])
  
  #Handle NAs---------------
  
  face_sections = mappings$face_sections
  
  # Handle lack of one pupil data--------------------
  face_sections = face_sections[-which(face_sections=="pupils")]
  
  V = mappings$V
  mapped_data = list()
  
  # all(face_sections %in% names(mappings))
  for(i in face_sections){
    pos = which(V %in% mappings[[i]])
    
    mat_x = list_of_data$Vx[,pos]
    mat_y = list_of_data$Vy[,pos]
    dimension = dim(mat_x)
    
    mapped_data[[i]] = array(c(mat_x,mat_y), dim = c(dimension,2))
  }
  mapped_data[["fps"]] = list_of_data$FPS
  mapped_data[["face_sections"]] = face_sections 
  return(mapped_data)
}
get_speed <- function(mapped_data){
  # This will get speed for each face point
  speed <- list()
  
  for (i in mapped_data$face_sections){
    position_matrix = mapped_data[[i]]
    
    vel_x <- diff(position_matrix[, , 1])
    vel_y <- diff(position_matrix[, , 2])
    
    vel_norm = sqrt(vel_x^2 +vel_y^2)
    speed[[i]]= vel_norm
  }
  return(speed)
}
speed_combine <- function(list_of_speeds, type = "concatenate"){
  
  if(type == "concatenate"){
    for( i in 1:length(list_of_speeds)){
      list_of_speeds[[i]] <- as.numeric(list_of_speeds[[i]])
    }
  }
  
  if(type == "mean"){
    for( i in 1:length(list_of_speeds)){
      list_of_speeds[[i]] <- apply(X = list_of_speeds[[i]],MARGIN = 1,FUN = mean)
    }
  }
  return(list_of_speeds)
}

