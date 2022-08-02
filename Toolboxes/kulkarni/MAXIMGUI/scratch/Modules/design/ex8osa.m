function [y,x,g]=ex8osa(l,m,s)
%y=ex8osa(l,m,s)
%l = arrival rate;
%m=[m1 m2] = service rates t station 1 and 2 
%per server;
%s= total number of servers.
   g=[];x=[fix(l/m(1)) + 1: ceil(s-l/m(2))-1];
   for s1=fix(l/m(1)) + 1: ceil(s-l/m(2))-1
      g1=mms(l,m(1),s1);
      g2=mms(l,m(2),s-s1);
      g = [g g1{1}+g2{1}];
   end;
   [x1,x2] = min(g);
   y=[x1,x2(1)+x(1)-1];
  