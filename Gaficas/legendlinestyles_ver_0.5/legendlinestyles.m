function legendlinestyles(h,markers,linestyles)
% legendlinestyles(h,markers,linestyles)
%==========================================================================
% Change the linestyles in an existing plot legend.
%
% Input: Handle to an existing legend object, h
%        Cell array with the new markers, markers
%        (optional) Cell array with the new linestyles, linestyles
% 
% If the 'linestyles' arument is ommitted, the original lines are left
% unchanged. Note, that no lines in the actual plot are affected.
%
% Output: None
%
%==========================================================================
% Version: 0.5
% Created: October 3, 2008, by Johan E. Carlson
% Last modified: October 3, 2008, by Johan E. Carlson
%==========================================================================


lines = findobj(get(h,'children'),'type','line');
m = 1;
for k = length(lines):-2:1,
    set(lines(k-1),'marker',char(markers{m}));
    if nargin == 3,
        set(lines(k),'linestyle',char(linestyles{m}));
    end
    m = m+1;
end