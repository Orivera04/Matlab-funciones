function Data = getDataAtIndex(this, indices)
% GETDATAATINDEX Get the data samples (pages) at the given INDICES

% Author(s): Bora Eryilmaz
% Revised: 
% Copyright 1986-2003 The MathWorks, Inc.
% $Revision: 1.1.6.1 $ $Date: 2003/12/22 00:57:00 $

if ( length(this.Dimensions) < 2 )
  Data = this.Data(indices,:);
else
  Data = LocalGetArrayData(this.Data, indices);
end

% --------------------------------------------------------------------------
% Get pages from the DATA array at the specified INDICES
function Data = LocalGetArrayData(Data, indices)
dims = size(Data);

% Make 2D with as many columns as pages
Data = reshape( Data, [ prod(dims(1:end-1)) dims(end) ] );

% Select columns (i.e., pages)
Data = Data(:,indices);

% Reshape back to original form with only the selected pages
Data = reshape( Data, [ dims(1:end-1) length(indices) ] );
