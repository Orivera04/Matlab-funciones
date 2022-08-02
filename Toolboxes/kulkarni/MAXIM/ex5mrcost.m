function c = ex5mrcost(uu,dd,k, r,ru,cd,cbr);
%c = ex5mrcost(uu,dd,k, r,ru,cd,cbr)
%uu = P(up|up); 
%dd = P(down|down);
%k = number of machines;
%r = number of repair persons;
%ru = revenue from each working machine per day;
%cd  = cost a down machine per day;
%cbs = cost of a busy repairperson;
%Output c(i) = expected cost if i machines are 
%working at the beginning of the day.
if  (uu <0) | (uu > 1)
msgbox('invalid entry for uu');P = 'error';return;
elseif  (dd <0) | (dd > 1)
msgbox('invalid entry for dd');P = 'error';return; 
elseif  (k < 0) | (fix(k) - k ~= 0)
msgbox('invalid entry for k');P = 'error';return; 
elseif  (r < 0) | (fix(r) - r ~= 0) 
msgbox('invalid entry for r');P = 'error';return; 
else
   c=zeros(1,k+1);
   for i=0:k
      c(i+1) = -ru*i + cd*(k-i) + cbr*min(k-i,r);
   end;
end;
