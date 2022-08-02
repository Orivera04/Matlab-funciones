function drawtrus(x,y,i,j)
%
% drawtrus(x,y,i,j)
% ~~~~~~~~~~~~~~~~~
%
% This function draws a truss defined by nodal
% coordinates defined in x,y and member indices 
% defined in i,j.
%
% User m functions called: none
%----------------------------------------------

hold on;
for k=1:length(i)
  plot([x(i(k)),x(j(k))],[y(i(k)),y(j(k))]);
end
