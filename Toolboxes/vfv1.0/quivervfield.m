% QUIVERVFIELD is an internal command of the toolbox. It puts arrows at
% semi-random positions (no two of them are closer than a certain distance)
% on the current figure to show direction in LIC images.

function finalLIC = quivervfield(vx,vy);
[m,n] = size(vx);
nGrid = 5; % put nGrid arraows in along each dimension, the total of nGrid * nGrid arrows will be put on the current figure
hold on;

randomGridX = zeros(nGrid,nGrid);
randomGridY = zeros(nGrid,nGrid);

randomGridVX = zeros(nGrid,nGrid);
randomGridVY = zeros(nGrid,nGrid);

for i = 1:nGrid 
    for j = 1:nGrid 
    randomGridX(i,j) = ((i - 0.5) * m / nGrid) + (m / nGrid) * (0.3 - 0.6 * rand);
    if randomGridX(i,j) > m randomGridX(i,j) = m; end;
    randomGridY(i,j) = ((j - 0.5) * n / nGrid) + (n / nGrid) * (0.3 - 0.6 * rand);
    if randomGridY(i,j) > n randomGridY(i,j) = n; end;
    l = sqrt(vx(round(randomGridX(i,j)),round(randomGridY(i,j)))^2 + vy(round(randomGridX(i,j)),round(randomGridY(i,j)))^2 );
    if l > 0 
        randomGridVX(i,j) = vx(round(randomGridX(i,j)),round(randomGridY(i,j))) / l;
        randomGridVY(i,j) = vy(round(randomGridX(i,j)),round(randomGridY(i,j))) / l;
    end;
    end;
end;
quiver(randomGridY, randomGridX,randomGridVY, randomGridVX,0.15,'filled','w','LineWidth',1);
hold off;

finalLIC = frame2im(getframe(gcf));