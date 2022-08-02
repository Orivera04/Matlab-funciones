function [M] = movieAz360(N,filename,q,el);
% movieAz360:       make a movie from the current window by flying around
%
%   [M] = movieAz360(N,filename,q,el);
%         N: number of frame with 360/N steps
%         filename: if '', no file is generated
%         q:  quality default=75;
%        el: user specified elevation
%
% Olivier Salvado, Case Western Reserve University, 09-August-2004

if nargin<3,
    q = 75;
end

if ((nargin>1) & ~isempty(filename)),    % assume a filename has been given
    flagfile = 1;
    disp(' Writing a file')
else
    flagfile = 0;
end


if flagfile,
    aviobj = avifile(filename,'compression','Cinepak','quality',q);
end

axis tight
if ~exist('el','var'),
    [az,el] = view;
end
da = 360/N;
idx = 1;
set(gcf,'DoubleBuffer','on');
for k =0:da:(360-da),
    view(k,el);
    F = getframe(gcf);
    M(:,idx) = F;
    idx = idx+1;
    if flagfile, ,    % assume a filename has been given
        aviobj = addframe(aviobj,F);
    end
end

if flagfile,     % assume a filename has been given
    aviobj = close(aviobj);
end

