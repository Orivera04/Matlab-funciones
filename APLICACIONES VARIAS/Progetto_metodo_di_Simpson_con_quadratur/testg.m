%           Progetto Metodo di Simpson
%           a schema adattivo globale
%
%             Programma elaborato da
%
%      Giovanni DI CECCA & Virginia BELLINO
%           50 / 887           408 / 466
%
%             http://www.dicecca.net
%
%
% Funzione di Test

disp('           Progetto Metodo di Simpson')
disp('           a schema adattivo globale')
disp(' ')
disp('             Programma elaborato da')
disp(' ')
disp('      Giovanni DI CECCA & Virginia BELLINO')
disp('            50 / 887         408 / 466')
disp(' ')
disp('             http://www.dicecca.net')
disp(' ')
disp(' ')
% Inizializza memoria e video
clc;
clear;


disp('Primo TEST')

% Considera il formato a doppia precisione a video
format long;

% Funzione
fun='(100./(x.^7)).*sin(10./(x.^7))'

% Estremi
a=1

b=3

% Numero massimo di funzioni
nfmax=1000

tolleranza=10^-3

disp('soluzioni della simglobal')

[AI,Errore,iflag,nval]=simglobal(a,b,fun,tolleranza,nfmax)

disp('Premi un tasto per continuare')
pause

%---------------------------------------------------------

% Inizializza memoria e video e figura
clc;
clear;
clf;

disp('Secondo TEST')

% Considera il formato a doppia precisione a video
format long;

% Funzione
fun='(100./(x.^7)).*sin(10./(x.^7))'

% Estremi
a=1

b=3

% Numero massimo di funzioni
nfmax=1000

tolleranza=10^-6

disp('soluzioni della simglobal')

[AI,Errore,iflag,nval]=simglobal(a,b,fun,tolleranza,nfmax)

disp('Premi un tasto per continuare')
pause

%-----------------------------------------------------------

% Inizializza memoria e video e figura
clc;
clear;
clf;

disp('Terzo TEST')

% Considera il formato a doppia precisione a video
format long;

% Funzione
fun='(1./((x.^2)+1./(2.^16)))' 

% Estremi
a=-1

b=1

% Numero massimo di funzioni
nfmax=1000

tolleranza=10^-1

disp('soluzioni della simglobal')

[AI,Errore,iflag,nval]=simglobal(a,b,fun,tolleranza,nfmax)

disp('Premi un tasto per continuare')
pause

%-----------------------------------------------------------

% Inizializza memoria e video e figura
clc;
clear;
clf;

disp('Quarto TEST')

% Considera il formato a doppia precisione a video
format long;

% Funzione
fun='(1./((x.^2)+1./(2.^16)))'

% Estremi
a=-1

b=1

% Numero massimo di funzioni
nfmax=1000

tolleranza=10^-1

disp('soluzioni della simglobal')

[AI,Errore,iflag,nval]=simglobal(a,b,fun,tolleranza,nfmax)

disp('Premi un tasto per continuare')
pause

%-----------------------------------------------------------

% Inizializza memoria e video e figura
clc;
clear;
clf;

disp('Quinto TEST')

% Considera il formato a doppia precisione a video
format long;

% Funzione
fun='sin(x)+cos(x)'

% Estremi
a=-pi/2

b=pi/2

% Numero massimo di funzioni
nfmax=1000

tolleranza=10^-3

disp('soluzioni della simglobal')

[AI,Errore,iflag,nval]=simglobal(a,b,fun,tolleranza,nfmax)

disp('Premi un tasto per continuare')
pause

%-----------------------------------------------------------

% Inizializza memoria e video e figura
clc;
clear;
clf;

disp('Sesto TEST')

% Considera il formato a doppia precisione a video
format long;

% Funzione
fun='sin(x)+cos(x)'

% Estremi
a=-pi/2

b=pi/2

% Numero massimo di funzioni
nfmax=1000

tolleranza=10^-6

disp('soluzioni della simglobal')

[AI,Errore,iflag,nval]=simglobal(a,b,fun,tolleranza,nfmax)

disp('Fine del test')