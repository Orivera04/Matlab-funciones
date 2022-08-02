function r = interrect(r1, r2)

r = zeros(1,4);
[r(1), r(3)] = interseg(r1(1:2:end), r2(1:2:end));
[r(2), r(4)] = interseg(r1(2:2:end), r2(2:2:end));    
    
function s = interseg(s1, s2)    

if s1(1) > s2(1)
  s(1) = s1(1);
else
  s(1) = s2(1);
end;
if sum(s1) < sum(s2)
  s(2) = sum(s1);
else
  s(2) = sum(s2);
end;
if s(1) > s(2)
  s = [0, 0];
else
  s(2)=s(2)-s(1);
end;
