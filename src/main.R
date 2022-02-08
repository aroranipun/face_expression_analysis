source("utils/openpose_face.utils.R")
source("utils/functions.R")
source("utils/utils.R")
source("utils/mapping.R")
library("tcltk", "dplyr")
source("utils/micro_movements.utils.R")
load(file = "data/face_emotions.RDATA")
#df_params$emotion[which(df_params$emotion=="sad")]<-"sadness"

# Get Parameters-----------------------------
subject_count = length(names(data_list))
                    
pb <- txtProgressBar(min = 0, max = subject_count, style = 3)

for (i in 1: subject_count){
  subject = names(data_list)[i]
  
  for ( j in 1:length(data_list[[i]])){
    emotion = names(data_list[[i]])[j]
    df =get_parameters(list_of_data = data_list[[i]][[j]],mappings = mappings)
    df$emotion= emotion
    df$subject = subject
    if(j==1 & i==1){
      df_params = df
    }else{
      df_params = rbind(df_params,df)
    }
  }
  setTxtProgressBar(pb, i)
}

summary = df_params %>%
  group_by(emotion) %>%
  summarise(across(
    .cols = is.numeric, 
    .fns = list(Mean = mean), na.rm = TRUE, 
    .names = "{col}_{fn}"
  ))


# Plotting parameters----------------------------

library(plotly)

plot_params = function(data, emotion_fil=c(), subject_fil= c(), location_fil =c(),scene=NA){
  
  d = data %>% 
    mutate(
      subject_emotion = paste(subject,"-", emotion)
    )
  
  if(!length(subject_fil)==0){
    d = d %>% filter(subject %in% subject_fil)
  }
  if(!length(location_fil)==0){
    d = d %>% filter(Location %in% location_fil)
  }
  if(!length(emotion_fil)==0){
    d = d %>% filter(emotion %in% emotion_fil)
  }
  
  fig = plot_ly(data = d,
                x = ~shape,
                y = ~mu,
                z = ~kt ,
                color = ~ emotion ,
                type="scatter3d", 
                mode = "markers",
                symbol = ~ subject,  
                symbols = c('circle','x','o',"diamond","sqaure","cross","star","hash"),
                marker = list(size = 5),
                scene = scene,
                hoverinfo = ~Location 
  )
  
  fig = fig %>%  add_paths( split= ~ subject_emotion, showlegend=F)
  
  fig = fig %>% layout(title = ' Locating in Paramter Space',
                       scene = list(xaxis = list(gridcolor = 'rgb(0, 0, 0)',
                                                 zerolinewidth = 5,
                                                 ticklen = 5,
                                                 gridwidth = 1),
                                    yaxis = list(gridcolor = 'rgb(0, 0, 0)',
                                                 zerolinewidth = 5,
                                                 ticklen = 5,
                                                 gridwidth = 1),
                                    zaxis = list(gridcolor = 'rgb(0, 0, 0)',
                                                 zerolinewidth = 5,
                                                 ticklen = 5,
                                                 gridwidth = 1)
                       ),
                       paper_bgcolor = 'rgb(243, 243, 243)',
                       plot_bgcolor = 'rgb(243, 243, 230)')
  return(fig)
}



plot_list<-list()
subjects = unique(df_params$subject)

for(i in 1:subject_count){
  
  f = plot_params(data = df_params,
                 emotion_fil =c() ,
                 location_fil = c(),
                 subject_fil = c(subjects[i]),
                 scene=paste("scene",i,sep = "")
                 )
  
  plot_list = append(plot_list, list(f))
  
}

fig = subplot(plot_list ) %>%  layout(
                                  scene1 = list(domain=list(x=c(0,0.5),y=c(0.5,1)),
                                                   aspectmode='cube'),
                                  scene2 = list(domain=list(x=c(0.5,1),y=c(0.5,1)),
                                                aspectmode='cube'),
                                  scene3 = list(domain=list(x=c(0,0.5),y=c(0,0.5)),
                                                aspectmode='cube'),
                                  scene4 = list(domain=list(x=c(0.5,1),y=c(0,0.5)),
                                                aspectmode='cube'))




f1= plot_params(data = df_params,
                emotion_fil =c() ,
                location_fil = c(),
                subject_fil = c("nipun"),
                scene = "scene1")
f2= plot_params(data = df_params,
                emotion_fil =c() ,
                location_fil = c(),
                subject_fil = c("richa"),scene = "scene2")
f3= plot_params(data = df_params,
                emotion_fil =c() ,
                location_fil = c(),
                subject_fil = c("elisabeth"),scene = "scene3")
f4= plot_params(data = df_params,
                emotion_fil =c() ,
                location_fil = c(),
                subject_fil = c("melissa"),scene = "scene4")
subplot(f1,f2,f3,f4,nrows = 2,heights = c(.5,.5))
