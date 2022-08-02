[x,y] = meshgrid([-2:.4:2]);
Z = zeros(size(x));
sh = surface('XData',x,'YData',y,'ZData',Z,'FaceColor',[1 1 1])

 
            