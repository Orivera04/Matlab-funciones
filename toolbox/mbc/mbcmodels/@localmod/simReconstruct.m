function blk= simReconstruct(m,sname)
% LOCALMOD/SIMRECONSTRUCT - nonlinear reconstruct block.
%
% BLK= simReconstruct(m,sname)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.4.4.3 $  $Date: 2004/02/09 07:39:40 $




% first add the relevant reconstruct block
blk= slRecon(m,sname);

% Calculate the parameter values.
dG= delG(m);
NTerms= size(dG,1);
[nl,NLTerm]= findnl(m,dG);
% nl is nonlinear parameter(s) 
% NLTerm is nonlinear response feature(s)
invDG = inv(dG);
% parameters calculated by linear reconstruction
LinTerms = setdiff([1:NTerms],nl);
% combine parameters into correct order
[P,recombine]= sort([LinTerms,nl]);

vars = {'invDG','LinTerms','NLTerm','NTerms','recombine'};
values = cell(5, 1);
values{1} = invDG;
values{2} = LinTerms;
values{3} = NLTerm;
values{4} = NTerms;
values{5} = recombine;

AddVariablesToUserdata(blk, vars, values);
