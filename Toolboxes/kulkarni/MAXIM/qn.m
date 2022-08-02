function y = qn(l,m,s,RM,i);
%y = qn(l,m,s,RM,i)
%l arrival rate vector;
%m service rate vector;
%s = number of servers vector;
%RM = routing matrix;
%i = 0 => y = effective arrival rates at the nodes,
%i = 1 => y = mean number in system,
%i = 2 => y = mean number in queue,
%i = 3 => y = mean waiting time,
%i = 4 => y = mean queueing time,

y='error';
if  any(l < 0) 
msgbox('invalid entry for l'); return;
elseif  any(m < 0) 
msgbox('invalid entry for m'); return;
elseif  any(s < 0) |any(fix(s) - s ~=0)
msgbox('invalid entry for s'); return;
elseif size(s) ~= size(m) | size(l) ~= size(m)
msgbox('l, m  and s must of the same size'); return;
elseif any(RM <0) | any(sum(RM') > 1) 
msgbox('invalid entry for RM'); return;
else
si = size(RM);
a = l*inv(eye(si(2)) - RM);
if i==0
   y=a;return;
end;

if any(a > s.*m) 
      msgbox('network is unstable');
      return;
      end;
switch i
         
case 0,
       
case 1,
   y=[];
   for  j = 1:si(2)
      y = [y mms(a(j),m(j),s(j),i)];
      end; 

case 2,
   y=[];
   for  j = 1:si(2)
      y = [y mms(a(j),m(j),s(j),i)];
      end; 
   

case 3,
   y=[];
   for  j = 1:si(2)
      y = [y mms(a(j),m(j),s(j),i)];
      end;

case 4,
   y=[];
   for  j = 1:si(2)
      y = [y mms(a(j),m(j),s(j),i)];
      end;

otherwise,
msgbox('invalid entry for i');
end;   
end;
