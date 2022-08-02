function addtip(this,tipfcn,info)
% Adds line tip to each curve in each view object

%   Author(s): John Glass
%   Copyright 1986-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.2 $  $Date: 2004/04/11 00:41:29 $
for ctp = 1:length(this.Curves)
   info.Row = ctp; 
   info.Col = 1;
   this.installtip(this.Curves{ctp},tipfcn,info)
end