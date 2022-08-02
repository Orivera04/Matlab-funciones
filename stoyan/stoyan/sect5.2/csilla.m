function [out1,out2,out3] = csilla(t,y,flag,k,c,m)
%   CSILLA a csillapitott rezgomozgas  
%   differencialegyenletenek megoldasara szolgalo
%   fuggveny olyan modon megirva, hogy a megoldas 
%   komponenseinek zero ertek felvetelet detektalhassuk 
%   a MATLAB differencialegyenlet megoldoinak hasznalataval.
%
% © Molnarka Gy''oz''o 1998; program a Differencialegyenletek 
                           % numerikus megoldasa reszhez
%
%   CSILLA(t,y,flag,k,c,m)
%   parameterek  
%   k - a rugoallando
%   c - a csillapitasi tenyezo
%   m  - a tomeg

if nargin < 3 | isempty(flag) 
  % Return dy/dt = f(t,y).
 out1 = [y(2)
     (-k/m*y(1)-c/m*sign(y(2))*y(2)^2)];
else
switch(flag)
 case 'events'             
    % Akkor kerul ide a vezerles, ha 
    % az odeset('Events','on') opcio van megadva.
    % Ekkor a visszateresi ertekek a kiszamitott 
    % fuggvenyertekek, a megallasi feltetelek, 
    % es ha tovabb folytatjuk a szamitast,
    % az uj kezdeti feltetelek szamitasahoz 
    % szukseges informaciok. 
    % Programunkban a zerus ertek felvetelet az 
    % y megoldasvektor komponenseire vagy azok valamilyen 
    % fuggvenyere vizsgalhatjuk
    out1 = [y(1)-1;y(2)];              
    out2 = [1; 0];          
      %  a zero ertek felvetelet az out1 elso
      %  komponensre  vizsgaljuk, out2=[0,1] a masodik komponensre 
      %  valo vizsgalatot jelentene, mig [1,1] mindket 
      %  komponens vizsgalatat. 
    out3 = [-1; 0];         
      %  akkor kapunk effektust ha y(1) csokkeno,  
      %  az y(2) komponens erteketol fuggetlenul. 
      %  Tovabbi lehetosegek: [1,0],[1,1],[0,1],
      %  [0,-1],[-1,1],[1,-1],[-1,-1] ertelemszeruen.
  otherwise
    error(['Ismeretlen flag ''' flag '''.']);
  end
end