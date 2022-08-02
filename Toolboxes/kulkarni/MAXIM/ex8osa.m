function y=ex8osa(l,m,s)
%y=ex8osa(l,m,s)
%l = arrival rate;
%m=[m1 m2] = service rates t station 1 and 2 
%per server;
%s= total number of servers.
y='error';
[mm nm]=size(m);
if mm ~=1 | nm ~= 2
   msgbox('m must be a rwo vector'); return;
elseif any(m < 0) 
   msgbox('m must be  positive'); return;
elseif l < 0
   msgbox('l must be positive'); return;
elseif s < 0 | s - fix(s) ~= 0
   msgbox('s must be a positive integer'); return;
elseif (l/m(1) + l/m(2) >= s)
   msgbox('s is too small'); return;
else
   y=[];x=[fix(l/m(1)) + 1: ceil(s-l/m(2))-1];
   for s1=fix(l/m(1)) + 1: ceil(s-l/m(2))-1
      y = [y mms(l,m(1),s1,1)+mms(l,m(2),s-s1,1)];
   end;
   plot(x,y)
end;

