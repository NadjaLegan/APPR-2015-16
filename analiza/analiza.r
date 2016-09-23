# 4. faza: Analiza podatkov

##Grupiranje podatkov

podatki1 <- data.frame(prenocitve %>% 
                         group_by(Regija) %>% 
                         summarise(Število=sum(Število, na.rm = TRUE)))
rownames(podatki1) <-podatki1$Regija
podatki1 <- podatki1[-1]



n <- 3 #REGIJE BOM ZDRUŽILA V 3 SKUPINE

a.norm <- scale(podatki1,scale=FALSE) #povprečje prenočitev ter tabela po regijah z odstopanji od povprečja..
k <- kmeans(a.norm, n, nstart = 1000) #regije razdelim v 3 skupine glede na povprečja
regije <- row.names(podatki1)
m <- match(zemljevid$NAME_1, regije)
zemljevid$skupina <- factor(k$cluster[regije[m]])


ZEM_SKUPINE <- ggplot() + geom_polygon(data = pretvori.zemljevid(zemljevid), 
                                aes(x=long, y=lat, group=group, fill=skupina),
                                color = "grey")
ZEM_SKUPINE <- ZEM_SKUPINE +
  geom_text(data = pretvori.zemljevid(zemljevid) %>% group_by(id, NAME_1) %>% summarise(x = mean(long), y = mean(lat)),
            aes(x = x, y = y, label = NAME_1), color = "black", size = 3.5)

#odstranim še oznake na x,y osi ter poimenovanje osi, ozadnje naredim belo

ZEM_SKUPINE <- ZEM_SKUPINE +
  labs(x="", y="")+
  scale_y_continuous(breaks=NULL)+
  scale_x_continuous(breaks=NULL)+
  theme_minimal()


#Poiščem še centeroide
razdalje <- apply(k$centers, 1, function(y) apply(a.norm, 1, function(x) sum((x-y)^2)))
min.razdalje <- apply(razdalje, 2, min)
manj.razdalje <- apply(razdalje, 1, function(x) x == min.razdalje)
najblizje <- apply(manj.razdalje[,apply(manj.razdalje, 2, any)], 2, which)
centeroidi <- names(najblizje)[order(najblizje)]



### ŠTEVILO TURISTOV PO LETIH

podatki2 <- data.frame(prenocitve %>% 
                         group_by(Leto) %>% 
                         summarise(Število = sum(Število, na.rm = TRUE)))
podatki2$Leto <- podatki2$Leto %>% as.character() %>% as.numeric()


GRAF4 <- ggplot(podatki2, aes(x=Leto,y=Število))+
  geom_point(stat = "identity")+
  labs(title ="Število prenočitev glede na leto")+
  theme_bw() + geom_smooth()


