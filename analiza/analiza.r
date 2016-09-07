# 4. faza: Analiza podatkov

##Grupiranje podatkov

podatki1 <- data.frame(prenocitve %>% group_by(Regija) %>% summarise(Število=sum(Število)))
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




# združim tabeli izdatki in prenocitve


TABELA1 <- inner_join(izdatki, razlog_prihoda)

ggplot(TABELA1, aes(x = Število, y = Izdatek, col=Država)) + geom_point()

#Iz grafa je opazno, da je nekje odstopanje po številu prenočitev
#in izdatki niso tako visoki, nekje pa je odstopanje po izdatkih
#ki so zelo visoki, je pa zelo malo prenočitev
#uporabim filter, da najdem kje je to

filter(TABELA1, Število == max(Število, na.rm=TRUE))
#Glavna sezona -- Počitnice, sprostitev, rekreacija -- Druge evropske države
filter(TABELA1, Izdatek == max(Izdatek, na.rm=TRUE))
#Maj -- Skrb za zdravje, dobro počutje -- Druge evropske države

TABELA2 <- TABELA1 %>% group_by(Država) %>% 
  summarise(Število = sum(Število,na.rm=TRUE), Izdatek=sum(Izdatek,na.rm=TRUE))
ggplot(TABELA2, aes(x=Število,y=Izdatek)) + geom_point() + geom_smooth()


AU <- filter(TABELA1, Država == "Avstrija") %>% group_by(Čas) %>% 
  summarise(Število = sum(Število,na.rm=TRUE), Izdatek=sum(Izdatek,na.rm=TRUE))
ggplot(AU, aes(x=Število,y=Izdatek,col=Čas)) + geom_point()

NEM <- filter(TABELA1, Država == "Nemčija") %>% group_by(Čas) %>% 
  summarise(Število = sum(Število,na.rm=TRUE), Izdatek=sum(Izdatek,na.rm=TRUE))
ggplot(NEM, aes(x=Število,y=Izdatek,col=Čas)) + geom_point()

