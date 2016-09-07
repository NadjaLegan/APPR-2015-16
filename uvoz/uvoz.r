# Uvozimo funkcije za pobiranje in uvoz zemljevida.
source("lib/libraries.r", encoding = "UTF-8")


##Uvozim tabelo, ki prikazuje število turistov, glede na čas prihoda, razlog prihoda ter državo iz katere prihajajo

stolpci1 = c("Čas","Razlog","Država","Število")
razlog_prihoda <- read.csv2(file="podatki/razlogi.csv", col.names=stolpci1, fileEncoding ="windows-1250",
                            skip=2, nrow=(271-3))


#Uredim prazne prostore z NA ter jih zapolnim z vrednostmi, ki jim pripadajo:
for (i in stolpci1) {
  razlog_prihoda[[i]][razlog_prihoda[i] == " "] <- NA
  razlog_prihoda[[i]][razlog_prihoda[i] == ""] <- NA
}

for (i in stolpci1[-4]) {
razlog_prihoda[[i]] <- na.locf(razlog_prihoda[[i]], na.rm = FALSE)
}

#Zbrišem odvečne vrstice(vse, ki so NA v "St.Prebivalcev"):
razlog_prihoda <- razlog_prihoda[!is.na(razlog_prihoda$Število),]

#Spremenim vsa števila, ki so N ali - v NA 
razlog_prihoda[[4]][razlog_prihoda[4] == "N"] <- NA
razlog_prihoda[[4]][razlog_prihoda[4] == "-"] <- NA

#Stolpec Število spremenim iz factor -> število

razlog_prihoda$Število <- razlog_prihoda$Število %>% as.character() %>% as.numeric()





##Uvozim tabelo, ki prikazuje število turistov, glede na čas prihoda, razlog prihoda ter državo iz katere prihajajo

stolpci2 = c("Regija","Nastanitveni objekt", "Domači/Tuji", "Leto", "Število")
prenocitve <- read.csv2(file="podatki/prenocitve.csv", col.names=stolpci2, fileEncoding ="windows-1250",
                            skip=3, nrow=(700-4))


#Uredim prazne prostore z NA ter jih zapolnim z vrednostmi, ki jim pripadajo:
for (i in names(prenocitve)) {
  prenocitve[[i]][prenocitve[i] == " "] <- NA
  prenocitve[[i]][prenocitve[i] == ""] <- NA
}

for (i in names(prenocitve[-5])) {
  prenocitve[[i]] <- na.locf(prenocitve[[i]], na.rm = FALSE)
}

#Zbrišem odvečne vrstice(vse, ki so NA v "St.Prebivalcev"):
prenocitve <- prenocitve[!is.na(prenocitve$Število),]

#Spremenim vsa števila, ki so z ali - v NA 
prenocitve[[i]][prenocitve[i] == "z"] <- NA
prenocitve[[i]][prenocitve[i] == "-"] <- NA

#Stolpec Število spremenim iz factor -> število in Leto iz število -> faktor

prenocitve$Število <- prenocitve$Število %>% as.character() %>% as.numeric()
prenocitve$Leto <- as.factor(prenocitve$Leto)


##Spremenim imena regij v moji tabeli, da se skladajo z zemljevidom

prenocitve$Regija <- as.character(prenocitve$Regija)
prenocitve$Regija <- prenocitve$Regija %>% gsub("Posavska","Spodnjeposavska",.) 
prenocitve$Regija <- prenocitve$Regija %>% gsub("Primorsko-notranjska","Notranjsko-kraška",.)
prenocitve$Regija <- prenocitve$Regija %>% gsub("Jugovzhodna","Jugovzhodna Slovenija",.)
prenocitve$Regija <- as.factor(prenocitve$Regija)



##Uvozim tabelo, ki prikazuje povprecne izdatke po: ČASU , DRŽAVA TURISTA, RAZLOG PRIHODA

stolpci3 = c("Čas","Razlog","Država", "Izdatek")
izdatki <- read.csv2(file="podatki/izdatki.csv", col.names = stolpci3, fileEncoding ="windows-1250",
                     header = FALSE, skip=1, nrow=(270-2))


#Uredim prazne prostore z NA ter jih zapolnim z vrednostmi, ki jim pripadajo:
for (i in names(izdatki)) {
  izdatki[[i]][izdatki[i] == " "] <- NA
  izdatki[[i]][izdatki[i] == ""] <- NA
}

