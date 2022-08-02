function presp=makechildren(T,OpenDialog);
%MDEVTESTPLAN/MAKECHILDRREN

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.2.4 $  $Date: 2004/02/09 08:07:57 $

if nargin<2
    OpenDialog=0;
end

presp=xregpointer;

if T.Matched    
    ptp= address(T);    
    D= DataLink(T);
    
    % data 
    Yind= get(D,'name');
    
    [X,Yptr]     = dataptr(T);
    
    [NewY,pdatum]= i_AddNew(T,Yind);
    
    % new response variable (default)
    if ~isempty(NewY)
        ssf= sweepsetfilter(Yptr);
        Y= addVarsFilter(ssf,NewY(1));
    else
        xregerror('New Response','No new response variables are available.');
        return
    end
    
    m = T.DesignDev(end).BaseModel;
    switch length(T.DesignDev)
        case 1
            % onestage model
            [T,presp] = i_MakeOneStage(T,X,Y,m);
        case 2
            % twostage model
            L     = T.DesignDev(1).BaseModel;
            [T,presp] = i_MakeTS(T,X,Y,L,m,pdatum);
        otherwise
            return
    end
    
    mdev= info(presp);
    
    ok= 1;
    if OpenDialog
        [mdev,ok]=gui_response(mdev);
        drawnow;
    end
    
    if ok
        presp=address(mdev);
        
        % set up local model ..??
        m= model(mdev);
        if isa(m,'xregtwostage')
            % set up more nodes
            TS=presp.model;
            % create local and global modeldev objects
            plocal= modeldev(TS,presp,0);
            if plocal==0
                %cancel condition met again
                delete(mdev);
                presp=xregpointer;
                return;
            else
                DatumType = get(get(TS,'local'),'DatumType');
            end
        else
            try
                % fit onestage model
                presp.fitmodel;
            catch
                xregerror('Model Fit Error'); 
                presp.delete;
                presp= xregpointer;
            end
        end
        presp.name(presp.varname);
    else
        delete(mdev);
        presp=xregpointer;
    end
    
else
    % no data is selected
    
    mbH= MBrowser;
    View= mbH.GetViewData;
    hData= findobj(allchild(0),'flat','tag','dataEditor','visible','on');
    if isempty(hData) 
        msgID= mbH.addStatusMsg('Data must be selected before creating a response model');
        
        hDOE= findobj(allchild(0),'flat','tag','DOEeditor','visible','on');
        if ~isempty(hDOE) 
            h= xregerror('Error','Data cannot be selected while the Design Editor is open.');
            waitfor(h);
            mbH.removeStatusMsg(msgID);
            return
        end
        
        % have to select some data first
        [T,OK] = datawizard(T);
        if OK
            mbH.ViewNode;
            mbH.listview;
        end
        presp= xregpointer;
        mbH.removeStatusMsg(msgID);
    else
        figure(hData)
    end
end



%------------------------------------------------
% SUBROUTINE i_MakeTS
%------------------------------------------------
function [T,presp]= i_MakeTS(T,X,Y,L,m,pdatum)

DatumType= get(L,'DatumType');

TS   = xregtwostage(L,m);
mdev = modeldev('TS',{TS,X(1),Y,'twostage'});
mdev = modelstage(mdev,0);
presp= address(mdev);

T= AddChild(T,mdev);

if DatumType==3
    mdev= AssignData(mdev,'data',pdatum);
end
return

%------------------------------------------------
% SUBROUTINE i_MakeOneStage
%------------------------------------------------
function [T,presp]= i_MakeOneStage(T,X,Y,m)

mdev = modeldev('model',{m,X,Y,'global'});
mdev = modelstage(mdev,1);
presp= address(mdev);

T= AddChild(T,mdev);
return


%------------------------------------------------
% SUBROUTINE i_ADDNEW
%------------------------------------------------
function [NewY,pdatum]= i_AddNew(T,Yind)

X= factors(T);

if numChildren(T)>0
    R1= children(T,1);
    Y= R1.dataptr('Y');
    pdatum= R1.dataptr('data');
    Existing= [children(T,'varname','Y')' ; X(:)];
else
    pdatum  = xregpointer;
    Existing= X(:);
end

NewY= setdiff(Yind,Existing);
