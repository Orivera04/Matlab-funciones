function addtip(this,tipfcn,info)
% Adds line tip to each curve in each view object

%   Copyright 1986-2002 The MathWorks, Inc.
%   $Revision: 1.1.4.1 $  $Date: 2004/04/16 22:21:19 $
for ct1 = 1:size(this.SimPlot,1)
   for ct2 = 1:size(this.SimPlot,2)
      info.Row = ct1; info.Col = ct2;
      this.installtip(this.SimPlot{ct1,ct2},tipfcn,info)
   end
end