%    Script file: Newton-Raphson Method (newton3v1)
%    file name:  newton3v1
%    Newton Method for non-linear (and linear) systems with 3 variables
%Pre:
%   f1name   string that names a continuous function f1(x,y,z) of
%            three variables.
%   f2name   string that names a continuous function f2(x,y,z) of
%            three variables.
%   f3name   string that names a continuous function f3(x,y,z) of
%            three variables.
%   gradf1   vector string that names the gradient of a function 
%            f1(x,y,z) of three variables.
%   gradf2   vector string that names the gradient of a function 
%            f2(x,y,z) of three variables.
%   gradf3   vector string that names the gradient of a function 
%            f3(x,y,z) of three variables.
%     tol    non-negative (small) real number. (Precision Tolerance)
%  nitermax  non-negative integer. (Maximun number of iterations)
%Post:
%    root   the value of[xn,yn,zn] after n iteration with the property
%           that f(xn,yn,zn) = 0 and 
%           [xn,yn,zn] = [xn-1,yn-1,zn-1] - inv(J(f(xn-1,yn-1,zn-1))*f(xn-1,yn-1,zn-1).
%
%           Author: Prof. Jesus A. Hernandez,Ph.D.
%           Facultad de Ingenieria-UCV. Caracas,Venezuela
%
disp('NEWTON METHOD (For 3 variables)')
   disp('Author: Prof. Jesus A. Hernandez,Ph.D.')
   disp('Facultad de Ingenieria-UCV. Caracas,Venezuela')
       disp('')
       f1name = input('The first function is (between single quotes): f1(x,y,z) = ');
       f2name = input('The second function is (between single quotes): f2(x,y,z) = ');
       f3name = input('The third function is (between single quotes): f3(x,y,z) = ');
       gradf1 = [diff(f1name,'x') diff(f1name,'y') diff(f1name,'z')] ; 
       gradf2 = [diff(f2name,'x') diff(f2name,'y') diff(f2name,'z')];   
       gradf3 = [diff(f3name,'x') diff(f3name,'y') diff(f3name,'z')] ; 
       wa = input('Initial values [xo yo zo] = ');wa= wa';
       tol = input('Tolerance: ');
       nitermax = input('Number of iterations k = ');
       disp('')
       disp('--------------------------------------------------')
       disp('')
       disp('Roots of Functions by Method of Newton')
       disp('--------------------------------------------------')
       t1 = 'The first function is: f1(x,y,z) = ';
       t2 = 'The second function is: f2(x,y,z) = ';
       t3 = 'The third function is: f3(x,y,z) = ';
       disp([t1 f1name]);       
       disp([t2 f2name]);
       disp([t3 f3name]);   
       disp(sprintf('The initial values are xo = %- 4.2f, yo = %- 4.2f and zo = %- 4.2f',wa(1),wa(2),wa(3)))
       disp(sprintf('The maximun number of iteration is k = %3.0f\n and the tolerance is: %4.2e', nitermax,tol))
       disp('-----------------------------')
       disp('')
       disp('  k         x(k)           y(k)          z(k)         f1(x(k),y(k),z(k))       f2(x(k),y(k),z(k))        f3(x(k),y(k),z(k))')
       disp('---------------------------------------------------------------------------------------------------------------------------------')
       x = wa(1);
       y = wa(2);
       z=wa(3);
   fw1 = eval(f1name);
   fw2 = eval(f2name);
   fw3 = eval(f3name);
   fxo = [fw1;fw2;fw3];
   f1pw = eval(gradf1);
   f2pw = eval(gradf2);
   f3pw = eval(gradf3);
   fpxo =[f1pw;f2pw;f3pw];
   if det(fpxo)==0
      disp('Error: determinant of Jacobian is zero, try another initial point ')
  else
   iter = 0;
   s1 = sprintf('%3.0f      %- 10.4f     %- 10.4f     %- 10.4f',iter,wa(1),wa(2),wa(3));
   s2 = sprintf('          %- 10.4f                %- 10.4f                %- 10.4f',fw1,fw2,fw3);
   disp([s1 s2])
      while (norm(fxo)>tol) & (det(fpxo)~=0) & (iter<nitermax)
   iter = iter + 1; 
   wan = wa - inv(fpxo)*fxo;
   wa = wan;
   x = wa(1);
   y = wa(2);
   z = wa(3);
   fw1 = eval(f1name);
   fw2 = eval(f2name);
   fw3 = eval(f3name);
   fxo = [fw1;fw2;fw3];
   f1pw = eval(gradf1);
   f2pw = eval(gradf2);
   f3pw = eval(gradf3);
   fpxo =[f1pw;f2pw;f3pw];
   if det(fpxo)==0
      disp('Error: determinant of Jacobian is zero, try another initial point ')
  end
   s1 = sprintf('%3.0f      %- 10.4f     %- 10.4f     %- 10.4f',iter,wa(1),wa(2),wa(3));
   s2 = sprintf('          %- 10.4f                %- 10.4f                %- 10.4f',fw1,fw2,fw3);
   disp([s1 s2])
         end
         root = wa;
         disp(sprintf('\n The Root are: x = %- 6.4f, y = %- 6.4f, z = %- 6.4f',wa(1),wa(2),wa(3)))
     end       