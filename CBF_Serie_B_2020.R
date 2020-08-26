# install.packages("stringr", repos='http://cran.us.r-project.org')
# install.packages("rvest", repos='http://cran.us.r-project.org')
library(stringr)
library(rvest)
library(glue)

web_url =  "https://www.cbf.com.br/futebol-brasileiro/competicoes/campeonato-brasileiro-serie-b/{i}"  

print(paste('Web scraping', web_url))

for(i in 2020:2020) {

  url <- glue(web_url)

  resultados <- url %>% 
    xml2::read_html() %>% 
    html_nodes(".aside-rodadas")

  casa <- resultados %>% 
    html_nodes(".pull-left .time-sigla") %>% 
    html_text()

  fora <- resultados %>% 
    html_nodes(".pull-right .time-sigla") %>% 
    html_text()

  placar <-  resultados %>% 
    html_nodes(".partida-horario") %>%
    html_text() %>%
      str_extract("[0-9]{1}\ x\ [0-9]{1}")
      
  rodada <- 0:(length(placar)-1) %/% 10 + 1

  df <- if( i == 2014) { 
    data.frame(cbind(rodada = rodada,
      casa = casa,
      placar = placar,
      fora = fora,
      ano = rep(i,length(rodada) ) ) ) 
  }
  else {
    data.frame(cbind(rodada = rodada,
      casa = casa,
      placar = placar,
      fora = fora,
      ano = rep(i,length(rodada) ) ) )
  }
}

arquivo = "Serie_B_2020.csv"

# write.csv(df, "Serie_B_2020.csv", col.names = TRUE, row.names = FALSE, sep = ",")
write.csv(df, paste0(sub('\\..*', '', arquivo), format(Sys.time(),'_%Y%m%d_%H%M%S'), '.csv'), row.names = FALSE)

print(paste(arquivo, "criado!"))
