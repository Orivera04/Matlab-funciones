function [d,ok]=ClassicDesign(d,cs,action,opt)
% CLASSICDESIGN  interface for setting a classic design
%
% [D,OK]=CLASSICDESIGN(D, CSET,[ACTION],[OPT]) sets the design to consist of
% the points in CandidateSet CSET, and marks the design as
% a classical design of the appropriate type.  OK indicates whether
% design is rank-deficient (OK=0) or not(OK=1).  
%
% ACTION is an optional argument: ACTION='replace'/[] deletes all of the
% current design points.  ACTION='add' keeps all of the current points
% and adds the new ones on top.  ACTION='replacefree' keeps all of the
% fixed design points and deletes the free ones.
% OPT is an optional argument.  If OPT='constrain' then the design 
% points are run through the design's constraints object before being set.
%
% The default action is to replace all the points.  The default for OPT is
% to NOT constrain the points.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:06:01 $

% Created 9/1/2001

if nargin<4
   opt='';
elseif nargin<3 | isempty(action)
   action='replace';
end

[fullnm, nm, tp]=CandidateSetInformation(cs);

if (tp~=2)
   error('Not a Classical Design Set Generator');
end
if nfactors(cs)~=nfactors(d)
   error('Incorrect number of factors in Set Generator');
end

% get points and transfer to design object
pts=fullset(cs);
if strcmp(opt,'constrain') & ~isempty(d.constraints)
   c=reset(d.constraints);
   [c,in]=eval(c,pts);
   pts=pts(in,:);
end
switch action
case 'replace'
   [d,ok]=reinit(d,pts,'defined');
   d.style.base=3;
   d.style.baseinfo=cs;
case 'add'
   d=augment(d,pts,'points');
   ok=rankcheck(d);
case 'replacefree'
   d=deletefreepoints(d);
   d=augment(d,pts,'points');
   ok=rankcheck(d);
end
return