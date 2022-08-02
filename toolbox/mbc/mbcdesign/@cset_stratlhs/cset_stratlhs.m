function obj=cset_stratlhs(varargin)
% CSET_STRATLHS  Wrapper class for stratified LHS
%
%  OBJ=CSET_STRATLHS creates a Candidate set which wraps
%  an LHS and gives gui access to stratification settings
%
%  See CSET_LHS for more details
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:02:00 $

% Created 29/1/2001


prnt=cset_lhs(varargin{:});
strat=zeros(1,nfactors(prnt)); strat(end)=5;
prnt=set(prnt,'stratifylevels',strat);
obj.version=1;

obj=class(obj,'cset_stratlhs',prnt);
return