function Hf=mmgcf(flag)
%MMGCF Get Current Figure if it Exists. (MM)
% MMGCF returns the handle of the current figure if it exists.
% If no current figure exists, MMGCF returns an empty handle.
%
% MMGCF(Flag) when Flag=TRUE, generates an error message if
% no current figure exists.
%
% Note that the function GCF is different. It creates a figure
% and returns its handle if it does not exist.
%
% See also MMGCA, GCF, MMGCF.

% D.C. Hanselman, University of Maine, Orono, ME, 04469
% 3/10/95, v5: 1/14/97
% Mastering MATLAB 5, Prentice Hall, ISBN 0-13-858366-8
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

Hf=get(0,'CurrentFigure');
if isempty(Hf) & nargin==1 & flag~=0 
   error('No Figure Window Exists.')
end
