function varargout= OutlierLine(md,fh,newOL)
% MODELDEV OUTLIERLINE - will get or set outlier line handle
%
% h= OutlierLine(md,fh)
% returns the handle to the outlier line
% 
% OutlierLine(md,fh,newOL)
% updates the handle of the outlier line

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:09:44 $

mbH= MBrowser;
p= get(mbH,'CurrentNode');
View= mbH.GetViewData;

if isfield(View,'OutlierLine')
   if nargin <3 
      varargout{1}= View.OutlierLine;
   else
      %View=ud.View{p.ViewIndex};
      View.OutlierLine= newOL;
		mbH.SetViewData(View);
   end
else
   View= View.Global;
   if nargin <3 
      % need something better...
      varargout{1}= View.OutlierLine;
   else
      View.OutlierLine= newOL;
		mbH.SetViewData(View);
   end
end
