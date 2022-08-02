function mdev=UpdateLinks(mdev,varargin)
%UPDATELINKS Update dependent modeldev nodes
%
%  mdev=  UPDATELINKS(mdev,UpdateFlag,MBrowser);
%
%    UpdateFlags: 1 only update datumlinks
%                 2 update response feature models & datum links
%                 3 update covariance models 
%    MBrowser:    Handle to MBrowser object

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.4.4.6 $  $Date: 2004/04/04 03:31:12 $

if nargin<3 
	mbH = MBrowser;
    varargin{2}= mbH;
else
    mbH = varargin{2};
end

if mdev.IsLinearised
    % refit entire model
    [OK,mdev]= fitmodel(mdev);
else
    mdev= i_UpdateGTS(mdev,varargin{:});
end


if mbH.GUIExists && mbH.CurrentNode== address(mdev)
    %% switch off update toolbar button now we've done it!
    updateBut=find(mbH.GetViewData.toolbarBtns ,'tag','update');
    if ~isempty(updateBut)
        set(updateBut,'enable','off');
    end
end


function mdev= i_UpdateGTS(mdev,UpdateFlag,mbH)

ch = children(mdev);
if UpdateFlag==3
   % this is run if outliers have been selected
   L= model(mdev);
   if ~isempty(covmodel(L))
      % covariance model is not modified when outliers are assigned/restored
      mv_busy('Updating covariance models ...');
      [OK,mdev]= fitmodel(mdev);
   end
end
if UpdateFlag>=2
   mv_busy('Updating all response feature models ...');
	p= Parent(mdev);
	bm= peval('bestmdev',p);
	if bm==address(mdev)
		p.BestModel(xregpointer);
	end
	% this clears the status properly
	mdev= status(mdev,1,0);
   for i= 1:length(ch)
      % this may take a while for freeknot or rbf problems
      OK=ch(i).preorder('UpdateModel',1);
      % this should update tree icon
      if mbH.GUIExists
         mbH.doDrawTree(ch(i));
      end
   end
   if mbH.GUIExists
		mbH.doDrawText;
      mbH.doDrawTree(address(mdev));
		mbH.listview;
   end
end

pdatum= datumlink(mdev);
% update datum links
if length(ch)>0 && ch(1)==pdatum
   mv_busy('Datum points have changed');
   r=Parent(info(Parent(mdev)));
   prf= r.children;
   DatumMod=0;
   for i=2:length(prf)
      m= prf(i).model;
      if isa(m,'xregtwostage')
         dtype= get(m,'datumtype');
         if dtype==3 
            prf(i).AssignData('data',pdatum);
            DatumMod=1;
            mv_busy(['Updating response model for ',prf(i).name]);
            pl= prf(i).children;
            for j=1:length(pl)
					if UpdateFlag>=2
						% only update rfs if datumlink fit has changed
						pl(j).fitmodel;
						pl(j).children('preorder','UpdateModel',1);
					end
               % local model is no longer validated
               pl(j).BestModel(0);
               % update treeview icons
               if mbH.GUIExists
                  mbH.doDrawTree(pl(j));
                  mbH.doDrawTree(pl(j).children);
               end
            end  % for j
				prf(i).BestModel(xregpointer);
         end  % if dtype==3
      end % if isa
   end   % for i
end
mv_busy('delete');
