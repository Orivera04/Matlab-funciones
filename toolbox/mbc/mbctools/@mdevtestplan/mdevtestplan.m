function TP=testplan(varargin);
%MDEVTESTPLAN

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:08:02 $


loadstr=0;
if nargin==1 & isa(varargin{1},'struct')
	loadstr=1;
	[TP,mdev]=i_updateOld(varargin{1});
elseif nargin==1 & isa(varargin{1},'mdevtestplan')
	TP= varargin{1};
	return
else
	if nargin ==0  
	
		Name= 'Testplan';
		m= xregcubic;
		
		loadstr=1;
	else
		Name= varargin{1};
		m= varargin{2};
		
	end	
	
	
	d= designdev;
	
	% testplan object structure
	TP= struct(...
		'Matched',0,...
		'version',7,...
		'Monitor',[],...
		'Notes','',...
		'DesignDev',d,...
		'ConstraintData',xregpointer,...
		'DataLink',xregpointer,...
		'Responses',[],...
        'PlotSetup',[]);
	
	
	if loadstr
		mdev= modeldev;
	else
		ModelInfo={m,xregpointer,xregpointer,'testplan'};
		mdev= modeldev(Name,ModelInfo);
	end
end

% class definition
TP= class(TP,'mdevtestplan',mdev);


if ~loadstr
   % these commands cannot be done on a static copy of the object
   
   % initialise dynamic copy of testplan
   p= pointer(TP);
   TP= p.info;
   
   % set up testplan as model stage 0 - not an actual model
   TP= modelstage(TP,0);   
end


function [TP,mdev]=i_updateOld(TP);

% called from loadobj
mdev= modeldev(TP.modeldev);
TP= mv_rmfield(TP,'modeldev');
while TP.version<7
	switch TP.version
	case {0,1}
		TP.Monitor=[];
		TP.version=2;
	case 2
		TP.version=3;
		
		% Set up design object
		des= des_linearmod;
		des= model(des,model(mdev));
		if ~isempty(TP.DesignGrid)
			des= reinit(des,TP.DesignGrid);
		end
		TP= mv_rmfield(TP,'DesignGrid');
		TP.Design=des;
	case 3
		TP.version=4;
		TP.DesignTree.designs={designobj(model(mdev))};
		TP.DesignTree.parents=[0];
		TP.DesignTree.chosen=1;
		if npoints(TP.Design)
			TP.DesignTree.designs(2)={TP.Design};
			TP.DesignTree.parents=[0 1];
			TP.DesignTree.chosen=2;
		end  
	case 4
		TP.version= 5;
		d= designdev;
		m = factorNames(model(mdev),{TP.Factors.Name}');
		dtree=TP.DesignTree;
		for i=1:length(dtree.designs)
			md= model(dtree.designs{i});
			if strcmp(class(md),'xregmodel')
				dtree.designs{i}= model(dtree.designs{i},m);
			end
		end
		if isempty(dtree.chosen)
			des= designobj(m);
			dtree= struct('designs',{{des}},'parent',0,'chosen',1);
		end	
		d.DesignTree = dtree;
		d.design     = dtree.designs{dtree.chosen};
			
		d.BaseModel  = m;
		
		TP.Notes    = '';
		TP.DesignDev= d;
		
		TP.ConstraintData= [];
		
		% set data link to testplan y data
		TP.DataLink = sweepsetfilter;
		TP.Responses= [];
		
		TP= mv_rmfield(TP,{'Design','DesignTree','SType'});
        
	case 5
		TP.version= 6;
		TP.ConstraintData= xregpointer;
    case 6
		TP.version= 7;
        TP= mv_rmfield(TP,'Factors');
        
        TP.PlotSetup = [];
        
	otherwise
		error('Unknown Testplan Version')
	end
end
