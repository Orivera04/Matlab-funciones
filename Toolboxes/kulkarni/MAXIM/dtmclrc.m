function y=dtmclrc(P,c);
%y=dtmclrc(P,c)
%P = transition probability matrix of an irreducible DTMC.
%c(i) = expected cost of visiting state i. (column vector).
%output y = long run cost rate.
y=checkcP(c,P);
if y(1,1) ~= 'error'
   y=checkP(P);
   if y(1,1) ~= 'error'
      y=dtmcod(P)*c;
      end;
end;