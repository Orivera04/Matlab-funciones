%           Progetto Metodo di Simpson
%                 a schema fisso
%
%             Programma elaborato da
%
%      Giovanni DI CECCA & Virginia BELLINO
%           50 / 887           408 / 466
%
%             http://www.dicecca.net
%
%
% Chiamata della funzione
%
% [AI,Errore,iflag,nval]=simfix(a,b,f,tolleranza,nfmax)
%
%
% Informazioni sul programma
%
% Scopo: Calcola l'integrale definito di f(x) utilizzando la formula 
%        di Simpson a schema fisso. La funzione prosegue nel processo 
%        iterativo fino a quando:
%        1) Il margine di errore raggiunge la tolleranza richiesta;
%        2) Si sono effettuate nfmax valutazioni;
% 
% Parametri:
% 
% Input:  a = Estremo sinistro dell'intervallo di integrazione
%         b = Estremo destro dell'intervallo di integrazione
%         f = Funzione integranda scritta nel seguente modo:
%
%         f='(100./(x.^7)).*sin(10./(x.^7))'
%
%         tolleranza = Tolleranza richiesta
%         nfmax = Massimo numero consentito di valutazioni della funzione
%
% Output: AI = Approssimazione dell'integrale
%         Errore = Stima dell'errore
%         iflag = Indicatore di errore: 
%                 0 Se la condizione di uscita si è verificata per il 
%                   raggiungimento della tolleranza richiesta;
%                 1 Se la condizione di uscita si è verificata per il 
%                   raggiungimento del numero massimo di valutazioni;
%
%         nval = Numero di valutazioni della funzione effettuato
        
function [AI,Errore,iflag,nval]=simfix(a,b,f,tolleranza,nfmax)

% Inizializzazione delle variabili

Iprecedente=0; % Stima dell'integrale al passo precedente

AI=0; % Inizializzazione dell'approssimazione dell'integrale

% Inializzazione delle variabili usate per la valutazione 
% della funzione negli estremi

fa=0; 
fb=0;

% Valutazione della funzione negli estremi a et b
fa=Fun(f,a);
fb=Fun(f,b);

Errore=tolleranza;

% Numero di valutazioni della funzione effettuate per calcolare la
% prima approssimazione dell'integrale
nval=3; 

iflag=0; % Inizializza l'indicatore di errore (tipo logical)

sommaprecedente=0; % Somma delle valutazioni di funzione all'iterazione k
sommacorrente=0; % Somma delle valutazioni di funzione all'iterazione k+1

h=(b-a)/2;

% Somma delle valutazioni di funzione al passo k+1
% Inizialmente, tale somma contiene il valore della funzione valutata nel punto medio 
% dell'intervallo di integrazione (a,b) 
sommacorrente=Fun(f,a+h); 

% Calcolo di Simpson semplice su tre punti
AI=(h/3)*(fa + 4*sommacorrente + fb);


k=1; % Inizializza il contatore k


% Inizio procedimento di Simpson a schema fisso
% Il calcolo viene effettuato con un ciclo while.

while (Errore>=tolleranza) & (nval<=nfmax) 

  k=k+1; % Passa alla iterazione successiva

  Iprecedente=AI; % Memorizza il valore dell'ultima iterazione

  % Calcola l'ampiezza degli intervalli 
  h=(b-a)/(2^k);

  % Calcola il numero dei nodi in cui andare a valutare la funzione
  m=2^(k-1);
  
 % Aggiornamento della somma delle valutazioni di funzione al passo k
  sommaprecedente = sommaprecedente + sommacorrente;
  
  % Aggiornamento della somma delle valutazioni di funzione al passo k+1
  % con l'aiuto della funzione ausiliaria Fun
  sommacorrente=0;
  
  for i=1:1:m   
    sommacorrente = sommacorrente + Fun(f,a+((2*i)-1)*h);
  end   

  % Calcolo dell'integrale definito con la formula di Simpson composta 
  AI=(h/3)*(fa + 2*sommaprecedente + 4*sommacorrente + fb);
  
  % Calcola l'errore o resto utilizzando la stima di Richardson 
  Errore=abs(AI-Iprecedente)/15;
  
  % Aggiornamento del numero di valutazioni effettuate 
  nval=nval+m;
end   

% Controllo sulla possibilità di terminazione del ciclo per il raggiungimento 
% di una delle due condizioni previste, e cioè:
% a- il numero di valutazioni della funzione effettuate supera il massimo consentito
% b- l'errore raggiunge la tolleranza richiesta
iflag=(nval>=nfmax & Errore>=tolleranza);


% Plot della funzione 

hold on; % Consenti la possibilità di sovrascrivere il grafico

zoom on; % Abilita la funzione di zoom

% Inserisci i valori degli intervallini nel plot a video
x=linspace(a,b,abs(a-b)/0.01);

eval(sprintf('y_arr=%s;',f)); 

plot(x,y_arr,'b');

plot(x,-0.5,'rx');

hold off; % Disabilita Hold on


