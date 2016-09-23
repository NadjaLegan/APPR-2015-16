library(knitr)
require(ggplot2)
require(dplyr)
require(rvest)
require(gsubfn)
require(zoo)
library(scales)
library(mgcv)


# Uvozimo funkcije za delo z datotekami XML.
source("lib/xml.r", encoding = "UTF-8")

# Uvozimo funkcije za pobiranje in uvoz zemljevida.
source("lib/uvozi.zemljevid.r", encoding = "UTF-8")
