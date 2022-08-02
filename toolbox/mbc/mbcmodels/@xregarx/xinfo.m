function out = xinfo( m, xi )
%XREGARX/XINFO   Input variable information structure set/get method.
%   XINFO(M) is the input variable information structure for the model M.
%   XINFO(M,XI) is the model M with its input variable information set to that 
%   in XI.
%
%   The input variable information (Xinfo) structure has fields:
%     Names   -- cell array of long names
%     Units   -- cell array of JUNIT structues
%     Symbols -- cell array of short names
%
%   See also XREGMODEL/XINFO.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.2.6.1 $  $Date: 2004/02/09 07:45:48 $

if nargin == 1,
    out = xinfo( m.xregmodel );
    return;
end

if ~isstruct( xi ) | ~all(ismember({'Names','Units','Symbols'},fieldnames(xi)))
    error( ['Structure input with fields ''Names'', ''Units'', and ', ...
            '''Symbols'' is required'] );
end

xi.Names   = xi.Names(:);
xi.Symbols = xi.Symbols(:);
xi.Units   = xi.Units(:);
m.xregmodel = xinfo( m.xregmodel, xi );

% need to communicate this to the static model.
staticxinfo = expandxinfo( xinfo( m ), yinfo( m ), m.DynamicOrder, m.Delay );
m.StaticModel = xinfo( m.StaticModel, staticxinfo );

out = m;

%------------------------------------------------------------------------------|
% EOF
%------------------------------------------------------------------------------|
