function D = dataIntoActualDesign(obj, D, newData, designInds)
% DATAINTOACTUALDESIGN adds NEWDATA (numPoints-by-numFactors) into the
% actual design. First replacing those design points specified by
% DESIGNINDS then appending the remaining data to the actual design
%
%  OBJ = DATAINTOACTUALDESIGN(OBJ, NEWDATA, DESIGNINDS)
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.6.2 $    $Date: 2004/02/09 08:11:17 $ 

%% how many design points are we replacing with the newData?
numDes = length(designInds);
numData = size(newData, 1);

if numData >= numDes
   %% replace the design points with data, then add the rest of the data onto
   %% the end of the design
   D(designInds, :) = newData(1:numDes, :);
   %% fix these points as they are dataPoints
   D = setdatapoint(D, designInds);
   
   % Only augment where there is more data than design
   if numData > numDes
       numPoints = npoints(D);
       %% now add the remaining data points to the design
       
       %  D=AUGMENT(D,POINTS,'points') forces the recognition that a specified
       %  point is being added - this is useful if you are trying to add a
       %  point on a 1D design and the function is choosing P random points
       %  instead
       D = augment(D, newData(numDes+1:end, :), 'points');
       %% fix these points as they are dataPoints
       augInds = numPoints+1:npoints(D);
       D = setdatapoint(D, augInds);
   end
   
else %% numData < numDesign
   error('Ndata < Ndesign provided - which design points am I supposed to replace?');
end