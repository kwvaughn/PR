# This is a transcribed version of Cody Bjornson's script for cleaning gauge data from the USGS.
# For screencaps of his comments, see JPGs labeled Script1, Script2, Script3 in 00 Doc

setwd("H:/GRG Honors/50138000_Guanajibo/")
A <- read.csv("1995.txt", sep = "\t")

A$precision <- NULL
A$accuracy_cd <- NULL
A$dd <- NULL
A$tz_cd <- NULL
A$site_no <- NULL
A$remark <- NULL

B <- cbind(read.fwf(file = textConnection(as.character(A[,1])),
                    widths = c(4,2,2,2,2,2),
                    colClasses = "character",
                    col.names = c("YYYY", "MM", "dd", "hh", "mm", "ss")),
           A[-1])

C <- B[2:nrow(B),]
D <- C[which(C[,"YYYY"]=="1995"),]
E <- D[which(D[,"ss"]=="00"),]
F <- E[which(E[,"mm"]=="00"|E[,"mm"]=="15"|E[,"mm"]=="30"|E[,"mm"]=="45"),]

if((as.integer(F[1,1]))%%4==0){ndayfeb<-29}else{ndayfeb<-28}

calendardays<-c(31,ndayfeb,31,30,31,30,31,31,30,31,30,31)

l<-length(F[,2]) ; currentday<-vector(mode="integer",length=l)

for (i in 1:l){
  m<-as.integer(F[i,2])
  d<-as.integer(F[i,3])
  currentday[i:l]<-sum(calendardays[1:m-1])+d
}

G <-cbind(F[,1:3],currentday,F[,4:7])

hour<-(as.integer(G$currentday-1)*24)+(as.integer(G$hh))

H <- cbind(G[,1:4], hour, G[,5:ncol(G)])

I <- cbind(H[,5],H[,9])

J <- rbind(I, c(I[nrow(I),1]+1, 0))

hryrprev <- 0
disyrprev <- 0
k <- 1

avgdis <- matrix(, nrow = J[nrow(J), 1], ncol = 3)

for(i in 1:nrow(J)){
  hryr <- J[i,1]
  disyr <- J[i,2]
  if(hryr == hryrprev){
    disyrprev <- disyr + disyrprev
    k <- k+1
  }else{
    avgdis[J[i-1,1],1] <- J[i-1,1]
    avgdis[J[i-1,1],2] <- disyrprev/k
    avgdis[J[i-1,1],3] <- k
    k <- 1
    disyrprev <- 0
  }
  hryrprev <- hryr
}

avgdism3 <- avgdis[,2]*0.0283168

write.csv(avgdism3, "guana1995.csv")
  