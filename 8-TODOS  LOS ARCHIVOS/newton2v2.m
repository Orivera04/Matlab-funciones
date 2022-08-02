%script file NEWTON METHOD (for 2 variables)
       disp('NEWTON METHOD (For 2 variables)')
%Pre:
%   f1name   string that names a continuous function f1(x,y) of
%            two variables.
%   f2name   string that names a continuous function f2(x,y) of
%            two variables.
     
%  gradf1   vector string that names the gradient of the function 
%           f1(x,y) of two variables.
%  gradf2   vector string that names the gradient of the function 
%           f2(x,y) of two variables.
      
%     tol   non-negative real,(tolerance to stop calculations) .
% nitermax  non-negative integer, (*maximun number of iteration to be performed).
%Post:
%    root   the value of[xn,yn] after n iteration with the property
%           that f(xn,yn) = 0 and [xn,yn] = [xn-1,yn-1] - 
%           inv(J(f(xn-1,yn-1))*f(xn-1,yn-1).
%
       disp('')
       f1name = input('The first function? (between quotes) f1(x,y) = ');
       f2name = input('The second function? (between quotes)f2(x,y) = ');
       gradf1 = [diff(f1name,'x') diff(f1name,'y')] ; 
       gradf2 = [diff(f2name,'x') diff(f2name,'y')];    
       w = input('Initial values [xo yo] = ');
       v = w';
       tol = input('Tolerance: ');
       nitermax = input('Number of iterations k = ');
       clc
       disp('')
       disp('--------------------------------------------------')
       disp('')
       disp('Roots of Functions by Method of Newton')
       disp('--------------------------------------------------')
       t1 = 'The first function is: f1(x,y) = ';
       t2 = 'The second function is: f2(x,y) = ';
       disp([t1 f1name]);       
       disp([t2 f2name]);
       disp(sprintf('The initial values are xo = %- 4.2f and yo = %- 4.2f',v(1),v(2)))
       disp(sprintf('The maximun number of iteration is k = %3.0f\n and the tolerance is: %4.2e', nitermax,tol))
       disp('-----------------------------')
       disp('')
       disp('  k         x(k)           y(k)             f1(x(k),y(k))             f2(x(k),y(k))')
       disp('-----------------------------------------------------------------------------------------')
       x = v(1);
       y = v(2);
   fv1 = eval(f1name);
   fv2 = eval(f2name);
   fxo = [fv1;fv2];
   f1pv = eval(gradf1);
   f2pv = eval(gradf2);
   fpxo =[f1pv;f2pv];
   if det(fpxo)==0
      disp('Error: determinant of Jacobian is zero, try another initial point ')
  else
   iter = 0;
   s1 = sprintf('%3.0f      %- 10.4f     %- 10.4f',iter,v(1),v(2));
   s2 = sprintf('          %- 14.4f                %- 14.4f',fv1,fv2);
   disp([s1 s2])
      while (norm(fxo)>tol) & (det(fpxo)~=0) & (iter<nitermax)
   iter = iter + 1; 
   vn = v - inv(fpxo)*fxo;
   v = vn;
   x = v(1);
   y = v(2);
   fv1 = eval(f1name);
   fv2 = eval(f2name);
   fxo = [fv1;fv2];
   f1pv = eval(gradf1);
   f2pv = eval(gradf2);
   fpxo =[f1pv;f2pv];
   if det(fpxo)==0
      disp('Error: determinant of Jacobian is zero, try another initial point ')
  end
   s1 = sprintf('%3.0f      %- 10.4f     %- 10.4f',iter,v(1),v(2));
   s2 = sprintf('          %- 14.4f                %- 14.4f',fv1,fv2);
   disp([s1 s2])
         end
         root = v;
         disp(sprintf('\n The Root are: x = %- 8.4f, y = %- 8.4f',v(1),v(2)))
     end       