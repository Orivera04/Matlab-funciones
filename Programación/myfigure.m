function myfigure(num)
%
% generalization of matlab's figure(num) command
%  - if figure (num) exits, this function makes it active (current) but
%     does not raise it to the front like matlab's figure command
%  - if figure (num) does not exist, this function acts like figure.
%     it creates a new figure window (num) which is brought forward and 
%     made active
% unlike figure, this routine does not return a handle
%  
% written DGL at BYU  24 May 1999

H=get(0);               % get root handle for graphics
ch=H.Children;          % get children (graphics windows)
ind=find(ch == num);    % see if desired figure number exists
if isempty(ind)         %  if not, create it
    figure(num);
else                    % otherwise, make it active w/o bringing to front
  set(0,'CurrentFigure',num);
end
%
% the following line returns a handle to the currently active figure
% Handle=get(0,'CurrentFigure');  
