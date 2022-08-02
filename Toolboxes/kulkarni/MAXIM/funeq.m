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
if m < 0
   msgbox('invalid value for m');return;
   else
switch i

case 1,
   if x < 0
      msgbox('invalid value of x'); return;      
   elseif m <= x
      msgbox('Queue is unstable'); return;
   else   
      y = x/m;
   end; 
case 2,
   [mx nx]=size(x);
   if mx ~=1 | nx ~= 2
      msgbox('invalid entry for x or i'); return;
   elseif x(1) < 1 | x(1) - fix(x(1)) ~= 0 
      msgbox('x(1) must be a positive integer'); return;
   elseif x(2) < 0
      msgbox('x(2) must be positive'); return;
      elseif m <= x(2)/x(1)
       msgbox('Queue is unstable'); return;
      else
   y0 = 0; y1 = (x(2)/(m+x(2)))^x(1);
   while abs(y1-y0) > .00001,
       y0 = y1;
       y1 = (x(2)/(m*(1-y0)+x(2)))^x(1);
       end;
   y=y1; 
   end; 
case 3,
   
      if x(1) < 1 | x(1) - fix(x(1)) ~= 0
      msgbox('x(1) must be a positive integer'); return;
      end;
      [mx nx] = size(x);
      if mx ~= 1 | nx ~= 2*x(1)+1
         msgbox('invalid entry for x'); return;
      end;
      l=x(2:x(1)+1);
      p=x(x(1)+2:2*x(1)+1);
      if any(l < 0) | any(p < 0) | abs(sum(p) - 1.0) > 10^(-8)  
      msgbox('invalid entry for x'); return;
      elseif m <= 1/sum(p./l)
       msgbox('Queue is unstable'); return;
    else
       
   y0 = 0; y1 = sum(p.*(l./(m+l)));
   while abs(y1-y0) > .00001,
       y0 = y1;
       y1 = sum(p.*(l./(m*(1-y0)+l)));
       end;
       y=y1;
       end;
    case 4,
       [mx nx] =size(x);
       if mx ~=1 | nx ~= 1
          msgbox('invalid entry for x or i'); return;
       end;
      if x < 0
      msgbox('x must be  a positive scalar'); return;      
   elseif m <= 1/x
       msgbox('Queue is unstable'); return;
   else 
   y0 = 0; y1 = exp(-m*x);
   while abs(y1-y0) > .00001,
       y0 = y1;
       y1 = exp(-m*(1-y0)*x);
       end;
       y=y1;
       end;
case 5,
   [mx nx]=size(x);
   if mx ~= 1
      msgbox('x must be row vector'); return;
   end;
   
   if any(x < 0) | abs(sum(x) - 1.0) > 10^(-10)
      msgbox('x must be a valid pmf'); return;
      elseif m <= 1/sum(x.*[0:nx-1])
       msgbox('Queue is unstable'); return;
      else 
   y0 = 0; y1 = sum(x.*exp(-m*[0:nx-1]));
   while abs(y1-y0) > .00001,
       y0 = y1;
       y1 = sum(x.*exp(-m*(1-y0)*[0:nx-1]));
       end;
       y=y1;
       end;
       
    case 6,
       if x(1) < 0 | x(1) > x(2)
          msgbox('invalid entry for x'); return;
          elseif m <= 2/(x(1)+x(2))
       msgbox('Queue is unstable'); return;
      else
   y0 = 0; y1 = (exp(-x(1)*m) - exp(-x(2)*m))/(m*(x(2)-x(1)));
   while abs(y1-y0) > .00001,
       y0 = y1;
       y1 = (exp(-x(1)*m*(1-y0)) - exp(-x(2)*m*(1-y0)))/(m*(1-y0)*(x(2)-x(1)));
       end;
       y=y1;
    end;
    
otherwise,
msgbox('invalid entry for i');
end;   
end;