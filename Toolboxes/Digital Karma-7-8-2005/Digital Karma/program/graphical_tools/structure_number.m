function [structurenumberalone,fullstructurenumber]=structure_number(matrix,safety);
currentbaseselection=max(max(max(matrix)))+1;
if currentbaseselection==1; currentbaseselection=2; end;
if currentbaseselection>10; currentbaseselection=10; end;
[matrixrows, matrixcols, matrixplanes]=size(matrix);
matrixrowsstr=int2str(matrixrows); matrixcolsstr=int2str(matrixcols); matrixplanesstr=int2str(matrixplanes);
currentbaseselectionstring=int2str(currentbaseselection);

if nargin==2;
    structurenumberalone=[matrix2num(flipdim(matrix,3),currentbaseselection,'on'),...
            currentbaseselection,matrixrows,matrixcols,matrixplanes];
else;
    structurenumberalone=[matrix2num(flipdim(matrix,3),currentbaseselection),...
            currentbaseselection,matrixrows,matrixcols,matrixplanes];
end;

structurenumber=int2str(structurenumberalone(1));
if matrixplanes==1;
    fullstructurenumber=['Structure ', structurenumber,', Base ', currentbaseselectionstring, ', ',...
        matrixrowsstr,'X', matrixcolsstr];
else;
    fullstructurenumber=['Structure ', structurenumber,', Base ', currentbaseselectionstring, ', ',...
        matrixrowsstr,'X', matrixcolsstr,'X', matrixplanesstr];
end;