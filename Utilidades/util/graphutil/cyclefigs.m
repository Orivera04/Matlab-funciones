function cyclefigs(figs)
%CYCLEFIGS Cycle through figure windows.
%
%   CYCLEFIGS brings up all open figure in ascending order and pauses after
%   each figure.  When done, the figures are sorted in ascending order.

%   Author:      Peter J. Acklam
%   Time-stamp:  2003-10-13 15:40:11 +0200
%   E-mail:      pjacklam@online.no
%   URL:         http://home.online.no/~pjacklam

% Get the handles to the figures to process.
if ~nargin                              % If no input arguments...
   figs = findobj('Type', 'figure');    % ...find all figures.
   figs = sort(figs);
end

if isempty(figs)
   disp('No open figures or no figures specified.');
   return
end

n = length(figs);

% Bring one figure up at a time.
for i = 1 : n

   % Display the figure.
   figure(figs(i));

   % Display the prompt string.
   fprintf(1, 'Displaying figure %d.', figs(i));
   if i < n
      fprintf(1, ' Press any key do display figure %d.', figs(i+1));
   else
      fprintf(1, ' Press any key to return.');
   end
   fprintf(1, '\n');

   % Pause for input.
   pause;

end

% Sort the figures.
for i = n : -1 : 1
   figure(figs(i));
end
