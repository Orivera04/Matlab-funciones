% invinterp2

% x = (1:10).';  % sample data
% y = cos(pi*x);
% yo = -0.2;

n = length(y);

if yo<min(y) || yo>max(y) % quick exit if no values exist
   xo = [];
else                      % find the desired points
   
   below = y<yo;   % True where below yo 
   above = y>=yo;  % True where at or above yo
   
   kth = (below(1:n-1)&above(2:n))|(above(1:n-1)&below(2:n)); % point k
   kp1 = [false; kth];                                        % point k+1
   
   alpha = (yo - y(kth))./(y(kp1)-y(kth));% distance between x(k+1) and x(k)
   xo = alpha.*(x(kp1)-x(kth)) + x(kth);  % linearly interpolate using alpha
   
   yo = repmat(yo,size(xo)); % duplicate yo to match xo points found
end
% 
% if ~isempty(xo)
%    xol = [x(1); x(end)];
%    yol = [yo(1) yo(1)];
%    plot(x,y,xol,yol,xo,yo,'o')
%    xlabel X
%    ylabel Y
%    title('Figure 38.2: Inverse Interpolation')
% end
