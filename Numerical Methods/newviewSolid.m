function newviewSolid(zvar, F, G, yvar, f, g, xvar, a, b)
%NEWVIEWSOLID is a version for MATLAB of a routine for viewing the region
%  bounded by two surfaces for the purpose of setting up triple integrals. 
%  The arguments are entered from the inside out.  
%  Here f, g, F, and G should be symbolic expressions in the
%  symbolic variables xvar, yvar, and zvar.
%  The variable xvar (x, for example) is on the OUTSIDE
%  of the triple integral, and goes between CONSTANT limits a and b.
%  The variable yvar goes in the MIDDLE of the triple integral, and goes 
%  between limits which must be expressions in one variable [xvar].
%  The variable zvar goes in the INSIDE of the triple integral, and goes
%  between limits which must be expressions in two 
%  variables [xvar and yvar].  The lower surface is plotted in red, the
%  upper one in blue, and the "hatching" in cyan.
%
%  Examples: newviewSolid(z, 0, (x+y)/4, y, x/2, x, x, 1, 2)
%  or
%  newviewSolid(z, x^2+3*y^2, 4-y^2, y, -sqrt(4-x^2)/2, sqrt(4-x^2)/2, ...
%               x, -2, 2,)
%
% Note: if one r both of the variables are missing in one of the limits,
% a "fudge" such as adding eps*x+eps*y may be needed.

% Now we rename the symbolic variables, in case they are something 
% different, and then convert f, g, F, G to functions.
syms x y z; 
f1 = subs(f, xvar, x); g1 = subs(g, xvar, x);
F1 = subs(F, [xvar, yvar], [x, y]); G1 = subs(G, [xvar, yvar], [x, y]);
ffun=@(x) eval(vectorize(f1));
gfun=@(x) eval(vectorize(g1));
Ffun=@(x,y) eval(vectorize(F1));
Gfun=@(x,y) eval(vectorize(G1));

for counter=0:20
  xx = a + (counter/20)*(b-a);
  YY = ffun(xx)*ones(1, 21)+((gfun(xx)-ffun(xx))/20)*(0:20);
  XX = xx*ones(1, 21);
%% The next lines inserted to make bounding curves thicker.
  widthpar=0.5;
  if counter==0, widthpar=2; end
  if counter==20, widthpar=2; end
%% Plot curves of constant x on surface patches.
 plot3(XX, YY, Ffun(XX, YY).*ones(1,21), 'r', 'LineWidth', widthpar);
 hold on
 plot3(XX, YY, Gfun(XX, YY).*ones(1,21), 'b', 'LineWidth', widthpar);
end;
%% Now do the same thing in the other direction.
XX = a*ones(1, 21)+((b-a)/20)*(0:20); 
%% Normalize sizes of vectors.
YY=0:2; ZZ1=0:20; ZZ2=0:20;
for counter=0:20,
%% The next lines inserted to make bounding curves thicker.
  widthpar=0.5;
  if counter==0, widthpar=2; end
  if counter==20, widthpar=2; end
    for i=1:21, 
       YY(i)=ffun(XX(i))+(counter/20)*(gfun(XX(i))-ffun(XX(i)));
       ZZ1(i)=Ffun(XX(i),YY(i)); 
       ZZ2(i)=Gfun(XX(i),YY(i)); 
    end;
  plot3(XX, YY, ZZ1, 'r', 'LineWidth',widthpar);
  plot3(XX, YY, ZZ2, 'b', 'LineWidth',widthpar);
end;
%% Now plot vertical lines.
for u = 0:0.2:1,
  for v = 0:0.2:1,
   xx = a + (b-a)*u; 
   yy = ffun(a + (b-a)*u) +(gfun(a + (b-a)*u)-ffun(a + (b-a)*u))*v;
   plot3([xx, xx], [yy, yy], [Ffun(xx,yy), Gfun(xx, yy)], 'c');
  end;
end;
xlabel(char(xvar))
ylabel(char(yvar))
zlabel(char(zvar))
hold off


