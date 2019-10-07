###############################
#                             #
# Web Scraping                #
# Estatística Computacional 2 #
#                             #
###############################

########### Bibliotecas #############

library(rvest) # Raspar dados da internet
library(tidyverse)
library(plyr)


################ Primeiro exemplo
################ Pegando informações de filmes

# Especificando a url

Link  = "https://www.imdb.com/chart/top?ref_=nv_mv_250"

# Pegue as informações

Info_Paginas = read_html(Link)

Info_Paginas %>% html_nodes(".titleColumn") %>% html_text()

Info_Paginas %>% html_nodes("td a") %>% html_text()

Info_Paginas %>% html_nodes("td strong") %>% html_text()

dado = Info_Paginas %>% html_table() %>% .[[1]]

# Pegando links da página

Info_Paginas %>% html_nodes("td.titleColumn a") %>% html_attr("href")

################ Segundo Exemplo
################ Pegando o contracheque do portal transparência

# Especifique a url que será usada

Link = "https://www.mpgo.mp.br/transparencia/contracheque/detalhamento_folha?commit=Filtrar&contracheque_tb_detalhamento_folha%5Bano%5D=2019&contracheque_tb_detalhamento_folha%5Bcdg_ordem%5D=&contracheque_tb_detalhamento_folha%5Bmes%5D=8&contracheque_tb_detalhamento_folha%5Bnm_pessoa%5D=&contracheque_tb_detalhamento_folha%5Btipo%5D=r_servidor_ativo&page=2&utf8=%E2%9C%93"

# Pegue as informações

Info_Paginas = read_html(Link)

Tabela = Info_Paginas %>% html_table(fill = T) %>% .[[1]]
View(Tabela)

# Pegando todas as páginas de informação

Paginas = Info_Paginas %>% 
  html_nodes(".bootstrap_pagination") %>% 
  html_text() %>% 
  str_split(" ") %>% 
  unlist() %>% 
  as.numeric() %>% 
  max(na.rm = T) 

# Verificando o padrão do link com paginação
#https://www.mpgo.mp.br/transparencia/contracheque/detalhamento_folha?commit=Filtrar&contracheque_tb_detalhamento_folha%5Bano%5D=2019&contracheque_tb_detalhamento_folha%5Bcdg_ordem%5D=&contracheque_tb_detalhamento_folha%5Bmes%5D=8&contracheque_tb_detalhamento_folha%5Bnm_pessoa%5D=&contracheque_tb_detalhamento_folha%5Btipo%5D=r_servidor_ativo&page=2&utf8=%E2%9C%93

Remuneracao = adply(data.frame(i = 1:Paginas),1, function(x){
  novolink = paste0("https://www.mpgo.mp.br/transparencia/contracheque/detalhamento_folha?commit=Filtrar&contracheque_tb_detalhamento_folha%5Bano%5D=2019&contracheque_tb_detalhamento_folha%5Bcdg_ordem%5D=&contracheque_tb_detalhamento_folha%5Bmes%5D=8&contracheque_tb_detalhamento_folha%5Bnm_pessoa%5D=&contracheque_tb_detalhamento_folha%5Btipo%5D=r_servidor_ativo&page=",x,"&utf8=%E2%9C%93")
  Info_Pagina = read_html(Link)
  
  a = Info_Pagina %>% html_table(fill = T) %>% .[[1]]
  names(a) = a[2,]
  a[-(1:2),]
})

