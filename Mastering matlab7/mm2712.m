[X,Y,Z] = peaks(30);
x = X(1,:);              % vector of x axis
y = Y(:,1);              % vector of y axis
i = find(y>.8 & y<1.2);  % find y axis indices of hole
j = find(x>-.6 & x<.5);  % find x axis indices of hole
Z(i,j) = nan;            % set values at hole indices to NaNs
surf(X,Y,Z)
xlabel('X-axis'), ylabel('Y-axis'), zlabel('Z-axis')
title('Figure 27.12: Surface Plot with a Hole')