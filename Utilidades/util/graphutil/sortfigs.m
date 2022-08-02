function sortfigs(figs)
%SORTFIGS Sort figure windows in ascending order.
%
%   SORTFIGS brings up the figures in ascending order so the figure with the
%   lowest figure number becomes the first window.
%   SORTFIGS(FIGS) can be used to specify which figures that should be sorted.

%   Author:      Peter J. Acklam
%   Time-stamp:  2003-10-13 13:14:00 +0200
%   E-mail:      pjacklam@online.no
%   URL:         http://home.online.no/~pjacklam

% Get the handles to the figures to process.
if ~nargin                              % If no input arguments...
   figs = findobj('Type', 'figure');    % ...find all figures.
   figs  = sort(figs);
end

if isempty(figs)
   disp('No open figures or no figures specified.');
   return
end

nfigs = length(figs);

for i = nfigs : -1 : 1
   figure(figs(i));             % Bring up i'th figure.
end
