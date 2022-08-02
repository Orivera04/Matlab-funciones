function [des,psi] = daugment(des,p,initpsi,DO_DESIGNTYPE)
%DAUGMENT D-optimally augment design
%
%  [D,PSI]=DAUGMENT(D,P,[INITPSI],[MODE]) augments the design D with P new
%  lines, in a d-optimal manner.  The optional INITPSI provides the
%  starting value of psi and saves it being calculated.  The optional MODE
%  can be set to 0 which will prevent design type information updates.  D
%  must pass a rankcheck else this routine will fail.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.4 $  $Date: 2004/04/04 03:26:43 $

mmdl=model(des);

fs=factorsettings(des);
mdls=get(mmdl,'models');
wts=get(mmdl,'weights');
nmdls=length(wts);

ri = cell(1,nmdls);
k = zeros(1, nmdls);
for n=nmdls:-1:1
    X=CalcJacob(mdls{n},fs);
    [Q, R]=qr(X,0);
    ri{n}=R\eye(size(R));
    ri{n}= chol(ri{n}*ri{n}');
    k(n)=NumTerms(mdls{n});
end

if nargin<3
    initpsi=dcalc(des);
end
if nargin<4
    DO_DESIGNTYPE=1;
end

% need to do different things depending on whether we are
% replacing or not
if allowreps(des)
    nc=ncand(des);
else
    nc=ncandleft(des);
end
nf=nfactors(des);

usewait=waitbars(des);
if usewait
    % prevent any nested waitbars
    des=waitbars(des,0);
    % gui feedback
    h=xregGui.waitdlg('title','MBC Toolbox','message',['Augmenting design: 0/' sprintf('%d',p) ' points added.']);
    h.waitbar.max=p;
end

if DO_DESIGNTYPE
    % need to remember start point
    [TP,INFO]= DesignType(des);
end

% test to see how big the matrices are going to be. If the final
% memory footprint is > ~20 Meg then we'll split into chunks (slower)

if nc*(nf+sum(k))<2.5e6;
    % get the whole candidate list in one go, don't need to keep doing x2fx
    if allowreps(des)
        lns=candidates(des,'constrained');
    else
        lns=candidates(des,'constrained','noreplacement');
    end
    % multiple biglns copies, unfortunately
    biglns=cell(1,nmdls);
    for n=1:nmdls
        biglns{n}=CalcJacob(mdls{n},lns)';
    end
    % get rid of lns - reclaim valuable memory
    clear lns

    for n=1:p
        if allowreps(des)
            coef = ones(nc,1);
        else
            coef = ones(nc+1-n,1);
        end
        for m=1:nmdls
            d= ri{m}*biglns{m};
            coef = coef.*(1+sum((d).^2)).^(wts(m)./k(m))';
        end

        [delta,i]=max(coef);

        % update stuff
        initpsi=initpsi+log(delta);

        if p>1
            for m=1:nmdls
                % recalc the necessary bits
                di=ri{m}*biglns{m}(:,i);
                ri{m}=cholupdate(ri{m},(ri{m}'*di)/sqrt(1+sum(di.^2)),'-');
                if ~allowreps(des)
                    % remove point from candidate list
                    biglns{m}(:,i)=[];
                end
            end
        end

        if ~allowreps(des)
            % update design object
            % i is the index into lns, not into the full candidate set...
            % lns is the (constrained) candidate set, minus the design points
            % therefore need to do a 'noreplacement' indexcand inside design/augment
            des=augment(des,i,'indexnorep');
        else
            des=augment(des,i,'index');
        end
        if usewait
            h.waitbar.value= n;
            h.message= sprintf('Augmenting design: %d/%d points added.',n,p);
        end
    end
    psi=initpsi;


else
    % chunks of 0.5e6./(nf+k) :-(
    chunksz=fix(0.5e6./(nf+sum(k)));
    nchunks=fix(nc./chunksz);
    % calculate leftover (last) chunk size
    lastchunksz=nc-(nchunks.*chunksz);
    % if the last chunk is too small then it may cause problems, so add it to the next-to-last
    if lastchunksz<p
        nchunks=nchunks-1;
        lastchunksz=chunksz+lastchunksz;
    end
    % design indices used if ~reps
    des_ind=designindex(des);

    reps=allowreps(des);

    for n=1:p
        mx=0;
        i=[];
        maxln=[];
        % basic index vector
        ind=1:chunksz;

        for m=1:nchunks
            if reps
                [lns,inds]=indexcand(des,((m-1).*chunksz)+ind);
            else
                [lns,inds]=indexcand(des,setxor(((m-1).*chunksz)+ind,intersect(((m-1).*chunksz)+ind,des_ind)));
            end

            coef = ones(size(lns,1),1);
            for l=1:nmdls
                biglns=CalcJacob(mdls{l},lns);
                d= ri{l}*biglns';
                coef = coef.*((1+sum((d).^2)).^(wts(l)./k(l)))';
            end
            [localmx,locali]=max(coef);
            if localmx>mx
                mx=localmx;
                i=inds(locali);
                maxln=lns(locali,:);
            end
            if usewait
                h.waitbar.value= n - 1 + m/(nchunks+1);
            end
        end
        % do last chunk
        if reps
            [lns,inds]=indexcand(des,((nc-lastchunksz+1):nc));
        else
            [lns,inds]=indexcand(des,setxor(((nc-lastchunksz+1):nc),intersect(((nc-lastchunksz+1):nc),des_ind)));
        end

        coef=ones(size(lns,1),1);
        for l=1:nmdls
            biglns=CalcJacob(mdls{l},lns);
            d= ri{l}*biglns';
            coef = coef.*(1+sum((d).^2)).^(wts(l)./k(l))';
        end
        [localmx,locali]=max(coef);
        if localmx>mx
            mx=localmx;
            i=inds(locali);
            maxln=lns(locali,:);
        end

        % update stuff
        initpsi=initpsi+log(mx);
        if p>1
            for l=1:nmdls
                bigmaxln=CalcJacob(mdls{l},maxln);
                % form correct d for updating
                di= ri{l}*bigmaxln';
                % update Ai for next iteration
                ri{l}= cholupdate(ri{l},(ri{l}'*di)/sqrt(1+sum(di.^2)),'-');
            end
        end
        des = augment(des,i,'absindex');

        if ~reps
            % reduce nc and the last chunk size
            nc = nc-1;
            lastchunksz = lastchunksz-1;
        end

        if usewait
            h.waitbar.value=n;
            h.message = sprintf('Augmenting design: %d/%d points added.',n,p);
        end
    end
    psi = initpsi;
end

if usewait
    delete(h);
    % turn waitbars back on
    des=waitbars(des,1);
end
if DO_DESIGNTYPE
    % update design type
    des=DesignType(des,TP,INFO);         % reset object to initial setting
    des=UpdateDesignType(des,'d');       % update type setting
end
