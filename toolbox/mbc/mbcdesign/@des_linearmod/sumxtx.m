function [s, nc]=sumxtx(smod,ReCalc)
%SUMXTX Provide sum of x'x over entire candidate space
%
%  S=SUMXTX(D) sums X'X over all the candidate points Note that if th
%  candiddate set is set to continuous then this will use some form of
%  continuous grid. [S, N]=SUMXTX(D) will also return the number of points
%  summed, N.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.5.2.4 $  $Date: 2004/04/04 03:26:40 $

if nargin==1
    ReCalc=0;
end

% nc is not used any more
nc=1;

% search store for a valid copy
if ~ReCalc & isfield(smod.store,'K')
    % K depends on candidate sets
    if (smod.store.K.candstate==candstate(smod) & smod.store.K.modelstate==modelstate(smod))
        s=smod.store.K.data;
        return
    end
end

% if design object is empty, put a dummy point in to make this work
if npoints(smod)==0
    oldsmod=smod;
    fudged=1;
    smod=augment(smod,zeros(1,nfactors(smod)),'points');
else
    fudged=0;
end

% use only if no constraints
if numConstraints(smod)==0
    s= i_RectGrid(smod);
else
    s= i_CandSet(smod);
end

if fudged
    % put back oldsmod for storing the result
    smod=oldsmod;
end

% store result
smod.store.K.data=s;
smod.store.K.designstate=designstate(smod);
smod.store.K.candstate=candstate(smod);
smod.store.K.modelstate=modelstate(smod);

nm=inputname(1);
assignin('caller',nm,smod);


return


function [s,nc]=i_CandSet(smod);
% This sub-function uses the entire candidate set to calculate
%  s= X'*X. It can be slow

nc=ncand(smod);
if isinf(nc)
    % choose suitably large number
    nc=300000;
end

usewait=(waitbars(smod) & (nc*nfactors(smod))>50000);

if usewait
    % prevent any nested waitbars
    smod=waitbars(smod,0);
    % gui feedback
    h=xregGui.waitdlg('title','MBC Toolbox','message','Calculating.  Please wait...');
end
mdl=model(smod);

% number of points to do simultaneously
% 10,000 points equates to about 1.5Mb peak memory usage
np=10000;
nd= 500;

niter=floor(nc./np);
nover=rem(nc,np);
s=zeros(NumTerms(mdl)) ;
Lsel1= 1:np;

nnd= floor(np/nd);
nnv= nnd*nd+1;
Lsel2= 1:nd;
if usewait
    h.Waitbar.Max=niter*(nnd+1)+1;
end
for n=1:niter
    lns=indexcand(smod,(Lsel1+(n-1)*np));
    biglns=CalcJacob(mdl,lns);

    % The following mex function does s=s+(biglns'*biglns);
    % without forming transpose and taking advantage of symmetry
    %s=mx_r1update(s,biglns(:,t));

    % It seems to be faster to split up this call
    for i=1:nnd
        s=mx_r1update(s,biglns(Lsel2+(i-1)*nd,:));
        if usewait
            h.waitbar.value= h.waitbar.value+1;
        end
    end
    if nnv<np
        s=mx_r1update(s,biglns(nnv:end,:));
    end
    if usewait
        h.waitbar.value= h.waitbar.value+1;
    end
end
% leftover points
if nover
    lns=indexcand(smod,((1:nover)+(niter).*np));
    biglns=CalcJacob(mdl,lns);
    s=mx_r1update(s,biglns(:,:));
end
if usewait
    h.waitbar.value= h.waitbar.value+1;
end

s= s/nc;
% s=s+(biglns'*biglns);
% s=s+tril(s,-1)';
if usewait
    delete(h);
    % turn waitbars back on
    smod=waitbars(smod,1);
end


function [s,nc]= i_RectGrid(smod);
% this sub function uses quadrature over [-1,1] grid

mdl=model(smod);
nc=1;
ord= get(mdl,'order');
if any(ord>3) | size(mdl,1).*prod(ord+1) > 10e6
    [s,nc]=i_CandSet(smod);
else
    mdl= InitStore(mdl,factorsettings(smod));
    [pev,s]= MeanPredVar(mdl);
end
