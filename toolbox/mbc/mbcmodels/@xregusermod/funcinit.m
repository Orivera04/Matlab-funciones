function U=funcinit(U,fname);
% xregusermod/FUNCINIT initialise user defined model defined by 'fname.m'

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:01:10 $
if ischar(fname)
    fname= str2func(fname);
end
U.funcName=fname;
U.parameters= initial(U);
nf= nfactors(U);
if nfactors(U.xregmodel)~= nf
   U.xregmodel= xregmodel('nfactors',nf);
end

np= feval(U.funcName,U,'numparams');
if np~=length(double(U))
	error(['Incorrect number of parameters specified in ',U.funcName,' (i_initial) or (i_numparams)'])
end