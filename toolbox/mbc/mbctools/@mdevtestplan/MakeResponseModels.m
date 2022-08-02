function T= MakeResponseModels(T,mbH)
%MAKERESPONSEMODELS Create models in testplan for response variables
%
%  MAKERESPNSEMODELS(T, MBH) creates modeldev nodes for each response model
%  defined in the testplan T.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.5.4.5 $  $Date: 2004/04/04 03:31:31 $

ShowProgress=  nargin>1 && mbH.GUIExists;

if ~isempty(T.Responses)

    if ShowProgress
        % lock model browser and make waitbar
        mbH.GUILocked= true;
        set(mbH.Figure,'pointer','watch')
        hWB= xregGui.waitdlg('parent',mbH.Figure);
        set(hWB.waitbar,'min',1,'max',length(T.Responses)+1);
        OldPtr= get(mbH.Figure,'pointer');
        set(mbH.Figure,'pointer','watch');
    end

    D= DataLink(T);

    [px,py]= dataptr(T);
    YTP= py.info;

    NStages= length(T.DesignDev);
    if NStages==1
        GUID= 'global';
        ms= 1;
    else
        GUID= 'twostage';
        ms= 0;
    end

    AllNames= get(D,'Name');
    DefModel= HSModel(T.DesignDev);

    for i=1:length(T.Responses);


        m= T.Responses{i};
        yi= yinfo(T.Responses{i});

        if nfactors(m)~=nfactors(DefModel);
            % use default model if number of factors has changed
            m= DefModel;
        else
            % copy model info
            m= copymodel(DefModel,m);
            m= yinfo(m,yi);
        end


        % can we find the response in data
        NewVar=0;
        if ~any( strcmp(yi.Name,AllNames) );
            NextResp= setdiff(AllNames,get(YTP,'name'));

            yi.Name= NextResp{1};
            NewVar= 1;
        end


        ssf= sweepsetfilter(py);
        YS= addVarsFilter(ssf,{yi.Name});

        % make new node
        mdev = modeldev(yi.Name,{m,px(1),YS,GUID});
        mdev = modelstage(mdev,ms);
        presp= address(mdev);
        % add to tree
        T= AddChild(T,mdev);
        mdev=info(mdev);
        % this makes sure that the names are unique
        mdev= name(mdev,name(mdev));
        if NewVar
            % bring up response dialog
            [mdev,OK]= gui_response(mdev);
            drawnow('expose');
            m= model(mdev);
            yi= yinfo(m);
            if ~OK
                T= info(delete(mdev));
                if strcmp(GUID,'twostage') && i==1 ...
                        && (get(m,'Datumtype')==1 || get(m,'Datumtype')==2)
                    % must do first datum
                    break
                else
                    % skip and go to next response
                    continue
                end
            end
        end

        if ~any( strcmp(yi.Name,get(YTP,'Name')) );
            % add variable to testplan data
            YTP= addVarsFilter(YTP,[get(YTP,'Name'); {yi.Name} ]);
            % update cache and assign back on heap
            YTP= setCacheState(YTP,true);
            py.info= YTP;
            ssf= sweepsetfilter(py);
            YS= addVarsFilter(ssf,{yi.Name});
            mdev= AssignData(mdev,'Y',YS);
        end

        if ShowProgress
            ID= mbH.addStatusMsg(['Building model for ',yi.Name,' ...']);
            hWB.message= ['Building model for ',yi.Name,' ...'];
            hWB.waitbar.value= i;
        end

        switch GUID
            case 'twostage'
                DatumType= get(m,'datumtype');
                if DatumType==3
                    % link to R1 datum
                    R1= children(T,1);
                    pdatum= R1.dataptr('data');
                    mdev= presp.AssignData('data',pdatum);
                end
                plocal= modeldev(m,presp);
                if plocal~=0
                    mdev = info(presp);
                    switch DatumType
                        case {1,2}
                            % connect datum link
                            pdatum= plocal.children(1);
                            mdev= AssignData(mdev,'data',pdatum);
                    end
                else
                    presp.delete;
                    presp= xregpointer;
                end
            case 'global'
                % fit onestage model
                try
                    % fit onestage model
                    presp.fitmodel;
                catch
                    % delete
                    presp.delete;
                    presp= xregpointer;
                end
        end

        % make sure we have the dynamic testplan
        if ShowProgress
            if presp~=0
                % add to treeview
                mbH.treeview(presp,'add');
            end
            mbH.removeStatusMsg(ID)
        end

        T= info(T);
    end % for i= 1:length(T.Responses)

    if ShowProgress
        hWB.waitbar.value= length(T.Responses)+1;
        set(mbH.Figure,'pointer',OldPtr);
        delete(hWB);
        mbH.GUILocked= false;
        set(mbH.Figure,'pointer',get(0,'DefaultFigurePointer'))
    end

    % clear the response models because of space considerations
    T.Responses=[];
    pointer(T);

else
    if ShowProgress
        % make a new node through dialog
        mbH.NewNode(address(T));
        T= info(T);
    end
end
