function y=ctmclrc(R,c);
%y=ctmclrc(R,c)
%R = rate matrix of an irreducible CTMC.
%c(i) = expected cost of visiting state i. (column vector).
%output y = long run cost rate per unit time.
y=checkR(R);
if y(1,1) ~= 'error'
   y=checkcR(c,R);
   if y(1,1) ~= 'error'
      y=ctmcod(R);
      if y(1,1) ~= 'error'
         y=ctmcod(R)*c;
      end;
   end;
end;
