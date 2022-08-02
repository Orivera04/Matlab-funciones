
function  drawfr(c, A, rel, b)

% Graphs of the feasible region and the line level
% of the LP problem with two legitimate variables
%
%                    min (max)z = c*x
%                 Subject to  Ax <= b (or Ax >= b), 
%                              x >= 0

clc
[m, n] = size(A);
if n ~= 2
   str = 'Number of the legitimate variables must be equal to 2';
   msgbox(str,'Error Window','error')
   return
end
t = extrpts(A,rel,b);
if isempty(t)
   disp(sprintf('\n   Empty feasible region'))
   return
end
t = t(1:2,:);
t = delcols(t);
d = extrdir(A,rel,b);
if ~isempty(d)
   msgbox('Unbounded feasible region','Warning Window','warn')
   disp(sprintf('\n   Extreme direction(s) of the constraint set'))
   d
   disp(sprintf('\n   Extreme points of the constraint set'))
   t
   return
end
t1 = t(1,:);
t2 = t(2,:);
z = convhull(t1,t2);
hold on
patch(t1(z),t2(z),'r')
h = .25;
mit1 = min(t1)-h;
mat1 = max(t1)+h;
mit2 = min(t2)-h;
mat2 = max(t2)+h;
if c(1) ~= 0 & c(2) ~= 0
   sl = -c(1)/c(2);
   if sl > 0
      z = c(:)'*[mit1;mit2];
      a1 = [mit1 mat1];
      b1 = [mit2 (z-c(1)*mat1)/c(2)];
   else 
      z = c(:)'*[mat1;mit2];
      a1 = [mit1 mat1];
      b1 = [(z-c(1)*mit1)/c(2) mit2];
   end    
elseif c(1) == 0 & c(2) ~= 0
   z = 0;
   a1 = [mit1 mat1];
   b1 = [0,0];
else
   z = 0;
   a1 = [0 0];
   b1 = [mit2 mat2];
end
h = plot(a1,b1);
set(h,'linestyle','--')
set(h,'linewidth',2)
str = 'Feasible region and a level line with the objective value = '; 
title([str,num2str(z)])
axis([mit1 mat1 mit2 mat2])
h = get(gca,'Title');
set(h,'FontSize',11)
xlabel('x_1')
h = get(gca,'xlabel');
set(h,'FontSize',11)
ylabel('x_2')
h = get(gca,'ylabel');
set(h,'FontSize',11)
grid
hold off
   

