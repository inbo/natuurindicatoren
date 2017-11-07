
#Test om data vanop de checklist te verkrijgen

library(rgbif)
library(curl)

dataset_metrics <- function(uuid, curlopts = list()) {
  getdata <- function(x){
    url <- sprintf('%s/dataset/%s/metrics', gbif_base(), x)
    gbif_GET(url, NULL, FALSE, curlopts,
             "(only checklist datasets have metrics)")
  }
  if (length(uuid) == 1) {
    getdata(uuid)
  } else {
    lapply(uuid, getdata)
  }
}
