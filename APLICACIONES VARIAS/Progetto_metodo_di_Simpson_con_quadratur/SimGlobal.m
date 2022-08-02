%           Progetto Metodo di Simpson
%                 a schema globale
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
% [AI,Errore,iflag,nval]=simglobal(a,b,fun,tolleranza,nfmax)
%
%
% Informazioni sul programma
%
%
% Scopo: Calcola l'integrale definito di f(x) utilizzando la formula 
%        di Simpson a schema adattivo con controllo globale dell'errore. 
%        La funzione prosegue nel processo iterativo fino a quando:
%        
%        1) Il margine di errore raggiunge la tolleranza richiesta;
%        2) Si sono effettuate nfmax valutazioni;
%
% Parametri:
%
% Input : a = Estremo sinistro dell'intervallo di integrazione
%         b = Estremo destro dell'intervallo di integrazione
%         fun = Funzione integranda scritta nel seguente modo:
%
%         fun='(100./(x.^7)).*sin(10./(x.^7))'
%
%         tolleranza = Tolleranza richiesta
%         nfmax = Massimo numero consentito di valutazioni della funzione
%
% Output: AI = Stima dell'integrale
%         Errore = Stima dell'errore
%         iflag = Indicatore di errore: 
%                 0 Se la condizione di uscita si è verificata per il 
%                   raggiungimento della tolleranza richiesta;
%                 1 Se la condizione di uscita si è verificata per il 
%                   raggiungimento del numero massimo di valutazioni;
%
%         nval = Numero di valutazioni di funzione effettuato

        
function [AI,Errore,iflag,nval]=simglobal(a,b,fun,tolleranza,nfmax)

%Inizializzo le variabili
nval=1; 

% Chiama la funzione simfix per eseguire la prima stima
% dell'integrale (P.S.: z et g non vengono considerati)
[Iprecedente,Errore,z,g]=simfix(a,b,fun,0,3);

% Crea una lista in cui vengono inseriti i dati relativi agli intervalli
list(nval)=struct('xl',a,'xh',b,'approx',Iprecedente,'est',Errore);

AI=Iprecedente;

% Inizio procedimento Simpson adattivo
while (Errore>=tolleranza & nval<=nfmax)
    
   % Rileva nella lista l'intervallo con il massimo 
   % errore mediante una funzione apposita
   [E,Iprecedente,xa,xb,k]=MaxList(list,nval);
   
   % Suddivide l'intervallo selezionato in due sottointervalli
   h=(xb-xa)/2; 
   
   % Calcola il punto medio
   xmid=xa+h; 
   
   % Rimuove dalla lista la vecchia approssimazione
   % relativa all'intervallo selezionato
   list(k)=[];
   
   % Calcola la nuova approssimazione sul sottointervallo di sinistra
   % ed aggiorna la lista
   [I1,E1,z,g]=simfix(xa,xmid,fun,0,3);
   list(nval)=struct('xl',xa,'xh',xmid,'approx',I1,'est',E1);
   
   % Calcola la nuova approssimazione sul sottointervallo di destra
   % ed aggiorna la lista
   nval=nval+1; 
   [I2,E2,z,g]=simfix(xmid,xb,fun,0,3);
   list(nval)=struct('xl',xmid,'xh',xb,'approx',I2,'est',E2);
   
   % Ricava la nuova stima dell'integrale e dell'errore.
   AI=AI-Iprecedente+I1+I2;
   Errore=Errore-E+E1+E2;
end

% Controllo sulla possibilità di terminazione del ciclo per il raggiungimento 
% di una delle due condizioni previste, e cioè:
% a- il numero di valutazioni della funzione effettuate supera il massimo consentito
% b- l'errore raggiunge la tolleranza richiesta
iflag=(nval>=nfmax & Errore>=tolleranza);

% Disegna la funzione f(x)
x=linspace(a,b,500);
eval(sprintf('y_arr=%s;',fun));
plot(x,y_arr);

zoom on
hold on

% Calcola i valori dei nodi
arr_nodi=[];
for (i=1:nval)
  x=linspace(getfield(list(i),'xl'),getfield(list(i),'xh'),10);
  arr_nodi = [arr_nodi x];
end

% Disegna i nodi
plot(arr_nodi,0,'rx');

hold off


