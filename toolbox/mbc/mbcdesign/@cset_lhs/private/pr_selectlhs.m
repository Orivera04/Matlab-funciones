function inds=pr_selectlhs(obj,N,nf,tpflg,meth,optimmeth,guiflag,nperms,strat,strat_lvls,doSymmetry)
%PR_SELECTLHS  Select a Latin Hypercube
%
%  INDS=PR_SELECTLHS(N,nf,tpflg,costmeth,optimmeth,GUIFLAG,Nperms,stratify)
%  creates nf sets of permutations for the latin hypercube sampling
%  candidate set.  tpflg is 0/1/2/3 corresponding to UINT8/16/32/double for
%  the indices. optimmeth parameter is currently ignored (only 'random'
%  allowed)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.5.2.3 $  $Date: 2004/04/04 03:26:36 $


% permutations are created here, then discrepancy checks are done
% in mex function.  The one with lowest variance is chosen.  The random
% seeds used for each permutation are saved and then used to recreate
% the permutation indices.

if nargin<8
    strat=zeros(1,nf);
end
if nargin<7
    nperms=500;
end
if nargin<6
    guiflag=0;
end

vars=0;
randst=zeros(35,1);
% initialise inds
switch tpflg
    case {0,1,2}
        inds=mx_zeros(N,nf,tpflg);
    case 3
        inds=zeros(N,nf);
end

% reset random generator
rnd=sum(100*clock);
rand('state',rnd);
minrandst=zeros(35,1);

% decide which subfunc to use for generating points
if any(strat)
    genfunc=@i_geninds_strat;
elseif doSymmetry
    genfunc=@i_geninds_sym;
else
    genfunc=@i_geninds;
end

if guiflag
    % create a waitbar
    h=xregGui.waitdlg('message','Selecting Latin Hypercube.  Please wait...');
    h.waitbar.max=nperms;
    drawnow;
    % work out divisor to make sure we don't do too many waitbar calls
    Nperbar=floor(nperms/100);
    Nperbar_counter=0;
end

switch lower(meth)
    case 'discrepancy'
        ndiscrep_boxes = 100+20*nf;
        discrep_frac=0.2;
        % width of box
        discrep_width = floor(discrep_frac*N);

        minvar=inf;
        for n=1:nperms
            % initialise random state
            [inds,randst]=feval(genfunc,inds,N,nf,strat);
            vars=qdiscrep(obj,inds,ndiscrep_boxes,discrep_width);
            if vars<minvar
                minvar=vars;
                minrandst=randst;
            end
            if guiflag
                if Nperbar_counter>=Nperbar
                    h.waitbar.value=n;
                    drawnow;
                    Nperbar_counter=0;
                else
                    Nperbar_counter=Nperbar_counter+1;
                end
            end
        end

    case 'minimax'
        minvar=inf;
        for n=1:nperms
            % initialise random state
            [inds,randst]=feval(genfunc,inds,N,nf,strat,strat_lvls);
            vars= qmaxdist(obj,inds);             % mx_distance in max distance mode
            if vars<minvar
                minvar=vars;
                minrandst=randst;
            end
            if guiflag
                if Nperbar_counter>=Nperbar
                    h.waitbar.value=n;
                    drawnow;
                    Nperbar_counter=0;
                else
                    Nperbar_counter=Nperbar_counter+1;
                end
            end
        end

    case 'maximin'
        minvar=-1;
        for n=1:nperms
            % initialise random state
            [inds,randst]=feval(genfunc,inds,N,nf,strat,strat_lvls);
            vars= qmindist(obj,inds);             % mx_distance in min distance mode
            if vars>minvar
                minvar=vars;
                minrandst=randst;
            end
            if guiflag
                if Nperbar_counter>=Nperbar
                    h.waitbar.value=n;
                    drawnow;
                    Nperbar_counter=0;
                else
                    Nperbar_counter=Nperbar_counter+1;
                end
            end
        end

    case 'cdfvariance'
        minvar=inf;
        for n=1:nperms
            % initialise random state
            [inds,randst]=feval(genfunc,inds,N,nf,strat,strat_lvls);
            vars= qcdfvar(obj,inds);
            if vars<minvar
                minvar=vars;
                minrandst=randst;
            end
            if guiflag
                if Nperbar_counter>=Nperbar
                    h.waitbar.value=n;
                    drawnow;
                    Nperbar_counter=0;
                else
                    Nperbar_counter=Nperbar_counter+1;
                end
            end
        end
    case 'cdfmaximum'
        minvar=inf;
        for n=1:nperms
            % initialise random state
            [inds,randst]=feval(genfunc,inds,N,nf,strat,strat_lvls);
            vars= qmaxcdfvar(obj,inds);
            if vars<minvar
                minvar=vars;
                minrandst=randst;
            end
            if guiflag
                if Nperbar_counter>=Nperbar
                    h.waitbar.value=n;
                    drawnow;
                    Nperbar_counter=0;
                else
                    Nperbar_counter=Nperbar_counter+1;
                end
            end
        end
    otherwise
        error('Unrecognised LHS selection method!');
end

if any(minrandst)
    % reconstruct best indices
    rand('state',minrandst);
    inds=feval(genfunc,inds,N,nf,strat,strat_lvls);
else
    warning('Failure in LHS selection algorithm');
end
if guiflag
    delete(h);
end


function [inds,rnd]=i_geninds(inds,N,nf,strat,strat_lvls)
rnd=rand('state');
% initialise random state
for m=1:nf
    inds(:,m)=randperm(N)';
end


function [inds,rnd]=i_geninds_strat(inds,N,nf,strat,strat_lvls)
rnd=rand('state');
% initialise random state
for m=1:nf
    tmp=randperm(N)';
    if strat(m)
        if strat(m)==-1
            % use the specified levels
            Nstrat = length(strat_lvls{m});
            tmp = (ceil(((Nstrat).*tmp./N)));   % Nstrat stratified levels in 1--> Nstrat region
            tmp = strat_lvls{m}(tmp);           % index into the 1--->N domain
            tmp = tmp(:);
        else
            tmp=((N-1).*(ceil(((strat(m)).*tmp./N))-1)./(strat(m)-1))+1;
        end
    end
    inds(:,m)=tmp;
end


function [inds,rnd]=i_geninds_sym(inds,N,nf,strat,strat_lvls)
rnd=rand('state');
halfN=floor(N/2);
if (halfN)==(N/2)
    for m=1:nf
        inds(:,m)=i_symrandperm(N)';
    end
else
    for m=1:nf
        tmp=i_symrandperm(N)';
        inds(1:halfN,m)=tmp(1:halfN);
        inds((halfN+2):end,m)=tmp(halfN+1:end);
        inds(halfN+1,m)=halfN+1;
    end
end


function vect=i_symrandperm(N)
% generate a random permutation with forced symmetry, for i_geninds_sym
% ONLY WORKS FOR N=EVEN

halfN=floor(N/2);
vect=rand(1,halfN);
[nul,vect]=sort([vect 1-vect(end:-1:1)]);
