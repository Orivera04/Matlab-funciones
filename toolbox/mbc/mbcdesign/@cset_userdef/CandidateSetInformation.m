function [fullname,shortname,typecode]=CandidateSetInformation(obj)
% CANDIDATESETINFORMATION Candidate Set info
%
%  [FULLNAME, SHORTNAME, TYPECODE] = CANDIDATESETINFORMATION(OBJ)
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:02:02 $

% Created 1/11/2000

fullname = 'User-defined';        % GUI popup name
shortname = 'userdef';   % command line name
typecode = 0;             % 'Standard' candidate set
return