% invinterp1

 %x = (1:10).';
 %x = linspace(1,100,100000);
 %y = cos(pi*x);
 
 %yo = .2;

if yo<min(y) || yo>max(y) % quick exit if no values exist
   xo = [];
else                      % search for the desired points
   
   n = length(y);
   xo = zeros(size(y))+nan; % preallocate space for found points
   alpha = 0;
   
   for k=1:n-1
      if ( y(k)<yo && y(k+1)>=yo ) ||... % below then above
         ( y(k)>yo && y(k+1)<=yo )       % above then below
      
         alpha = (yo-y(k))/(y(k+1)-y(k));    % distance between x(k+1) and x(k)
         xo(k) = alpha*(x(k+1)-x(k)) + x(k); % linearly interpolate
      end
   end
   xo = xo(~isnan(xo));      % get rid of unneeded preallocated space
   yo = repmat(yo,size(xo)); % duplicate yo to match xo points found
end

% if ~isempty(xo)
%    xol = [x(1); x(end)];
%    yol = [yo; yo];
%    plot(x,y,xol,yol,xo,yo,'o')
%    xlabel X
%    ylabel Y
%    title('Figure 38.2: Inverse Interpolation')
% end
