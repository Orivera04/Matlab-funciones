function [fullname,shortname,typecode]=CandidateSetInformation(obj)
% CANDIDATESETINFORMATION Candidate Set info
%
%  [FULLNAME, SHORTNAME, TYPECODE] = CANDIDATESETINFORMATION(OBJ)
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 06:59:51 $


fullname = 'Box-Behnken';        % GUI popup name
shortname = 'boxb';   % command line name
typecode = 2;             % Standard design
return