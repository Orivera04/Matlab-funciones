function MD= AssignData(MD,varargin)
% MODELDEV/ASSIGNDATA

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:09:21 $

if nargin==2
   Data= varargin{1};
   MD.X= i_AssignData(Data{1});
   MD.Y= i_AssignData(Data{2});
else
   Data= varargin{2};
   var= varargin{1};
   switch upper(var)
   case 'X'
      MD.X= i_AssignData(Data);
   case 'Y'
      MD.Y= i_AssignData(Data);
   case 'DATA'
      MD.Data= i_AssignData(Data);
   end
end
pointer(MD);

function p= i_AssignData(Data)

switch class(Data)
case {'double','sweepset'}
   p= xregpointer(Data);
case 'xregpointer'
   p= Data;
case 'sweepsetfilter'
	p= Data;
case 'cell'
   if isa(Data{1},'xregpointer') 
      p.ptr= Data{1};
   else
      p.ptr= xregpointer(Data{1});
   end
   p.index= Data{2};
case 'struct'
   p=Data;
otherwise
   error('Invalid Datatype')
end
   
   

