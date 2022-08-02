function data = getdata( root, var , docode)
%GETDATA Get the modeling data from boundary constraint root node.
%
%  DATA = GETDATA(ROOT) is the data that is valid for the boundary modeling
%  at the given root node.
%
%  The data returned is dependent on the Stages field of ROOT:
%    Stages = 0 (Response) double array of all data points
%    Stages = 1 (Local) sweepset of local and global data
%    Stages = 2 (Global) double array of global data points


%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.6.2 $    $Date: 2004/02/09 08:12:49 $ 

if nargin < 2 || isempty(var)
    var = root.Stages;
end
if nargin<3
    docode= true;
end

if ~ischar( var )
    switch var,
        case 0,
            var = 'Response';
        case 1,
            var = 'Local';
        case 2,
            var = 'Global';
    end
end
p = Parent( root );
data = p.getdata( var , docode);
