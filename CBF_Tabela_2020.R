library(stringr)
library(rvest)
library(glue)

# df <- as.data.frame(NULL)

for(i in 2020:2020) {
  
url <- glue("https://www.cbf.com.br/futebol-brasileiro/competicoes/campeonato-brasileiro-serie-b/{i}")


resultados <- url %>% 
  xml2::read_html() %>% 
  html_nodes(".col-lg-9")

linhas <- resultados %>% 
  html_nodes(".expand-trigger")

posicao <- linhas %>% 
  html_nodes("b") %>% 
  html_text()

time <- linhas %>% 
  html_nodes("td .hidden-xs") %>% 
  html_text()

pontos <- linhas %>% 
  html_nodes("th") %>% 
  html_text()

jved <- linhas %>% 
  html_nodes("td") %>% 
  html_text()

gols <- linhas %>% 
  html_nodes(".hidden-md") %>% 
  html_text()

pos <- 13 * (as.numeric(substr(posicao, 1, nchar(posicao)-1)) - 1)

posB <- 6 * (as.numeric(substr(posicao, 1, nchar(posicao)-1)) - 1)

df <-  data.frame(cbind( posicao = substr(posicao, 1, nchar(posicao)-1),
                    time = time,
                    pontos = pontos,
                    J = jved[2 + pos],
                    V = jved[3 + pos],                   
                    E = jved[4 + pos],
                    D = jved[5 + pos],
                    GP = gols[1 + posB],
                    GC = gols[2 + posB],
                    SG = gols[3 + posB],
                    CA = gols[4 + posB],                    
                    CV = gols[5 + posB],
                    aproveitamento = gols[6 + posB]
                  ) ) 
}

write.csv(df, "Serie_B_Tabela.csv", row.names = FALSE, fileEncoding = "UTF-8")




