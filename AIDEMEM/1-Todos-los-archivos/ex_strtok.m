function ex_strtok

s ='il fera beau demain';
invphr(s)

function s1 = invphr(s)

[car, cdr] = strtok(s);
if isempty(car)
  s1 = s;
else
  s1 = [invphr(cdr) ' '*ones(1,(length(cdr)>0)) car];
end;

