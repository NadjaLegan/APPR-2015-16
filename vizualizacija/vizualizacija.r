# 3. faza: Izdelava zemljevida

source("lib/libraries.r", encoding = "UTF-8")

# Uvozimo zemljevid.
zemljevid <- uvozi.zemljevid("http://biogeo.ucdavis.edu/data/gadm2.8/shp/SVN_adm_shp.zip",
                             "SVN_adm1", encoding = "UTF-8")


# Preuredimo podatke, da jih bomo lahko izrisali na zemljevid.

pretvori.zemljevid <- function(zemljevid, pogoj = TRUE) {
  fo <- fortify(zemljevid)
  data <- zemljevid@data
  data$id <- as.character(0:(nrow(data)-1))
  return(inner_join(fo, data, by="id"))
}




SLO <- pretvori.zemljevid(zemljevid)

##Spremenim imena regij v moji tabeli, da se skladajo z zemljevidom

prenocitve$Regija <- as.character(prenocitve$Regija)
prenocitve$Regija <- prenocitve$Regija %>% gsub("Posavska","Spodnjeposavska",.) 
prenocitve$Regija <- prenocitve$Regija %>% gsub("Primorsko-notranjska","Notranjsko-kraška",.)
prenocitve$Regija <- prenocitve$Regija %>% gsub("Jugovzhodna","Jugovzhodna Slovenija",.)
prenocitve$Regija <- as.factor(prenocitve$Regija)


##Naredim zemljevid, kjer prikažem stopnjo umrljivosti (zelena-nizka, rdeča-visoka)

ZEM_SLO <- ggplot() + geom_polygon(data = prenocitve %>% 
                                     filter(Leto == 2015) %>% group_by(Regija) %>%
                                     summarise(Število = sum(Število)) %>% 
                                     right_join(SLO, by = c("Regija" = "NAME_1")),
                                   aes(x = long, y = lat, group = group, fill = Število), 
                                   color = "white") +
  guides(fill = guide_colorbar(title = "Število turistov")) +
  ggtitle("Število prenočitev po regijah v letu 2015")

#Na zemljevid dodam imena regij

ZEM_SLO <- ZEM_SLO +
  geom_text(data = SLO %>% group_by(id, NAME_1) %>% summarise(x = mean(long), y = mean(lat)),
            aes(x = x, y = y, label = NAME_1), color = "grey", size = 3.5)

#odstranim še oznake na x,y osi ter poimenovanje osi, ozadnje naredim belo

ZEM_SLO <- ZEM_SLO +
  labs(x="", y="")+
  scale_y_continuous(breaks=NULL)+
  scale_x_continuous(breaks=NULL)+
  theme_minimal()


##Uvozim še zemljevid sveta, da bom lahko izrisala izdatke turistov glede na državo v Evropi

zemljevid2 <- uvozi.zemljevid("http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/110m/cultural/ne_110m_admin_0_countries.zip",
                        "ne_110m_admin_0_countries") 

EU <- pretvori.zemljevid(zemljevid2, zemljevid2$continent == "Europe")



ZEM_EU <- ggplot() + geom_polygon(data = prihodkiEU %>% 
                                     filter(Leto == 2015) %>%
                                     right_join(EU, by = c("Država" = "NAME_1")),
                                   aes(x = long, y = lat, group = group, fill = Število), 
                                   color = "white") +
  guides(fill = guide_colorbar(title = "Število turistov")) +
  ggtitle("Število prenočitev po regijah v letu 2015")
