function n= varname(mdev,type);
%VARNAME

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:11:05 $

if nargin==1
	type='Y';
end
switch upper(type)
case 'X'
   Data= mdev.X;
case 'Y'
   Data= mdev.Y;
end

switch class(Data)
case 'sweepsetfilter'
	n= get(Data,'keepvariables');
	if iscell(n) & length(n)==1
		n=n{1};
	end
case 'xregpointer'
   var= Data.info;
	switch class(var)
	case 'sweepset'
      n= get(var,'name');
   otherwise
      n= repmat({name(mdev)},size(var,2),1);
   end
case 'struct'
   n= Data.index;
   %if ~isa(name,'cell')
   %   name= {name};
   %end
otherwise
   n= [];
end
   
   