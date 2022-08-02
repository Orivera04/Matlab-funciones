function out = xinfo( m, xi )
%XREGLOLIMOT/XINFO   Input variable information structure set/get method.
%   XINFO(M) is the input variable information structure for the model M.
%   XINFO(M,XI) is the model M with its input variable information set to that 
%   in XI.
%  
%    The input variable information (Xinfo) structure has fields:
%      Names   -- cell array of long names
%      Units   -- cell array of JUNIT structues
%      Symbols -- cell array of short names
% 
%    See also XREGMODEL/XINFO, XREGARX/XINFO.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.2.6.1 $  $Date: 2004/02/09 07:50:57 $

if nargin == 1,
    % get method
    out = xinfo( m.xregrbf );
else
    % set method
    m.xregrbf = xinfo( m.xregrbf, xi );
    for i = 1:get( m, 'NumberOfCenters' ),
        m.betamodels{i} = xinfo( m.betamodels{i}, xi );
    end
    out = m;
end

return

%------------------------------------------------------------------------------|
% EOF
%------------------------------------------------------------------------------|
