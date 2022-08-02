function [smod,psi]=aaugment(smod, p, initpsi,DO_DESIGNTYPE)
%AAUGMENT A-optimally augment design
%
%  [D,PSI]=AAUGMENT(D,P,[INITPSI],[MODE]) augments the design D with P new
%  lines, in an a-optimal manner.  The optional INITPSI provides the
%  starting value of psi and saves it being calculated.  The optional MODE
%  can be set to 0 which will prevent design type information updates.  D
%  must pass a rankcheck else this routine will fail.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.4 $  $Date: 2004/04/04 03:26:38 $

if nargin<4
    DO_DESIGNTYPE=1;
end
if nargin<3
    initpsi=acalc(smod);
end

mdl=model(smod);
% Initial Ai must be for all points.  It is then iteratively
% updated and hence is always correctly derived from all points.
X=CalcJacob(mdl,factorsettings(smod));

[Q,R]= qr(X,0);
ri= R\eye(size(R));

Ai=ri*ri';

% X used for augmentation search is taken from the candidate set

% need to do different things depending on whether we are
% replacing or not
if allowreps(smod)
    nc=ncand(smod);
else
    nc=ncandleft(smod);
end
k=NumTerms(mdl);
nf=nfactors(smod);

% test to see how big the matrices are going to be. If the final
% memory footprint is >20 Meg then we'll split into chunks (slower)

usewait=waitbars(smod);
if usewait
    % prevent any nested waitbars
    smod=waitbars(smod,0);
    % gui feedback
    h=xregGui.waitdlg('title','MBC Toolbox','message',['Augmenting design: 0/' sprintf('%d',p) ' points added.']);
    h.waitbar.max=p;
end

if DO_DESIGNTYPE
    % need to remember start point
    [TP,INFO]= DesignType(smod);
end

if nc*(nf+k)<2.5e6;
    % get the whole candidate list in one go, don't need to keep doing x2fx
    if allowreps(smod)
        lns=candidates(smod,'constrained');
    else
        lns=candidates(smod,'constrained','noreplacement');
    end
    biglns=CalcJacob(mdl,lns);

    for n=1:p
        % quick way
        B= biglns*Ai;
        div=(1+sum(B.*biglns,2));

        Bi=sum( B.*B,2 );
        div=max(div,Bi*eps*2);

        [delpsi,i]=max(Bi./div);
        initpsi=initpsi-delpsi;
        if p>1
            % Update Ai
            Ai= mx_r1update(Ai,B(i,:)/sqrt(div(i)),1);
        end
        if ~allowreps(smod)
            % update design object
            % i is the index into lns, not into the full candidate set...
            % lns is the (constrained) candidate set, minus the design points
            % therefore need to do a 'noreplacement' indexcand inside design/augment
            smod=augment(smod,i,'indexnorep');
            % remove the added point from the list of options
            biglns(i,:)=[];
        else
            smod=augment(smod,i,'index');
        end
        if usewait
            h.waitbar.value=n;
            h.message=sprintf('Augmenting design: %d/%d points added.',n,p);
        end
    end
    psi=initpsi;

else
    % chunks of 0.5e6./(nf+k) :-(
    chunksz=fix(0.5e6./(nf+k));
    nchunks=fix(nc./chunksz);
    % calculate leftover (last) chunk size
    lastchunksz=nc-(nchunks.*chunksz);
    % if the last chunk is too small then it may cause problems, so add it to the next-to-last
    if lastchunksz<p
        nchunks=nchunks-1;
        lastchunksz=chunksz+lastchunksz;
    end
    % design indices used if ~reps
    des_ind=designindex(smod);

    reps=allowreps(smod);

    for n=1:p
        mx=0;
        i=[];
        maxln=[];
        maxdiv=[];
        % basic index vector
        ind=1:chunksz;

        for m=1:nchunks
            if reps
                [lns,inds]=indexcand(smod,((m-1).*chunksz)+ind);
            else
                [lns,inds]=indexcand(smod,setxor(((m-1).*chunksz)+ind,intersect(((m-1).*chunksz)+ind,des_ind)));
            end
            biglns=CalcJacob(mdl,lns);
            B= biglns*Ai;
            div=(1+sum(B.*biglns,2));

            Bi=sum( B.*B,2 );
            div=max(div,Bi*eps*2);

            [localmx,locali]=max(Bi./div);

            if localmx>mx
                mx=localmx;
                i = inds(locali);
                maxln=biglns(locali,:);
                maxdiv=div(locali);
            end
            if usewait
                h.waitbar.value=(n-1)+m/(nchunks+1);
            end
        end
        % do last chunk
        if reps
            [lns,inds]=indexcand(smod,((nc-lastchunksz+1):nc));
        else
            [lns,inds]=indexcand(smod,setxor(((nc-lastchunksz+1):nc),intersect(((nc-lastchunksz+1):nc),des_ind)));
        end
        biglns=CalcJacob(mdl,lns);
        B= biglns*Ai;
        div=(1+sum(B.*biglns,2));

        Bi=sum( B.*B,2 );
        div=max(div,Bi*eps*2);

        [localmx,locali]=max(Bi./div);
        if localmx>mx
            mx=localmx;
            i=inds(locali);
            maxln=biglns(locali,:);
            maxdiv=div(locali);
        end


        % update stuff
        initpsi=initpsi-mx;
        if p>1
            % form appropriate B, etc
            B=maxln*Ai;
            % Update Ai
            Ai= mx_r1update(Ai,B/sqrt(maxdiv),1);
        end
        smod = augment(smod,i,'absindex');

        if ~reps
            % reduce nc and the last chunk size
            nc = nc-1;
            lastchunksz = lastchunksz-1;
        end
        if usewait
            h.waitbar.value=n;
            h.message= sprintf('Augmenting design: %d/%d points added.',n,p);
        end
    end
    psi = initpsi;
end

if usewait
    delete(h);
    % turn waitbars back on
    smod=waitbars(smod,1);
end
if DO_DESIGNTYPE
    % update design type
    smod=DesignType(smod,TP,INFO);         % reset object to initial setting
    smod=UpdateDesignType(smod,'a');       % update type setting
end
