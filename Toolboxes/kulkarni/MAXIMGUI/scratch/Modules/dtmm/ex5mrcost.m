function c = ex5mrcost(uu,dd,k, r,ru,cd,cbr);

% Returns vector c(i) = expected cost if i machines are working at the beginning of the day
% Input: uu = P(up|up); 
%        dd = P(down|down);
%        k = number of machines;
%        r = number of repair persons;
%        ru = revenue from each working machine per day;
%        cd  = cost a down machine per day;
%        cbs = cost of a busy repairperson;

c = zeros(1,k+1);
for i = 0:k
  c(i+1) = -ru*i + cd*(k-i) + cbr*min(k-i,r);
end;
