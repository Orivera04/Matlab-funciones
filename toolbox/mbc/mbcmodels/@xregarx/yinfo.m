function out = yinfo( m, yi )
%XREGARX/YINFO   Output variable information structure set/get method.
%   YINFO(M) is the output variable information structure for the model M.
%   YINFO(M,YI) is the model M with its output variable information set to that 
%   in YI.
%
%   The output variable information (Yinfo) structure has fields:
%     Name    -- long name
%     Units   -- JUNIT structue
%     Symbol  -- short name
%
%   See also XREGMODEL/YINFO.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.2.6.1 $  $Date: 2004/02/09 07:45:50 $


if nargin == 1,
    out = yinfo( m.xregmodel );
    return;
end

m.xregmodel = yinfo( m.xregmodel, yi );

% need to communicate this to the static model.
staticxinfo = expandxinfo( xinfo( m ), yinfo( m ), m.DynamicOrder, m.Delay );
m.StaticModel = xinfo( m.StaticModel, staticxinfo );

out = m;

%------------------------------------------------------------------------------|
% EOF
%------------------------------------------------------------------------------|
