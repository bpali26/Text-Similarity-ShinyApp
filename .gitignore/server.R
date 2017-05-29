
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyServer(function(input, output) {
  
  output$distPlot <- renderPlot({
    
    n<-input$num
    
    for(i in 1:n){
      file[[i]]<-readLines(input$files[[i, 'datapath']])
      filename[i]<-as.character(input$files[[i,'name']])
    }
   
    #file[[i]]<-readLines("./plague/file1.txt")
    filenames<-data.frame(x=rep(filename,n),y=rep(filename,each=n))
    for(i in 1:n)  {
      file[[i]]<-file[[i]][file[[i]]!=""]
      file[[i]]<-tolower(file[[i]])
      file[[i]]<-paste(file[[i]],collapse=" ")
      file[[i]]<-removePunctuation(file[[i]])
      file[[i]]<-removeNumbers(file[[i]])
      file[[i]]<-removeWords(file[[i]],stopwords(kind="en"))
      file[[i]]<-stemDocument(file[[i]],language = "english")
      #if(i == which(filenames==input$keyfile)){keyfiledata<-file[[i]]}
      file[[i]]<-stripWhitespace(file[[i]])
    }
    ##file[[which(filenames==keyfile])]]
    file<-as.vector(file)
    corpfile<-Corpus(VectorSource(file))
    dtm <- DocumentTermMatrix(corpfile)
    docs.df<-as.data.frame(t(as.matrix(dtm)))
    
    similarity<-matrix(rep(0,n*n),nrow=n)
    for(i in 1:n){
      for(j in 1:n){
        similarity[i,j]<-mean(docs.df[,i]*docs.df[,j]>0)/mean(docs.df[,i]>0)
      }
    }
    
    melt_similarity<-melt(similarity)
    ggplot(data = melt_similarity)+ geom_tile(aes(x=filenames$x, y=filenames$y, fill=value))+geom_text(aes(x=filenames$x, y=filenames$y,label=paste0(round(value,2)*100,"%")))+ggtitle("Percentage Similarity in text words")+labs(x = "files",y="files",caption = "by Bhawani Paliwal")+theme(panel.background = element_rect(fill="white"),plot.title = element_text(size = 15,face='bold'),axis.text = element_text(size=12),axis.title = element_text(size=15),legend.title = element_text(size=12),axis.ticks.length = unit(.25, "cm"))
  })
  
  
  
  output$barPlot <- renderPlot({
    
    n<-input$num
    
    for(i in 1:n){
      file[[i]]<-readLines(input$files[[i, 'datapath']])
      filename[i]<-as.character(input$files[[i,'name']])
    }
    keyfiledata<-file[[which(filename==input$keyfile)]]
    
    keyfiledata<-keyfiledata[keyfiledata!=""]
    keyfiledata<-tolower(keyfiledata)
    keyfiledata<-paste(keyfiledata,collapse=" ")
    keyfiledata<-removePunctuation(keyfiledata)
    keyfiledata<-removeNumbers(keyfiledata)
    keyfiledata<-removeWords(keyfiledata,stopwords(kind="en"))
    keyfiledata<-stripWhitespace(keyfiledata)
    
    keyfiledata<-as.data.frame(table(as.factor(strsplit(keyfiledata,split=" ")[[1]])))
    keyfiledata<-arrange(keyfiledata,desc(Freq))[1:10,]
    ggplot(data=keyfiledata, aes(x=Var1, y=Freq)) + geom_bar(stat="identity") + labs(xlab("words"),ylab("Frequency"))
    
    })
})
