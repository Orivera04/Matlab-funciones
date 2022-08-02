function y = funeq(i,x,m);
%y = funeq(i,x,m)
% solves the key functional equation of the G/M/1 queue
%with sercice rate m, and interarrival time distribution
%of type i as given below
%i = 1 => exp(x)
%i = 2 => erl(x(1), x(2)),
%i = 3 => hyperexp(x(1),x(2:x(1)+1),x(x(1)+2:2*x(1)+1)
%i = 4 => constant(x),
%i = 5 => discrete with pmf(x), x(i) = p(int.arr = i-1),
%i = 6 => continuous U(x(1),x(2))
%m = service rate.
%y = solution to the functional equation;
y='error';
switch i

case 1,
   if  m <= x
      e=msgbox('Queue is unstable'); uiwait(e);return;     
   else
      y = x/m;
   end
   
   
case 2,
   [mx nx]=size(x);
   if  m <= x(2)/x(1)
      e=msgbox('Queue is unstable'); uiwait(e);return;
   else
      y0 = 0; y1 = (x(2)/(m+x(2)))^x(1);
      while abs(y1-y0) > .00001,
         y0 = y1;
         y1 = (x(2)/(m*(1-y0)+x(2)))^x(1);
      end;
      y=y1;
   end;
   
case 3,
   
   l=x(2:x(1)+1);
   p=x(x(1)+2:2*x(1)+1);
   if  m <= 1/sum(p./l)
      e=msgbox('Queue is unstable'); uiwait(e);return;
   else
      y0 = 0; y1 = sum(p.*(l./(m+l)));
      while abs(y1-y0) > .00001,
         y0 = y1;
         y1 = sum(p.*(l./(m*(1-y0)+l)));
      end;
      y=y1;
   end;
   
case 4,
   
   if  m <= 1/x
      e=msgbox('Queue is unstable'); uiwait(e); return;
   else
      y0 = 0; y1 = exp(-m*x);
      while abs(y1-y0) > .00001,
         y0 = y1;
         y1 = exp(-m*(1-y0)*x);
      end;
      y=y1;
   end;
   
case 5,
   
   [mx,nx] = size(x);
   if  m <= 1/sum(x.*[0:nx-1])
      e=msgbox('Queue is unstable'); uiwait(e);return;
   else
      y0 = 0; y1 = sum(x.*exp(-m*[0:nx-1]));
      while abs(y1-y0) > .00001,
         y0 = y1;
         y1 = sum(x.*exp(-m*(1-y0)*[0:nx-1]));
      end;
      y=y1;
   end;
   
       
case 6,
   
   if  m <= 2/(x(1)+x(2))
      e=msgbox('Queue is unstable'); uiwait(e); return;
   else
      y0 = 0; y1 = (exp(-x(1)*m) - exp(-x(2)*m))/(m*(x(2)-x(1)));
      while abs(y1-y0) > .00001,
         y0 = y1;
         y1 = (exp(-x(1)*m*(1-y0)) - exp(-x(2)*m*(1-y0)))/(m*(1-y0)*(x(2)-x(1)));
      end;
      y=y1;
   end;
   
case 7,
   
   if m <= x(1)
      e=msgbox('Queue is unstable'); uiwait(e); return;
   else
      y0 = 0; y1 = exp(-m)*x(1)/(1-exp(-m)*(1-x(1)));
      while abs(y1-y0) > .00001,
         y0 = y1;
         y1 = exp(-m*(1-y1))*x(1)/(1-exp(-m*(1-y1))*(1-x(1)));
      end;
      y=y1;
   end;


otherwise,
   msgbox('invalid entry for i');
end;   
