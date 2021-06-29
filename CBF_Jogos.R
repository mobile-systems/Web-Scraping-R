#install.packages("stringr", repos='http://cran.us.r-project.org')
#install.packages("rvest", repos='http://cran.us.r-project.org')
#install.packages("RCurl", repos='http://cran.us.r-project.org')
library(stringr)
library(rvest)
library(glue)
library(RCurl)

web_url =  "https://www.cbf.com.br/futebol-brasileiro/competicoes/campeonato-brasileiro-serie-{serie}/{a}"  

myFunction<-function(serie, anoIni, anoFim) {
  
  for(a in anoIni:anoFim) {

    url <- glue(web_url)

    print(paste('Web scraping', url))

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

    df <- if( a == 2014) { 
      data.frame(cbind(rodada = rodada,
        casa = casa,
        placar = placar,
        fora = fora,
        ano = rep(a,length(rodada) ) ) ) 
    }
    else {
      data.frame(cbind(rodada = rodada,
        casa = casa,
        placar = placar,
        fora = fora,
        ano = rep(a,length(rodada) ) ) )
    }
  }

  arquivo <- glue("Serie_{serie}.csv")

  write.csv(df, arquivo, row.names = FALSE)
  # write.csv(df, paste0(sub('\\..*', '', arquivo), format(Sys.time(),'_%Y%m%d_%H%M%S'), '.csv'), row.names = FALSE)

  print(paste(arquivo, "criado!"))

  ftp <- Sys.getenv("futbr-webapi-host")
  usr <- Sys.getenv("futbr-webapi-user")
  pwd <- Sys.getenv("futbr-webapi-password")

  dir <- glue("site/wwwroot/db/{arquivo}")

  ftpUpload(what = arquivo,
        to = glue(ftp),
        verbose = FALSE,
        userpwd = glue("{usr}:{pwd}"))

  print(paste(arquivo, "subido no FTP!"))
}

myFunction('a', 2021, 2021)
myFunction('b', 2021, 2021)