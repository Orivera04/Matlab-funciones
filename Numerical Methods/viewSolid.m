function viewSolid(zvar, F, G, yvar, f, g, xvar, a, b)
%VIEWSOLID is a version for MATLAB of the routine on page 161
%  of "Multivariable Calculus and Mathematica" for viewing the region
%  bounded by two surfaces for the purpose of setting up triple integrals. 
%  The arguments are entered from the inside out.  
%  There are two forms of the command --- either f, g,
%  F, and G can be vectorized functions, or else they can
%  be symbolic expressions. xvar, yvar, and zvar can be
%  either symbolic variables or strings.
%  The variable xvar (x, for example) is on the 
%  OUTSIDE of the triple integral, and goes between CONSTANT limits a and b.
%  The variable yvar goes in the MIDDLE of the triple integral, and goes 
%  between limits which must be expressions in one variable [xvar].
%  The variable zvar goes in the INSIDE of the triple integral, and goes
%  between limits which must be expressions in two 
%  variables [xvar and yvar].  The lower surface is plotted in red, the
%  upper one in blue, and the "hatching" in cyan.
%
% Examples: viewSolid(z, 0, (x+y)/4, y, x/2, x, x, 1, 2)
% gives the picture on page 163 of "Multivariable Calculus and Mathematica"  
% and the picture on page 164 of "Multivariable Calculus and Mathematica"
% can be produced by
%     viewSolid(z, x^2+3*y^2, 4-y^2, y, -sqrt(4-x^2)/2, sqrt(4-x^2)/2, ...
%               x, -2, 2,)
% One can also type viewSolid('z', @(x,y) 0, ...
% @(x,y)(x+y)/4, 'y', @(x) x/2, @(x) x, 'x', 1, 2)
%

if isa(f, 'sym') % case of symbolic input
    ffun=inline(vectorize(f+0*xvar),char(xvar));
    gfun=inline(vectorize(g+0*xvar),char(xvar));
    Ffun=inline(vectorize(F+0*xvar),char(xvar),char(yvar));
    Gfun=inline(vectorize(G+0*xvar),char(xvar),char(yvar));
    oldviewSolid(char(xvar), double(a), double(b), ...
       char(yvar), ffun, gfun, char(zvar), Ffun, Gfun)
else 
   oldviewSolid(char(xvar), double(a), double(b), ...
       char(yvar), f, g, char(zvar), F, G)
end
%%%%%%% subfunction goes here %%%%%%
function oldviewSolid(xvar, a, b, yvar, f, g, zvar, F, G)
for counter=0:20
  xx = a + (counter/20)*(b-a);
  YY = f(xx)*ones(1, 21)+((g(xx)-f(xx))/20)*(0:20);
  XX = xx*ones(1, 21);
%% The next lines inserted to make bounding curves thicker.
  widthpar=0.5;
  if counter==0, widthpar=2; end
  if counter==20, widthpar=2; end
%% Plot curves of constant x on surface patches.
 plot3(XX, YY, F(XX, YY).*ones(1,21), 'r', 'LineWidth', widthpar);
 hold on
 plot3(XX, YY, G(XX, YY).*ones(1,21), 'b', 'LineWidth', widthpar);
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
       YY(i)=f(XX(i))+(counter/20)*(g(XX(i))-f(XX(i)));
       ZZ1(i)=F(XX(i),YY(i)); 
       ZZ2(i)=G(XX(i),YY(i)); 
    end;
  plot3(XX, YY, ZZ1, 'r', 'LineWidth',widthpar);
  plot3(XX, YY, ZZ2, 'b', 'LineWidth',widthpar);
end;
%% Now plot vertical lines.
for u = 0:0.2:1,
  for v = 0:0.2:1,
   x=a + (b-a)*u; y = f(a + (b-a)*u) +(g(a + (b-a)*u)-f(a + (b-a)*u))*v;
   plot3([x, x], [y, y], [F(x,y), G(x, y)], 'c');
  end;
end;
xlabel(xvar)
ylabel(yvar)
zlabel(zvar)
hold off


