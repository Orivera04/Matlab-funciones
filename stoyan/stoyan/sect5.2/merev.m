function [out1,out2,out3] = merev(t,y,flag)
% Ebben a fuggvenyben egy olyan merev egyenletrendszer 
% talalhato, melynek analitikus megoldasat is ismerjuk.
% A megoldas: y(1) = exp(-5t), y(2) = exp(-t)
%
% © Molnarka Gy''oz''o 1998; program a Differencialegyenletek 
                           % numerikus megoldasa reszhez
%
% Lasd:  L. F. Shampine, Measuring stiffness, 
% Appl.\ Numer. Math. 1 (1985), pp. 107-119.
%   
if nargin < 3 | isempty(flag)   
   % Ha a fuggvenyt csak ket parameterrel hivjuk meg, 
   % egyszeruen a dy/dt = f(t,y) ertekek kerulnek az out1 
   % valtozoba.
    out1 = [ (-10005*y(1,:) + 10000*y(2,:).^5)  
           (y(1,:) - y(2,:) - y(2,:).^5) ];
% Itt a ('Vectorized', 'on') opcionak megfelelo alakban van 
% megadva a jobboldal. 
else
  switch(flag)
  case 'init'  % Akkor hasznaljuk, ha integralasi intervallumot
               % es kezdeti ertekeket nem adunk meg
               % Visszateresi ertekek a default tspan, y0, es
               % a ('Vectorized','on') opcio.
    out1 = [0; 5];              % Default integralasi intervallum.
    out2 = ones(2,1);           % A kezdeti feltetelek
    out3 = odeset('Vectorized','on');  
                                % a beallitani kivant opcio
 case 'jacobian'  % Akkor kerul ide a vezerles, ha az 
                  % odeset('Jacobian','on') opcio be van allitva.
        out1 = [ -10005     50000*y(2)^4
             1          (-1 - 5*y(2)^4) ];
 % A jobboldal dF/dy Jacobi-matrixa analitikusan kiszamolva.  
  otherwise
     error(['Ismeretlen flag ''' flag '''.']);
     % Vedelem az ellen, hogy ha veletlenul az 'init' vagy 
     % a 'jacobian' kapcsolokon kivul mas kapcsolo
     % ertekkel is hivnank fuggvenyunket. 
  end
end