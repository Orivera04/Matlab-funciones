function viewdata = pPlotComparison( viewdata )
%PPLOTCOMPARISON Wraps a call to ComparisonPane.plotcomparison
%
%  VIEW = PPLOTCOMPARISON( VIEW )

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/04/10 23:34:58 $ 

[OK,msg] = settingscheck(viewdata.TablePtr.info);
if ~OK
    pMessage(viewdata, msg);
    viewdata.Handles.ComparisonPane.plotcomparison([],[]);
else
    model = viewdata.FeatureData.Model;
    c = cgbrowser;
    normnode = c.CurrentNode;
    tablenode = normnode.Parent;
    table = tablenode.getdata;
    % call the ComparisonPane method
    viewdata.Handles.ComparisonPane.plotcomparison(model,table);

end
