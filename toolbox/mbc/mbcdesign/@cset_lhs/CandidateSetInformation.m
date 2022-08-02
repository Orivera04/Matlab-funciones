function [fullname,shortname,typecode]=CandidateSetInformation(obj)
% CANDIDATESETINFORMATION Candidate Set info
%
%  [FULLNAME, SHORTNAME, TYPECODE] = CANDIDATESETINFORMATION(OBJ)
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:00:40 $

% Created 1/11/2000

fullname = 'Latin Hypercube Sampling';   % GUI popup name
shortname = 'lhs';                       % command line name
typecode = 1;                            % 'Space Filler' candidate set
return