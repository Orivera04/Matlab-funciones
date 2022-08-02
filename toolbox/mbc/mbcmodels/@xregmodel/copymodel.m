function mcp=copymodel(mp,mcp)
% MODEL/COPYMODEL  Copy model information from one model to another
%
%   [COPYM]=copymodel(PRNTM,COPYM) copies the model fields from
%   PRNTM into COPYM.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.4.4.3 $  $Date: 2004/02/09 07:51:39 $



% Created 28/2/2000


% check both are models
if ~isa(mp,'xregmodel')
   error('Parent input is not a model!');
end
if ~isa(mcp,'xregmodel')
   error('Recipient input is not a model!');
end

% check models have matching number of factors
if nfactors(mp)~=nfactors(mcp)
   error('Number of factors different in each model');
end

if strcmp(class(mp),class(mcp))
	oldalg= mp.FitAlgorithm;
else
	oldalg= mcp.FitAlgorithm;
end

OldTgt = recommendedTgt(mp);
NewTgt = recommendedTgt(mcp);

if ~isempty(mp.Stats.Summary)
    % need to sort out summary stats
    [dum,oldList]= summary(mp);
    [dum,newList]= summary(mcp);
end

% smart copyobj
S= substruct('.','tmp');
fnames= fieldnames(xregmodel);
for i=1:length(fnames);
   S.subs= fnames{i};
   data= builtin('subsref',mp,S);
   mcp= builtin('subsasgn',mcp,S,data);
end

if ~isempty(mp.Stats.Summary)
    % find valid summary stats and update indices
    [OK,loc]=  ismember(oldList(mp.Stats.Summary),newList);
    mcp.Stats.Summary= sort(loc(loc~=0));
end

% don't copy fit algorithm
mcp.FitAlgorithm= oldalg;
if ~isequal(OldTgt,NewTgt) & ~isa(mp,'xregtwostage')
	% require to change target in model 
	% won't work for twostage
	[Bnds,g,t]= getcode(mp);
	mcp= setcode(mcp,Bnds,g,repmat(NewTgt,[nfactors(mcp),1]));
end




% model specific copy tasks
mcp=completecopymodel(mcp);

return
