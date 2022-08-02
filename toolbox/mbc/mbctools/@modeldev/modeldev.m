function mdev= modeldev(Name,ModelInfo);
% MODELDEV general model development
% 
%  mdev= modeldev(Name,{m,X,Y,3});
%
%  modeldev is a child of tree.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.4.4.2 $  $Date: 2004/02/09 08:10:39 $



loadstr=0;

p0=xregpointer;
if nargin==0
   Name= 'Model 1';
   ModelInfo= {xregcubic;struct('ptr',p0,'index',[]);struct('ptr',p0,'index',[]);'modeldev'};
   loadstr=1;
end
if nargin==1 & isa(Name,'struct')
   mdev= Name;
   
   if  mdev.Version==0
      mdev.Version=1;
      Name= mdev.Name;
      if isa(mdev.Statistics,'xregpointer')
         mdev.Statistics=[];
      end
      
		mdev.Version=1;
      mdev= mv_rmfield(mdev,{'Name','TreeIndex'});
	end
	
	if  mdev.Version<2 | ~isfield(mdev,'ModelStage')
		mdev.Version=3;
      mdev.ModelStage=-1;
   end
	if isfield(mdev,'tree')
		T= mctree(Name,mdev.tree);
		mdev= mv_rmfield(mdev,'tree');
	else
		T= mctree(Name,mdev.mctree);
		mdev= mv_rmfield(mdev,'mctree');
	end
		
     
   loadstr=1;
elseif nargin==1 & isa(Name,'modeldev')
   mdev= Name;
   return
else
   [Model,XData,YData,ViewIndex]= deal(ModelInfo{:});
   
   % Valid data formats 
   %    xregpointer
   %    struct('ptr',p0,'index',[])
   
   mdev= struct(...
      'Model',Model,...         % Model Object
      'X',XData,...             % Do we need an index as well as a pointer? 
      'Y',YData,...             % i.e. data= p.info(:,ind)
      'Outliers',[],...         % index to outliers
      'Data',p0,...             % Store for datum links
      'Statistics',[],...       % Summary Statistics
      'Validation',p0,...       % ???? we need X and Y data for validation
      'Status',0,...            % 0= ~OK , 1=OK, 2= validated + ????
      'History',[],...          % undecided for the moment (mainly for reports and undo)
      'ViewIndex',ViewIndex,... % ViewIndex for Model Browser View
      'BestModel',p0,...        % pointer to best model
      'Version',4,...
      'ModelStage',-1);             % for class maintenance     
   T= mctree(Name);
end

   
mdev= class(mdev,'modeldev',T);

if ~loadstr
   % store object in dynamic memory
   p= pointer(mdev);
   % must get a copy of the dynamic object (contains the pointer to self)
   mdev= p.info;
end   
