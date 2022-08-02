function [X,Y]=GetData(MD,var,RemOutliers)
% MODELDEV/GETDATA

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 08:10:20 $

if nargin<3
   RemOutliers=1;
end

X= i_GetData(MD.X);
if RemOutliers
   Y= i_GetData(MD.Y,outliers(MD));
else
   Y= i_GetData(MD.Y);
end

if nargin>1
   switch upper(var)
   case 'Y'
      X=Y;
   case 'X'
   case 'DATA'
      X=i_GetData(MD.Data,outliers(MD));
   case 'VAL'
      [X,Y]= valdata(MD);
   case 'FIT'
		TP= mdevtestplan(MD);
		[X,YG]= getdata(TP,'X',0);
		if ~iscell(X)
			% make X data a cell array for consitency with twostage
			X={X};
		end
	case 'ALLDATA'
		TP= mdevtestplan(MD);
		X= DataLink(TP);
		if RemOutliers
			X(outliers(MD),:)= NaN;
		end
   otherwise
      error('Invalid Argument')
   end
end


function Data= i_GetData(p,Outliers)

switch class(p)
case 'xregpointer'
    if length(p)>1
        Data= cell(size(p));
        for i=1:length(p)
            Data{i}= sweepset(p(i).info);
        end
    else
        Data= sweepset(p.info);
    end
case 'sweepsetfilter'
	Data= sweepset(p);
case 'struct'
   Data= p.ptr.info(:,p.index);
case {'double','sweepset'}
   Data= p;
otherwise
   error('Invalid Data Type')
end
if nargin > 1
   Data(Outliers,:)=NaN;
end	

   
