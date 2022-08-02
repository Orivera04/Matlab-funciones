function [fullname,shortname,typecode]=CandidateSetInformation(obj)
% CANDIDATESETINFORMATION Candidate Set info
%
%  [FULLNAME, SHORTNAME, TYPECODE] = CANDIDATESETINFORMATION(OBJ)
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:01:59 $

% Created 10/1/2001

fullname = 'Stratified Latin Hypercube';        % GUI popup name
shortname = 'stratlhs';                         % command line name
typecode = 1;                                   % 'Space Filler' candidate set
return