clc; clear; close;

printf(">>>>>>>>>>>>>>>>>>>> ADALINE <<<<<<<<<<<<<<<<<<<<\n");

function w = treino(dadosTreino)
  n = 10^-3;
  precisao = 10^-2;
  erroQM = 0;
  erroQM_anterior = 0;
  erroQM_atual = 0;
  epocas = 0;
  w = rand(2,1);
  
  %laco para percorrer epocas
  do 
    %embaralhando grupo do treino
    dadosTreino = dadosTreino(randperm(size(dadosTreino)(1)),:);     
    entradasDoTreino = dadosTreino(:,1:size(dadosTreino)(2)-1); %separando X    
    rotulosDoTreino = dadosTreino(:,size(dadosTreino)(2));    %separando D    
       
    erroQM_anterior = erroQM_atual;
        
    %laco para percorrer todos os padroes
    for i = 1:size(entradasDoTreino)(1)
      x = entradasDoTreino(i,:)';      
      x = [-1;x]; %inclusao do Bias
      d = rotulosDoTreino(i,:);      
      u = w'*x;          
      w = w + n * (d - u) * x;             
      erroQM = erroQM + (d - u)^2;
    end
  epocas++; 
  erroQM = erroQM / size(entradasDoTreino)(1);  
  erroQM_atual = erroQM;
  until (abs(erroQM_atual - erroQM_anterior)) <= precisao
end

function percentAcertos = teste(w,dadosTeste)
  precisao = 10^-2;
  somaErros = 0;   
  
  %nao embaralhando grupo do teste, para embaralhar descomente abaixo  
  %dadosTeste = dadosTeste(randperm(size(dadosTeste)(1)),:);     
  entradasDoTeste = dadosTeste(:,1:size(dadosTeste)(2)-1); %separando X    
  rotulosDoTeste = dadosTeste(:,size(dadosTeste)(2));    %separando D    

  for i = 1:size(entradasDoTeste)(1)    
    x = entradasDoTeste(i,:)';    
    x = [-1;x]; %inclusao do Bias    
    d = rotulosDoTeste(i,:);      
    u = w'*x;    
      if ((d - u)^2 > precisao)      
          somaErros= somaErros + (d - u)^2;
      end       
  end  
  percentErros = somaErros / size(entradasDoTeste)(1);
  percentAcertos = 100 - percentErros;     
end

%lendo arquivo com dados e separando grupo treino e teste
dados = load("CodigoAdalineDados.txt");
dados = dados(randperm(size(dados)(1)),:); 
dadosTreino = dados(1:((size(dados)(1))* 0.8),:); % 80%
dadosTeste = dados(size(dados)(1)*0.8 + 1 : size(dados)(1),:);  % 20%  

nTestes = 10;
resultado = 0;
vetorResultados (nTestes) = 0;

for i = 1:nTestes  
  w = treino(dadosTreino);  
  vetorResultados (i) = teste(w,dadosTeste);
  resultado = resultado + vetorResultados (i);  
end;

media = resultado / nTestes;
variancia = 0;

for i = 1:nTestes
  variancia = ((variancia + (vetorResultados(i) - media)^2))/ nTestes;
end

desvioPadrao = sqrt(variancia);

printf("Media >>>>>>>>>: %.9f\n",media);
printf("Variancia >>>>>: %.10f\n",variancia);
printf("Desvio Padrao >: %.10f\n",desvioPadrao);
printf("%d Testes realizados!\n",nTestes);

%retirando da memoria variaveis nao mais utilizadas  
clear i, clear dados, clear dadosTreino, clear dadosTeste; 
clear nTestes, clear resultado, clear vetorResultados;