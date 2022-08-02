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
si = size(RM);
a = l*inv(eye(si(2)) - RM);

if any(a >= s.*m) 
   e=msgbox('network is unstable');
   uiwait(e);
      return;
      end;
switch i
         
case 0,
      y=a;
   
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
