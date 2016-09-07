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

Drzave <- levels(prihodkiEU$Država)
EU <- pretvori.zemljevid(zemljevid2)
NOV <- EU %>% filter(name %in% Drzave)


ZEM_EU <- ggplot() + geom_polygon(data = prihodkiEU %>%
                          right_join(NOV, by = c("Država" = "name")),
                                   aes(x = long, y = lat, group = group, fill = `Prihodek v letu 2014`), 
                                   color = "white") +
  guides(fill = guide_colorbar(title = "Višina prihodkov")) +
  ggtitle("Prihodki od turizma v nekaterih evropskih državah")+
  xlim(-25, 45) + ylim(35, 75)

#Na zemljevid dodamo ime Slovenija

ZEM_EU <- ZEM_EU +
  geom_text(data = NOV %>% filter(name == "Slovenia") %>% group_by(id, name) %>% summarise(x = mean(long), y = mean(lat)),
            aes(x = x, y = y, label = name), color = "orange", size = 3.5)

ZEM_EU <- ZEM_EU +
  labs(x="", y="")+
  theme_minimal()