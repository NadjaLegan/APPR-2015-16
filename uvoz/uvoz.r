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

