library(stringr)
library(rvest)
library(glue)

# df <- as.data.frame(NULL)

for(i in 1:11) {
  
  url <- glue("https://playcontestofchampions.com/category/whats-new/new-characters/page/{i}/")

  resultados <- url %>% 
    xml2::read_html() %>% 
      html_nodes(".o-blog__item--articles")

  name <- resultados %>% 
    html_nodes(".t-article-title") %>% 
      html_text()

  link <- resultados %>% 
    html_nodes(".t-link a") %>% 
      html_attr('href')

  df <- if( i == 1)
  { 
    df <- data.frame(cbind(name = substring(name, 22),
      link = link ) )
  }
  else
  {
    df <- data.frame(rbind(df, cbind(name = substring(name, 22),
      link = link ) ) )
  }
}

write.csv(df, "mcoc.csv",  row.names = FALSE)