for (i in names(izdatki[-4])) {
  izdatki[[i]] <- na.locf(izdatki[[i]], na.rm = FALSE)
}

#Zbrišem odvečne vrstice(vse, ki so NA v "St.Prebivalcev"):
izdatki <- izdatki[!is.na(izdatki$Izdatek),]

#Spremenim vsa števila, ki so N in - v NA 
izdatki[[i]][izdatki[i] == "N"] <- NA
izdatki[[i]][izdatki[i] == "-"] <- NA

#V zadnjem stolpcu vzamem samo števila brez črk
izdatki[[4]] <- as.character(izdatki[[4]])
izdatki[[4]] <- izdatki[[4]] %>% gsub("\\M","",.) %>% as.numeric()





## Uvozim tabelo, ki prikazuje prihodke od turistev v evropskih državah


link <- "http://www.indexmundi.com/facts/indicators/ST.INT.ARVL/rankings/europe"
stran <- html_session(link) %>% read_html(encoding = "UTF-8")
tabele <- stran %>% html_nodes(xpath ="//table")
prihodkiEU <- tabele %>% html_table() %>% data.frame()
prihodkiEU <- prihodkiEU[c(2,3)]
names(prihodkiEU) <- c("Država", "Prihodek v letu 2014")

#Izbrišem vejice v številih in jih spremenim iz character -> število

prihodkiEU[2] <- apply(prihodkiEU[2], 2, . %>% gsub("\\,", "", .)) %>% as.numeric()
prihodkiEU[,1] <- as.factor(prihodkiEU[,1])


##Spremenim imena držav v moji tabeli, da se skladajo z zemljevidom in izbrišem tiste, ki niso v zemljevidu

prihodkiEU$Država <- as.character(prihodkiEU$Država)
prihodkiEU$Država <- prihodkiEU$Država %>% gsub("Bosnia and Herzegovina","Bosnia and Herz.",.) 
prihodkiEU$Država <- prihodkiEU$Država %>% gsub("Czech Republic","Czech Rep.",.)
prihodkiEU$Država <- prihodkiEU$Država %>% gsub("Slovak Republic","Slovakia",.)
prihodkiEU$Država <- as.factor(prihodkiEU$Država)

prihodkiEU <- filter(prihodkiEU, ! Država %in% c("Andorra", "Liechtenstein", "Malta", "Monaco", "San Marino"))






####GRAFI#######

GRAF1 <- ggplot(razlog_prihoda %>% group_by(Čas, Država) %>% 
                  summarise(Število = sum(Število, na.rm=TRUE)),
                aes(x=Čas, y=Število, fill=Država)) + 
  geom_bar(stat = "identity",position="dodge")+
  scale_y_continuous(labels=function(n){format(n, scientific = FALSE)}) +
  labs(title ="Število turistov glede na čas in državo prebivališča")+
  theme_bw() 
 


blank_theme <- theme_minimal()+
  theme(
    axis.title.x = element_blank(),
    axis.title.y = element_blank(),
    panel.border = element_blank(),
    panel.grid=element_blank(),
    axis.ticks = element_blank(),
    plot.title=element_text(size=14, face="bold")
  )

GRAF2 <- ggplot(razlog_prihoda %>% filter(Število > 0) %>% group_by(Razlog) 
                %>% summarise(Število = sum(Število, na.rm=TRUE)),
                aes(x="", y=Število, fill=Razlog)) + 
  geom_bar(width = 1, stat = "identity") +
  coord_polar(theta = "y") + 
  scale_y_continuous(breaks=NULL)+
  blank_theme + 
  guides(fill=guide_legend(ncol=2, title=NULL)) + 
  theme(legend.position = "bottom")+
  labs(title ="Število turistov glede na razlog prihoda", x="", y="")


GRAF3 <- ggplot(data = prenocitve %>%
                  group_by(Nastanitveni.objekt,Domači.Tuji) %>%
                  summarise(Število = sum(Število, na.rm=TRUE)), 
                aes(x= Nastanitveni.objekt, y=Število, fill=Domači.Tuji))+
  geom_bar(stat = "identity", position = "dodge")+
  scale_y_continuous(labels=function(n){format(n, scientific = FALSE)})+
  theme_minimal() + 
  guides(fill=guide_legend(ncol=1, title=NULL)) + 
  labs(title ="Število turistov glede na nastanitvene objekte", x="Nastanitveni objekt")












