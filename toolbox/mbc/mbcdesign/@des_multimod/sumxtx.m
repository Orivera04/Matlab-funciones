function [s, nc]=sumxtx(des,ReCalc)
%SUMXTX Provide sum of x'x over entire candidate space
%
%  S=SUMXTX(D) sums X'X over all the candidate points.  Note that if the
%  candidate set is set to continuous then this will use some form of
%  continuous grid.
%  [S, N]=SUMXTX(D) will also return the number of points summed, N.
%  S will be a cell array containing the sum of X'X for each model
%  contained within the multimodel in D.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.5.2.4 $  $Date: 2004/04/04 03:26:44 $

if nargin==1
    ReCalc=0;
end

% nc is not used any more
nc=1;

% search store for a valid copy
if ~ReCalc && isfield(des.store,'K')
    % K depends on candidate sets
    if (des.store.K.candstate==candstate(des) && des.store.K.modelstate==modelstate(des))
        s=des.store.K.data;
        return
    end
end

% if design object is empty, put a dummy point in to make this work
if npoints(des)==0
    olddes=des;
    fudged=1;
    des=augment(des,zeros(1,nfactors(des)),'points');
else
    fudged=0;
end

% use only if no constraints
if numConstraints(des)==0
    s= i_RectGrid(des);
else
    s= i_CandSet(des);
end

if fudged
    % put back olddes for storing the result
    des=olddes;
end

% store result
des.store.K.data=s;
des.store.K.designstate=designstate(des);
des.store.K.candstate=candstate(des);
des.store.K.modelstate=modelstate(des);

nm=inputname(1);
assignin('caller',nm,des);


return


function [s,nc]=i_CandSet(des)
% This sub-function uses the entire candidate set to calculate
%  s= X'*X. It can be slow

nc=ncand(des);
if isinf(nc)
    % choose suitably large number
    nc=300000;
end


% number of points to do simultaneously
% 10,000 points equates to about 1.5Mb peak memory usage - not too large at all
np=10000;
nd= 500;

niter=floor(nc./np);
nover=rem(nc,np);

Lsel1= 1:np;

nnd= floor(np/nd);
nnv= nnd*nd+1;
Lsel2= 1:nd;
mmdl=model(des);
mdls = get(mmdl,'models');
nmdls = length(mmdl);

usewait=waitbars(des) & (nmdls+niter)>1;
if usewait
    % prevent any nested waitbars
    des=waitbars(des,0);
    % gui feedback
    h=xregGui.waitdlg('message','Calculating.  Please Wait...');
end

% calc s for each model
s=cell(1,nmdls);
for m=1:nmdls
    stmp=zeros(NumTerms(mdls{m})) ;
    for n=1:niter
        lns=indexcand(des,(Lsel1+(n-1)*np));
        biglns=CalcJacob(mdls{m},lns);

        % The following mex function does s=s+(biglns'*biglns);
        % without forming transpose and taking advantage of symmetry
        % It seems to be faster to split up this call
        for i=1:nnd
            stmp=mx_r1update(stmp,biglns(Lsel2+(i-1)*nd,:));
        end
        if nnv<np
            stmp=mx_r1update(stmp,biglns(nnv:end,:));
        end

        if usewait
            h.waitbar.value= (m-1)/nmdls + n/(nmdls*(niter+1));
        end
    end
    if nover
        % leftover points
        lns=indexcand(des,((1:nover)+(niter).*np));
        biglns=CalcJacob(mdls{m},lns);
        stmp=mx_r1update(stmp,biglns(:,:));
    end

    s{m}= stmp/nc;
    if usewait
        h.waitbar.value= (m/nmdls);
    end
end
if usewait
    des=waitbars(des,1);
    delete(h);
end



function [s,nc]= i_RectGrid(des)
% this sub function uses quadrature over [-1,1] grid

nc=1;
mmdl=model(des);
mdls = get(mmdl,'models');
nmdls = length(mmdl);
% calc s for each model
s=cell(1,nmdls);
fs=factorsettings(des);
usewait=waitbars(des) & nmdls>1;
if usewait
    % prevent any nested waitbars
    des=waitbars(des,0);
    % gui feedback
    h = xregGui.waitdlg('message', 'Calculating.  Please Wait...');
end
for m=1:nmdls
    [pev,s{m}]= MeanPredVar(InitStore(mdls{m},fs));
    if usewait
        h.waitbar.value = m/nmdls;
    end
end
if usewait
    des=waitbars(des,1);
    delete(h);
end
