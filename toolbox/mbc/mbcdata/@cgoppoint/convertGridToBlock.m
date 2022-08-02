function obj = convertGridToBlock(obj)
%CONVERTGRIDTOBLOCK Convert gridded factors into data blocks
%
%  OBJ = CONVERTGRIDTOBLOCK(OBJ) checks for the existence of any gridded
%  inputs and convertes them into blocks of data.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.1 $    $Date: 2004/04/04 03:25:59 $ 

isGrid = (obj.factor_type==1) & (obj.grid_flag==1);
if any(isGrid)
    % Convert these factors to be just chunks of data
    obj.grid_flag(isGrid) = 7;
    obj.range(isGrid) = {[]};
    
    % Set the blocklen to be the size of the dataset
    obj.blocklen = size(obj.data, 1);
end
