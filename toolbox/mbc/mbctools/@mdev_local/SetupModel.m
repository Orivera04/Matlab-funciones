function OK = SetupModel(mdev)
%SETUPMODEL  Open GUI for editing the model
%
%  OK = SETUPMODEL(MDEV)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.6.4.5 $  $Date: 2004/04/04 03:31:11 $

mbH= MBrowser;
p= address(mdev);
View= mbH.GetViewData;

L= model(mdev);
OldL= L;
xL= p.getdata('X');
[L,OK]= gui_localmodsetup(L,'figure',isEquiSpaced(xL)); 
if OK>1
    if OK==3
        resp= questdlg(['Changing the local model definition ',...
            'results in losing all sweep notes,',...
            'outliers and sub-model information. ',...
            'Do you want to continue?'],'Local Model Change',...
            'OK','Cancel','OK');
        if strcmp(resp,'Cancel')
            return
        end
    end
    OldMdev= p.info;
    p.clearmodels;
    mv_busy('Fitting local and global models');
    if OK==3
        TP = p.mdevtestplan;

        OldUpdate= View.Update;
        View.Update=0;
        mbH.SetViewData(View);

        mbH.GuiLocked= false;
        okH= mbH.SelectNode(xregpointer,1);
        mbH.GuiLocked= true;

        if ~okH
            xregpointer(OldMdev);

            % can't hide current node
            % so return to old node
            mv_busy('delete');
            OK=0;
            View.Update=OldUpdate;
            mbH.SetViewData(View);
            return
        end

        OldP= p;
        p= p.Parent;
        TSold= p.model;

        set(L,'DatumType',get(TSold,'DatumType'));
        m= model(TP);
        TS= xregtwostage(L,m);
        p.model(TS);
        % copy current outliers
        TSoutliers= p.outliers;
        p.outliers(OldP.outliers);

        ch= p.makechildren;
        % set old model and outliers back
        p.model(TSold);
        p.outliers(TSoutliers);

        if ch==0
            % model fit failed
            % reselect node
            xregpointer(OldMdev);
            mv_busy('delete');
            drawnow
            xregerror('Fit Error');
            mbH.SelectNode(OldP,1);
            OK=0;
            View.Update=OldUpdate;
            mbH.SetViewData(View);
            return
        end

        % remove old local model
        mbH.treeview(OldP,'remove');
        mbH.CurrentNode= xregpointer;
        p= OldP.delete;


        if ch.numChildren>0 && ismember(DatumType(L),1:2)
            % have to update datumlink
            pdatum= ch.children(1);
            p.AssignData('data',pdatum);
        end


        % now move back to local node
        p= ch;
        p.name(name(L));
        mbH.treeview(p,'add');

        % select node
        mbH.GUILocked=false;
        mbH.SelectNode(p);

        % we deleted the tree node so we need to reselect

    else
        OldUpdate= View.Update;
        try
            p.model(L);
            OK= p.fitmodel;
            % update status on global models
            p.children('preorder','fitmodel',1);
        catch
            xregpointer(OldMdev);
            mv_busy('delete');
            xregerror('Fit Error');
            View.Update=OldUpdate;
            mbH.SetViewData(View);
            p.model(OldL);
            return
        end

        % reset best model
        p.BestModel(0);
        p.status(1);
        % update treeview icons
        % hide and show needed
        mbH.RedrawNode;
        mbH.doDrawTree(p.children);
        mbH.ViewNode;

    end
    mv_busy('delete');
end
