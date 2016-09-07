# 4. faza: Analiza podatkov

## Najprej narišem graf po letih, kolike je prenočitev vsako leto:

GRAF4 <- ggplot(data = prenocitve %>% group_by(Leto) %>% summarise(Število = sum(Število)),
                aes(x=as.numeric(as.character(Leto)), y=Število)) +
  geom_path(stat = "identity", color = "orange")+
  labs(title ="Število prenočitev turistev v Sloveniji, glede na leto", x="Leto", y="")+
  theme_bw()

#NI posebmih zakonitosti oz. povezav

## Naredim napoved za število prenočitev, glede na pretekle podatke:





