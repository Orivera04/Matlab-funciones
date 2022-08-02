function [ok, msg] = pCheckTableLinks(tables, fillfactors, solutiontype, solutionindex)
%PCHECKTABLELINKS Private method to check table links
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.1.6.2 $  $Date: 2004/02/09 06:54:32 $

ok= false;
msg = '';

if ~all(isvalid(fillfactors)) | ~isequal(size(fillfactors), size(tables))
    msg = 'PFILL must be a pointer vector of identical dimension to PTABS';
elseif ~iscell(solutiontype) | ~all(ismember(solutiontype, {'solution';'pareto';'weightedpareto'})) | ~isequal(size(solutiontype), size(tables))
    msg = 'SOLUTIONTYPE must be either ''solution'', ''pareto'' or ''weightedpareto''';
elseif ~isnumeric(solutionindex) | ~isequal(size(solutionindex), size(tables))
    msg = 'Invalid SOLUTIONINDEX specified';
else
    ok = true;
end
