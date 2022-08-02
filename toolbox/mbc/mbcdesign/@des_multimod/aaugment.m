function [des,psi]=aaugment(des,p,initpsi,DO_DESIGNTYPE)
%AAUGMENT A-optimally augment design
%
%  [D,PSI]=AAUGMENT(D,P,[INITPSI],[MODE]) augments the design D with P new
%  lines, in a a-optimal manner.  The optional INITPSI provides the
%  starting value of psi and saves it being calculated.  The optional MODE
%  can be set to 0 which will prevent design type information updates.  D
%  must pass a rankcheck else this routine will fail.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.4 $  $Date: 2004/04/04 03:26:42 $

if nargin<3
    initpsi=acalc(des);
end
if nargin<4
    DO_DESIGNTYPE=1;
end

mmdl=model(des);
fs=factorsettings(des);
mdls=get(mmdl,'models');
wts=get(mmdl,'weights');
nmdls=length(wts);

% Initial Ai must be for all points.  It is then iteratively
% updated and hence is always correctly derived from all points.
Ai = cell(1, nmdls);
k = zeros(1, nmdls);
for n=1:nmdls
    X=CalcJacob(mdls{n},fs);
    [Q,R]= qr(X,0);
    ri= R\eye(size(R));
    Ai{n}=ri*ri';
    k(n)=NumTerms(mdls{n});
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
% memory footprint is >20 Meg then we'll split into chunks (slower)
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
        biglns{n}=CalcJacob(mdls{n},lns);
    end

    for n=1:p
        % quick way
        psiupd = zeros(nc,1);
        for m=1:nmdls
            % build up div as weighted sum
            % quick way
            B= biglns{m}*Ai{m};
            div=(1+sum(B.*biglns{m},2));

            Bi=wts(m).*sum( B.*B,2 );
            % check div isn't 0!!
            div=max(div,Bi*eps*2);
            % form output vector
            psiupd = psiupd + Bi./div;
        end

        [psiupd,i]=max(psiupd);
        initpsi=initpsi-psiupd;

        if p>1
            for m=1:nmdls
                % Update Ai
                Bi=biglns{m}(i,:)*Ai{m};
                divi=(1+sum(Bi.*biglns{m}(i,:),2));
                Ai{m}= mx_r1update(Ai{m},Bi/sqrt(divi),1);
            end
        end

        if ~allowreps(des)
            % update design object
            % i is the index into lns, not into the full candidate set...
            % lns is the (constrained) candidate set, minus the design points
            % therefore need to do a 'noreplacement' indexcand inside design/augment
            des=augment(des,i,'indexnorep');
            % remove the added point from the list of options
            for m=1:nmdls
                biglns{m}(i,:)=[];
            end
            nc=nc-1;
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
    chunksz=fix(0.5e6./(nf+max(k)));
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

            psiupd=zeros(size(lns,1),1);
            for l=1:nmdls
                biglns=CalcJacob(mdls{l},lns);
                B= biglns*Ai{l};
                div=(1+sum(B.*biglns,2));
                Bi=wts(l).*sum( B.*B,2 );
                div=max(div,Bi*eps*2);

                psiupd=psiupd+Bi./div;
            end

            [localmx,locali]=max(psiupd);

            if localmx>mx
                mx=localmx;
                i = inds(locali);
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

        psiupd=zeros(size(lns,1),1);
        for l=1:nmdls
            biglns=CalcJacob(mdls{l},lns);
            B= biglns*Ai{l};
            div=(1+sum(B.*biglns,2));
            Bi=wts(l).*sum( B.*B,2 );
            div=max(div,Bi*eps*2);

            psiupd=psiupd+Bi./div;
        end

        [localmx,locali]=max(psiupd);

        if localmx>mx
            mx=localmx;
            i=inds(locali);
            maxln=lns(locali,:);
        end

        % update stuff
        initpsi=initpsi-mx;

        if p>1
            % form appropriate B, etc
            for l=1:nmdls
                bigln=CalcJacob(mdls{l},maxln);
                Bi=bigln*Ai{l};
                divi=wts(l).*(1+sum(Bi.*bigln,2));
                % Update Ai
                Ai{l}= mx_r1update(Ai{l},Bi/sqrt(divi),1);
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
    des=UpdateDesignType(des,'v');       % update type setting
end
