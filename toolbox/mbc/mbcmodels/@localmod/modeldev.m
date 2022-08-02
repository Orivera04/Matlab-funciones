function prf= modeldev(L,p_mdev,OpenDialog);
% LOCALMOD/MODELDEV creates new MODELDEV object for a Response Feature Model
%
% pm= modeldev(m,p_mdev);
%   Used for creating children of localmods

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.4.4.4 $  $Date: 2004/02/09 07:39:25 $



% Add Feature
L= AddFeat(L,zeros(1,nfactors(L)),length(features(L)));
if nargin==3 & OpenDialog
   [L,OK]= gui_respfeat(L,numfeats(L));
   if ~OK
      prf= xregpointer;
      return
   end
end




Name= RespFeatName(L);

if ~any(strcmp(Name{end},Name(1:end-1)))
    % check that response feature doesn't already exist
    
    % update localmod in project
    p_mdev.model(L);
    
    % get Xglobal 
    TP= p_mdev.mdevtestplan;
    X= dataptr(TP,'X');
    Xglobal= X(end);
    % Base Model
    m= model(TP);
    
    yi= yinfo(m);
    xlu= units(L);
    isDatumRF= get(L,'isdatum');
    
    yi.Name  = Name{end};
    yi.Symbol= Name{end};
    if isDatumRF(end)
        % datum model 
        yi.Units = xlu{1};
    else
        yi.Units = junit;
    end
    m= yinfo(m,yi);
    
    
    
    
    % Call MODELDEV constructor.
    mdev= modeldev(Name{end},{m,Xglobal,xregpointer,'global'});
    mdev=modelstage(mdev,2);
    
    
    prf= address(mdev);
    
    % Add new RF to tree 
    p_mdev.AddChild(prf.info);
    
    prf.name(Name{end});
    
    % % add new rf data 
    
    pD= p_mdev.RFData;
    % add variable to response feature sweepset
    D= pD.info;
    % make new variable
    S= sweepset('Variable', 1 , '%g' , prf.name , 'Response Feature'  , junit , 'none' ,zeros(size(D,1),1) );
    if isempty(find(D, get(S,'name')))
        pD.info= [D S];
        rfname= get(pD.info,'name');
    else
        rfname= get(S,'name');
    end
    % rf Y data is a sweepset filter
    ssf= sweepsetfilter(pD);
    ssf= addVarsFilter(ssf,rfname(end));
    prf.AssignData('Y',ssf);
    
    
    
    % Have to fit Local Model again to calculate new RF
    p_mdev.Change_RespFeat(numfeats(L),L);
    
    try
        % fit new Response Feature Model
        prf.fitmodel;
    catch
        prf.status(0);
    end
else
    % already exists
    prf= xregpointer;
    if OpenDialog
        hFig=msgbox(['The response feature ',Name{end},' already exists. An alternative global model can be constructed by creating submodels.'],'Response Feature Setup','modal') ;
        uiwait(hFig);
    end
end
    
