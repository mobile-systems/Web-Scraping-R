library(rvest)


url <- 'https://baucenter.ru/gipsokarton/?count=36&PAGEN_1=2'

# scrape HTML from website
x <- read_html(url)

#id <- toupper(webpage %>% html_nodes(".allregions") %>% html_attr("data-code"))
#data-currency="RUB"
#data-name="Гипсокартон КНАУФ 1500х600х12,5 мм мини"
#data-id="355688"
#data-article="506000019"
#data-price="160.00"
#data-brand="КНАУФ"
#data-category="Гипсокартон и ГВЛ"
#data-position="2"

itemName <- toupper(x %>% html_nodes(".catalog_item") %>% html_attr("data-name"))
itemId <- toupper(x %>% html_nodes(".catalog_item") %>% html_attr("data-id"))
itemArticle <- toupper(x %>% html_nodes(".catalog_item") %>% html_attr("data-article"))
itemPrice <- toupper(x %>% html_nodes(".catalog_item") %>% html_attr("data-price"))
itemBrand <- toupper(x %>% html_nodes(".catalog_item") %>% html_attr("data-brand"))
itemCategory <- toupper(x %>% html_nodes(".catalog_item") %>% html_attr("data-category"))
itemPosition <- toupper(x %>% html_nodes(".catalog_item") %>% html_attr("data-position"))

tbl <- data.frame(itemId, itemName, itemArticle, itemPrice, itemBrand, itemCategory, itemPosition)

#write.csv(tbl,"20211122.csv", row.names = FALSE)
fileName = "baucenter_gipsokarton.csv"

write.csv(tbl, paste0(sub('\\..*', '', fileName), format(Sys.time(),'_%Y%m%d_%H%M%S'), '.csv'),  row.names = FALSE, fileEncoding = "UTF-8")

