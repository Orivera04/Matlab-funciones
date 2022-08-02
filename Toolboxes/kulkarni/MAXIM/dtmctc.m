function y=dtmctc(P,c,n);
%y=dtmctc(P,c,n)
%P = transition matrix of a DTMC.
%c(i) = expected cost of visiting state i. (column vector).
%output y(i) =total expected cost over time 0 thru n, starting from i.
if n < 0 | n - fix(n) ~= 0
   msgbox('invalid entry for n'); y = 'error'; return;
else
y=checkcP(c,P);
if y(1,1) ~= 'error'
   y=dtmcot(P,n);
   if y(1,1) ~= 'error'
      y=y*c;
      end;
end;
end;