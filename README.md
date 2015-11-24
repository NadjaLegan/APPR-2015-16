# Analiza turizma v Sloveniji

Avtor: Nadja Legan

Repozitorij z gradivi pri predmetu APPR v študijskem letu 2015/16.

## Tematika

Analizirala bom turizem v Sloveniji. Podatke sem našla na spletnih straneh Statističnega urada RS in Slovenski turizem v številkah. Analizirala bom prihod in prenočitev domačih in tujih turistov, rast prihoda in prenočitev, pomen turizma v Sloveniji, prihodi turistov po regijah in občinah, tuja prenočitva po občinah, nastanitvene kapacitete in število prenočitev po nastanitvenih obratih ter zasedenost hotelov in kampov.

Podatki:
  - http://www.slovenia.info/si/Slovenski-turizem-v-%C5%A1tevilkah.htm?ps_najpomembnejsi-kazalniki=0&lng=1
  - http://www.stat.si/StatWeb/prikazi-novico?id=5571&idp=24&headerbar=21

Cilj je analizirati prihode evropskih in čezmorskih turistov, v kakšne vrste hotelov se nastanijo ter v katerem delu Slovenije se le ti nahajajo.

## Program

Glavni program in poročilo se nahajata v datoteki `projekt.Rmd`. Ko ga prevedemo,
se izvedejo programi, ki ustrezajo drugi, tretji in četrti fazi projekta:

* obdelava, uvoz in čiščenje podatkov: `uvoz/uvoz.r`
* analiza in vizualizacija podatkov: `vizualizacija/vizualizacija.r`
* napredna analiza podatkov: `analiza/analiza.r`

Vnaprej pripravljene funkcije se nahajajo v datotekah v mapi `lib/`. Podatkovni
viri so v mapi `podatki/`. Zemljevidi v obliki SHP, ki jih program pobere, se
shranijo v mapo `../zemljevidi/` (torej izven mape projekta).

## Spletni vmesnik

Spletni vmesnik se nahaja v datotekah v mapi `shiny/`. Poženemo ga tako, da v
RStudiu odpremo datoteko `server.R` ali `ui.R` ter kliknemo na gumb *Run App*.
Alternativno ga lahko poženemo tudi tako, da poženemo program `shiny.r`.

## Potrebni paketi za R

Za zagon tega vzorca je potrebno namestiti sledeče pakete za R:

* `knitr` - za izdelovanje poročila
* `rmarkdown` - za prevajanje poročila v obliki RMarkdown
* `shiny` - za prikaz spletnega vmesnika
* `DT` - za prikaz interaktivne tabele
* `maptools` - za uvoz zemljevidov
* `sp` - za delo z zemljevidi
* `digest` - za zgoščevalne funkcije (uporabljajo se za shranjevanje zemljevidov)
* `httr` - za pobiranje spletnih strani
* `XML` - za branje spletnih strani
* `extrafont` - za pravilen prikaz šumnikov (neobvezno)
