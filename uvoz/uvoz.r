#prihodi in prenočitve tujih ter domačih turistov po nastanitvenih objektih za januar 2015
uvozi.nastobjJanuar <- function() {
  return(read.csv2("podatki/VrsteNastanitvenihObjektovJanuar.csv", sep = ";", as.is = TRUE,
                   #row.names = 1,
                   skip=4,
                   col.names = c("Objekti","Prihodi_turistov_domači","Prihodi_turistov_tuji","Prenočitve_turistov-domači","Prenočitve_turistov-tuji"),
                   fileEncoding = "Windows-1250"))
}


nastobjJanuar <- uvozi.nastobjJanuar()

#prihodi in prenočitve tujih ter domačih turistov po nastanitvenih objektih za avgust 2015
uvozi.nastobjAvgust <- function() {
  return(read.csv2("podatki/VrsteNastanitvenihObjektovAvgust.csv", sep = ";", as.is = TRUE,
                   row.names = 1,
                   skip=4,
                   col.names = c("Objekti","Prihodi_turistov_domači","Prihodi_turistov_tuji","Prenočitve_turistov_domači","Prenočitve_turistov_tuji"),
                   fileEncoding = "Windows-1250"))
}

nastobjAvgust <- uvozi.nastobjAvgust()

#prihodi in prenočitve tujih ter domačih turistov po občinah za avgust 2015
uvozi.obAvgust <- function() {
  return(read.csv2("podatki/obcineAvgust.csv", sep = ";", as.is = TRUE,
                   row.names = 1,
                   skip = 3,
                   col.names = c("Obcine", "Prihodi_domaci", "Prihodi_tuji", "Prenocitve_domaci", "Prenocitve_tuji"),
                   fileEncoding = "Windows-1250"))
}

obAvgust <- uvozi.obAvgust()

#prihodi in prenočitve tujih ter domačih turistov po občinah za avgust 2015
uvozi.obJanuar <- function() {
  return(read.csv2("podatki/obcineJanuar.csv", sep = ";", as.is = TRUE,
                   row.names = 1,
                   skip = 3,
                   col.names = c("Obcine", "Prihodi_domaci", "Prihodi_tuji", "Prenocitve_domaci", "Prenocitve_tuji"),
                   fileEncoding = "Windows-1250"))
}
obJanuar <- uvozi.obJanuar()

#uvoz HTML tabele
link <- "http://www.stat.si/StatWeb/prikazi-novico?id=5678&idp=24&headerbar=21"

stran <- html_session(link) %>% read_html(encoding = "UTF-8")
#tabelo 5 bom rzdelila na dve tabeli
tabele <- stran %>% html_nodes(xpath ="//table[@rules='all']")
tabela3 <- tabele %>% .[[5]] %>% html_table() 
tabela4 <- tabele %>% . [[5]] %>% html_table()
#Turistična dodana vrednost in turistični domači proizvod(BDP),2012,2014
names(tabela3)<- tabela3[1,]
tabela3 = tabela3[-1,]
tabela3 = tabela3[-4,]
tabela3 = tabela3[-7,]
tabela3 = tabela3[-7,]
tabela3 = tabela3[-7,]
tabela3 = tabela3[-7,]
tabela3 = tabela3[-7,]
tabela3 = tabela3[-7,]
tabela3 = tabela3[-7,]

Encoding(tabela3[[1]]) <- "UTF-8"
Encoding(tabela4[[1]]) <- "UTF-8"
#Neposredni in posredni učinki turistične potrošnje 2012,2014
names(tabela4)<- tabela4[1,]
tabela4 = tabela4[-1,]
tabela4 = tabela4[-1,]
tabela4 = tabela4[-1,]
tabela4 = tabela4[-1,]
tabela4 = tabela4[-1,]
tabela4 = tabela4[-1,]
tabela4 = tabela4[-1,]
tabela4 = tabela4[-1,]
tabela4 = tabela4[-1,]
tabela4 = tabela4[-1,]
tabela4 = tabela4[-3,]


tabela3[,2:3] <- apply(tabela3[,2:3], 2, . %>% gsub("\\.", "", .) %>%
                         gsub(",", ".", .) %>%
                         as.numeric())
tabela4[,2:3] <- apply(tabela4[,2:3], 2, . %>% gsub("\\.", "", .) %>%
                         gsub(",", ".", .) %>%
                         as.numeric())

