function f = addhistoryitem(f, comment, details)
%ADDHISTORYITEM Add a history item to the feature
%
%  F = ADDHISTORYITEM(F, COMMENT, DETAILS) adds COMMENT and DETAILS as a
%  new history item in the feature.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 07:10:27 $ 

% Add a new history item
this.Comment = comment;
this.Details = details;
this.Time = datestr(now);
f.history = [f.history {this}];
