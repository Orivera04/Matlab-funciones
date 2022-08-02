function mastruct = affytomastruct(affystruct,fieldname)
% turn affy probe data into the same format as other microarray data

%   Copyright 2004 The MathWorks, Inc.
%   $Revision: 1.1.4.2 $  $Date: 2004/04/10 23:12:22 $

col = find(strcmpi(affystruct.ProbeColumnNames,fieldname));
Xcol = find(strcmpi(affystruct.ProbeColumnNames,'PosX'));
Ycol = find(strcmpi(affystruct.ProbeColumnNames,'PosY'));
X = affystruct.Probes(:,Xcol);
Y = affystruct.Probes(:,Ycol);

mastruct.Shape.NumBlocks = 1;
mastruct.Shape.BlockRange = [1 1];
mastruct.Blocks=ones(size(X));
mastruct.ColumnNames = {'X','Y',fieldname};
mastruct.Data = [X Y affystruct.Probes(:,col)];
numRows = max(Y+1);
numCols = max(X+1);

% convert file indexing into MATLAB ordering -- row major
mastruct.Indices = reshape(sub2ind([numRows, numCols],Y+1,X+1),numRows,numCols);
