function spanplot (z)
% Spanplot (z)
% SPANPLOT takes a two dimensional matrix, z, and plots an
% HP-type waterfall plot of each column back to back with
% the first column plotted on the top and the last column 
% plotted on the bottom of the page. The y axis is re-scaled  
% in the same units to span the entire plot. 

% RwM-1993 rmeredith@nrlssc.navy.mil

a=size(z);
nrow=a(1);
ncol=a(2); 
maxvals=max(abs(z));
spcintv= .5 * mean(maxvals); % spacing interval btwn plots
maxspc = ncol*spcintv/2; % max offset = offset for 1st column

newz = z(:,1:ncol) + ones(nrow,1)* (maxspc - [1:ncol]*spcintv);

plot(newz);
