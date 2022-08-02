function [fullname,shortname,typecode]=CandidateSetInformation(obj)
% CANDIDATESETINFORMATION Candidate Set info
%
%  [FULLNAME, SHORTNAME, TYPECODE] = CANDIDATESETINFORMATION(OBJ)
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:00:08 $

% Created 15/11/2000

fullname = 'Central Composite';        % GUI popup name
shortname = 'ccd';   % command line name
typecode = 2;             % Standard design
return