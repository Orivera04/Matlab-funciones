function c = ex5invcost(s,S,y,hc,ps, oc);

% Returns vector of expected cost in one time unit if there are i units on hand at beginning of the day
% Usage:  s = basestock level;
%         S = restocking level;
%         y = row vector of the demand pmf;
%         hc = cost of holding one item for one time unit;
%         ps = profit per sale;
%         oc = ordering cost;

[my ny]=size(y) ;
for i = s:S
  c(i-s+1) = hc*i;
  sale=0;
  for j=0:ny-1
    sale=sale + min(i,j)*y(j+1);
  end;
  c(i-s+1)=c(i-s+1) - ps*sale +oc*sum(y(i-s+1:ny));
end;   
