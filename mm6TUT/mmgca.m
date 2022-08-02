function Ha=mmgca(Hf,flag)
%MMGCA Get Current Axes if it Exists. (MM)
% MMGCA returns the handle of the current axes
% in the current figure if it exists.
%
% MMGCA(Hf) returns the handle of the current axes in the
% figure having handle Hf.
%
% If no current axes exists, MMGCA returns an empty handle.
%
% MMGCA(Hf,Flag) when Flag=TRUE, generates an error message if
% no current axes exists.
%
% Note that the function GCA is different. It creates a figure
% and an axes and returns the axes handle if it does not exist.
%
% See also GCA, MMGCF, GCF

% Calls: mmgcf 

% B.R. Littlefield, University of Maine, Orono, ME, 04469
% 4/11/95 modified 2/21/96, v5: 1/14/97
% Mastering MATLAB 5, Prentice Hall, ISBN 0-13-858366-8
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

if nargin==0,
   Hf=mmgcf;
end
Ha=get(Hf,'CurrentAxes');
if isempty(Ha) & nargin==2 & flag~=0
   error('No Axes Exists in the Current Figure.')
end
