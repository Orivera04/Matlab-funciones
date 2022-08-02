function plocal= modeldev(TS,p_mdev,OpenDialog)
%MODELDEV Create a full tree of MODELDEV objects
%
%  pm = MODELDEV(TS,p_mdev) is used for creating the full modeldev tree
%  with children of the twostage response model TS.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.6.2.5 $  $Date: 2004/02/09 08:00:01 $


if nargin<3
    OpenDialog = 0;
end
xL= getdata(p_mdev.info,'X');

L= get(TS,'local');

if OpenDialog
    [L,OK]= gui_localmodsetup(L,'figure',isEquiSpaced(xL(:,1)),nfactors(L));
    TS=set(TS,'local',L);
    if OK==3
        % get default global model from testplan
        GM= model(p_mdev.mdevtestplan);
        % model type or num response features have changed
        TS= xregtwostage(L,GM);
    end
    % force removal from screen
    drawnow('expose');
    if ~OK
        plocal= xregpointer;
        return
    end
end

if DatumType(L) && ~is121(L)
    % turn off coding for local
    [Bnds,g,Tgt]= getcode(L);
    Tgt(:,2)= Inf;
    L= setcode(L,Bnds,g,Tgt);
    TS=set(TS,'local',L);
end

% get XLocal,Xglobal,Y
tp= p_mdev.mdevtestplan;
Xglobal    = dataptr(tp,'X');
Xglobal    = Xglobal(end);

% local dept and response data pointers
[Xlocal,Y] = dataptr(p_mdev.info);

Xptr= dataptr(tp,'X');
XGlobal= Xptr(2);

nrf = length(TS.Global);
% degrees of freedom
% nf*ns - p - numDispersionParams
% df= nrf*size(XGlobal.info,1) - numParams(TS) - nc - length(covmodel(L));
df = nrf*size(XGlobal.info,1) - numParams(TS) ;

if df<=0 && OpenDialog && ~isa(L,'localmulti') && ~isa(L,'localavfit')
    % not enough df to form twostage model
    resp= questdlg(sprintf(['There is not enough data available to calculate the maximum likelihood estimate for ',...
        'this hierarchical model. Note stepwise or center selection may increase the available degrees of freedom.\n\n',...
        'Do you wish to continue?']),'Local Model Setup Warning','Yes','No','No') ;
    if strcmp(resp,'No')
        plocal= xregpointer;
        return
    end
end


% MDEV_LOCAL node for local regression
md_loc= mdev_local(name(L),{L,Xptr(1),Y,'local'});

% copy outlisers to new node
outliers(md_loc,p_mdev.outliers);

plocal= address(md_loc);
md_loc= info(plocal);


if p_mdev.numChildren==0
    % make twostage model at response level
    p_mdev.model(TS);
end
% Add to tree
p_mdev.AddChild(md_loc);

m=[];
if length(TS.Global)>1
    m= TS.Global{1};
elseif isa(TS.datum,'xregmodel')
    m= TS.datum;
end

if isa(m,'xregmodel')
    yi= yinfo(m);
end



xlu= units(L);
YUNITS= {};
Yrf= xregpointer;
if RFstart(L)>0
    % An extra response feature is needed if the datum model is
    % not a response feature (currently used for polynom)

    % allocate dynamic memory for RF data
    % Make DATUM modeldev object

    m= get(TS,'datum');
    yi.Name  = 'Datum';
    yi.Symbol= 'Datum';
    yi.Units = xlu{1};

    YUNITS= [YUNITS  xlu];

    m= yinfo(m,yi);

    mdev_rf= modeldev('DATUM',{m,Xglobal,Yrf,'global'});
    mdev_rf= modelstage(mdev_rf,2);
    % RF is child of local
    plocal.AddChild(mdev_rf);

end


rfnames= RespFeatName(L);
isDatumRF= get(L,'isdatum');
GM= get(TS,'Global');
% make global models for response features
for j= 1:length(rfnames)
    % allocate memory for rf data
    % make RF modeldev object (4
    m= GM{j};
    yi.Name  = rfnames{j};
    yi.Symbol= rfnames{j};
    if ~isDatumRF(j)
        xlu={junit};
    end
    yi.Units = xlu{1};
    YUNITS= [YUNITS  xlu];

    m= yinfo(m,yi);

    mdev_rf= modeldev(rfnames{j},{m,Xglobal,Yrf,'global'});
    mdev_rf= modelstage(mdev_rf,2);
    % RF is child of local
    plocal.AddChild(mdev_rf);
    % update model info
end

% make rf data
XG= XGlobal.info;
Names=plocal.children('name');
S= sweepset('Variable', 1 , '%g' , Names , 'Response Feature'  , YUNITS , 'none' , zeros(size(XG,1),length(Names)) );
D= [XG(:,~1) S];
pD=xregpointer(D);
plocal.RFData(pD);
prf= plocal.children;
for i=1:plocal.numChildren
    ssf= sweepsetfilter(pD);
    ssf= addVarsFilter(ssf,get(S(:,i),'name'));
    prf(i).AssignData('Y',ssf);
end


if OpenDialog
    mv_busy(['Making local and global models for ',name(L)]);
end
try
    % fit all models (local + RF)
    plocal.preorder('fitmodel');
catch
    % fit failed so delete and return a null pointer
    if OpenDialog
        mv_busy('delete')
        drawnow('expose');
    end
    xregerror('Fit Error');
    plocal.delete;
    plocal= xregpointer;
end
