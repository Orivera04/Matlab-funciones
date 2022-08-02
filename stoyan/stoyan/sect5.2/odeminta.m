function [out1,out2,out3] = odefile(t,y,flag,p1,p2,...)
% Mintaprogram az odefile hivasanak szemleltetesere.
%
% © Molnarka Gy''oz''o 1998; program a Differencialegyenletek 
                           % numerikus megoldasa reszhez
%
   if nargin < 3 | isempty(flag)  % mivel a kapcsolonak nincs erteke 
                                  % Return dy/dt = F(t,y).
     out1 = < ide az F(t,y,p1,p2,...) fuggvenyt kiszamito 
              program kerul >   
   else
     switch(flag)
     case 'init'                 
           % A [tspan,y0,options] alapertelmezesi ertekeit 
           % adjuk vissza a kimeneten.
       out1 = < ide kerul tspan erteke >;
       out2 = < ide kerul y0 erteke >;
       out3 = < ide az options = odeset(...) 
                utasitas vagy a [] kerul>;
     case 'jacobian'        
           % A  J(t,y) = dF/dy matrix megadasa.
       out1 = < ide kerul a J(t,y) = dF/dy Jacobi-matrix >;
     case 'jpattern'      
           % A Jacobi-matrixot ritka matrixkent adjuk meg.
       out1 = < ide kerul a Jacobi-matrix mint ritka matrix >;
     case 'mass'  
           % Az M(t) vagy az M tomeg matrixot adjuk meg.
       out1 = < ide kerul az M(t) vagy az M tomegmatrix >;
     case 'events'
           % Az 'esemeny'-rol szolo informaciokat
           % adjuk meg.
       out1 = < ide kerul az esemeny vektor >
       out2 = < ide kerul a logikai isterminal vektor >;
       out3 = < ide kerul a direction vektor >;
     otherwise
   error(['Ismeretlen flag ''' flag '''.']);
     end
   end