function c = ex5invcost(s,S,y,hc,ps, oc);
%c = ex5invcost(s,S,y,hc,ps, oc)
%s = basestock level;
%S = restocking level;
%y = row vector of the demand pmf;
%hc = cost of holding one item for one time unit;
%ps = profit per sale;
%oc = ordering cost;
%Output c(i) = expected cost in one time unit if there
%are i units on hand at the beginning of the day
[my ny]=size(y)
if  (s <0)|(s - fix(s) ~= 0)
msgbox('invalid entry for s');P = 'error'; return;
elseif (S <s) | S - fix(S) ~= 0 
msgbox('invalid entry for S');P = 'error';return; 
elseif  any(y < 0) | sum(y) > 1
msgbox('invalid entry for y');P = 'error';return;  
elseif my > 1
   msgbox('y must be a row vector'); P= 'error'; return;
else
   for i=s:S
      c(i-s+1) = hc*i;
      sale=0;
      for j=0:ny-1
         sale=sale + min(i,j)*y(j+1);
      end;
      c(i-s+1)=c(i-s+1) - ps*sale +oc*sum(y(i-s+1:ny));
   end;   
end;
