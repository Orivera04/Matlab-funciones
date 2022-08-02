function des=xregdesign(varargin)
%XREGDESIGN  Constructor function for the design object
%
%  D=XREGDESIGN
%  D=XREGDESIGN(STRUCT)
%  D=XREGDESIGN('nfactors',N);

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.5.2.3 $  $Date: 2004/02/09 07:07:56 $


if nargin & isstruct(varargin{1})
   des=varargin{1};
else
   NF=4;
   if nargin
      if strcmp(varargin{1},'nfactors')
         NF=varargin{2};
      end
   end
   % Name field would be nice to be changeable for differentiating designs
   des.name='design';
   
   % Data storage fields
   % The current design
   des.design=zeros(0, NF);
   
   % the indices in the candidate space which the design is generated from
   % (if available - lost if spaces are switched)
   % This should be a column vector
   des.designindex=[];
   
   % flag that is incremented each time a design change is effected
   des.designstate=0;
   % flag that is incremented each time the candidate set definition is altered
   % Both flags are working
   des.candstate=0;
   
   % date and time stamps for marking the last change
   % to a design - working.
   des.stamping=1;
   des.timestamp=now;
   
   % string indicating last optimisation type - working
   des.lastoptimisation='';
   
   % Useful parameters
   % number of design points
   des.npoints=0;
   % number of factors in design
   des.nfactors=NF;
   
   % Candidate space generation section.
   if NF>9
      % switch to a lattice.  Grids have a default minimum of 4 levels which is too many 
      % points for high dimensions.
      des.candset=cset_lattice(candidateset(repmat([-1 1],NF,1)));
   else
      des.candset=cset_grid(candidateset(repmat([-1 1],NF,1)));
   end
   
   % flag to indicate whether replicated points are allowed in the design
   des.replicatedpoints=0;
   % constraints
   des.constraints=[];
   
   % Version 1.1 change
   % flag for switching the exposed interface between natural and coded units
   des.displaynatural=0;
   
   % Version 1.2 change
   % constraints flag - copies candstate to indicate current/not
   des.constraintsflag=0;
   
   % Version 2 change
   % flags for indicating requested GUI outputs
   des.guiflags.waitbars=1;
   
   % Version 3 change
   % Model field moved up from further down the design hierarchy
   des.model= xregcubic('nfactors',NF);
   des.modelstate=0;
   
   % Version 4 change
   % Added fields to track the current style of design
   des.style.base=0;     %0 = None of the above, 1= Optimal, 2= Space Filler, 3= Classical, 4= Expt. data
   des.style.baseinfo='';   % further information set according to base style
   
   % Version 5 change
   des.lockflag=0;   % boolean field used to indicate to GUI's that design is(n't) editable
   
   % Version 7 change
   % Set of 8 flag indicators per design point.  These replace the old
   % fixedpoints field
   des.designpointflags = uint8([]);
   
end
des.version=7;

% sort structure fields so they're in the same order however they were created
c=struct2cell(des);
f=fieldnames(des);
[f,i]=sort(f);
c=c(i);
des=cell2struct(c,f,1);

des=class(des,'xregdesign');
return
