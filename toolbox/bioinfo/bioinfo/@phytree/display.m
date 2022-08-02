function display(tr)
%DISPLAY command window display of phylogenetic tree objects.

% Copyright 2003-2004 The MathWorks, Inc.
% $Revision: 1.1.6.3 $ $Author: batserve $ $Date: 2004/01/24 09:18:02 $

if numel(tr) > 1
    disp(tr)
else
    n = length(tr.dist); 
    switch n
        case 0
            disp('    Empty phylogenetic tree object')
        case 1
            disp('    Phylogenetic tree object with 1 leaf (0 branches)')
        case 3
            disp('    Phylogenetic tree object with 2 leaves (1 branch)')
        otherwise
            disp(['    Phylogenetic tree object with ' num2str((n+1)/2) ...
                  ' leaves (' num2str((n-1)/2) ' branches)'])
    end
end

