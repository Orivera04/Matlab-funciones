ax = axis;
[xlight,ylight] = meshgrid(linspace(5*ax(1),5*ax(2),3),linspace(5*ax(3),5*ax(4),3));
zlight = 5*ax(6);
N = length(xlight(:));
colours = rand(N,3);
k = 1;
for i=1:length(xlight)
   for j=1:length(ylight)
      light('Position',[xlight(i) ylight(j) zlight],...
         'Style','local',...
         'color',colours(k,:))
      k = k + 1;
   end
end
