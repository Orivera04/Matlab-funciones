function h = cgoptimoutnode(varargin)
%CGOPTIMOUTNODE  construct a cgoptimoutputnode object
%
% h=cgoptimoutnode(data)  constructs a cgoptimoutnode object
% h=cgoptimoutnode(structure)
%
% CGOPTIMOUTNODE inherits from CGCONTAINER
%
% CGOPTIMOUTNODE- FIELD SUMMARY
% ==================================
% 
%  name   - Name for output node AS string
%  output - Structure of statistical information for the current run
%           This should be of the form 
%           output.<fieldname> = string OR double 

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.4.6.2 $    $Date: 2004/02/09 08:27:18 $

loadstr=0;
if nargin==0
   loadstr=1;
   t=cgcontainer;
end

if nargin==1 & isstruct(varargin{1})
   % version update mechanism - fixes the input structure
   h=varargin{1};
   
   t=h.cgcontainer;
   h=mv_rmfield(h,'cgcontainer');  
   loadstr = 1;
else 
   % construct a new object
   data=[];
   output = [];
   if nargin < 1
      % Do nothing   
   elseif nargin == 1
      data = varargin{1};
   else
      data = varargin{1};
      output = varargin{2};
   end
   
   h=struct('name', 'New_optim_output', 'output', output, 'version', 3, 'viewed', 0); 
   if ~loadstr
      t=cgcontainer(data);
      t=guid(t,'cgoptimoutput');
      newname = [data.getname, '_Output'];
      h.name = newname;
   else
      t=cgcontainer;
   end
end

h=class(h,'cgoptimoutnode',t);

if ~loadstr
   p=pointer(h);
   h=p.info;
end
