function [T,X_temp,Y_temp,Tarray] = fit_table_to_array(LU,ud)
%FIT_TABLE_TO_ARRAY

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:11:35 $

% T = FIT_TABLE(T,ud) returns table data to fill out the comparison plot in the breakpoint editor
% ud is the userdata of the breakpoint editor. Should be used after return_data has run. The reason for splitting them up
% is that we need to find new table values each time we edit the table, whereas we need to evaluate the 
% model only when the input variables change, which should happen less often.

cgm = cgmathsobject;
linearfH = gethandle(cgm,'linear1');
extinterp2fH = gethandle(cgm,'extinterp2');

X = ud.Data.XData;
Y = ud.Data.YData;
M = ud.Data.MData;

xNormaliser = LU.Xexpr; 
Xinput = xNormaliser.get('x'); % Quantity feeding into X port of table

yNormaliser = LU.Yexpr;
Yinput = yNormaliser.get('x'); % Quantity feeding into Y port of table.


BPx = xNormaliser.get('breakpoints');% breakpoints in x
BPy = yNormaliser.get('breakpoints');% breakpoints in y 

Valx = xNormaliser.get('values');
Valy = yNormaliser.get('values');

BPx = feval(linear1fH,Valx,BPx,[0:Valx(end)]); % Fill in missing breakpoints.
BPy = feval(linear1fH,Valy,BPy,[0:Valy(end)]);

A = values_regression2(X(:),Y(:),M(:),BPx,BPy);

% A now gives us the matrix to stick inside thelookup table. We now return a 30 by 30 matrix covering this table
% which can then be interpreted 

x = linspace(BPx(1),BPx(end),30);
y = linspace(BPy(1),BPy(end),30);
[X_temp,Y_temp] = meshgrid(x,y);

% interp2 can't handle the truth, or at least repeated breakpoints. To get around this we'll add a small number to the bigger one
for i = 1:length(BPx)
    sameInd = i+find(BPx(i+1:length(BPx))==BPx(i));
    if ~isempty(sameInd)
        if BPx(i) ~= 0
            BPx(sameInd) = BPx(sameInd)*(1.001);
        else
            BPx(sameInd) = eps*ones(length(sameInd),1);
        end
    end
end
for i = 1:length(BPy)
    sameInd = i+find(BPy(i+1:length(BPy))==BPy(i));
    if ~isempty(sameInd)
       if BPy(i) ~= 0
           BPy(sameInd) = BPy(sameInd)*(1.001);
       else
           BPy(sameInd) = eps*ones(length(sameInd),1);
       end
    end
end

T_temp = feval(extinterp2fH, BPx,BPy,A,X_temp(:),Y_temp(:));

T = reshape(T_temp,size(X));

Tarray = feval(extinterp2fH, BPx,BPy,A,X(:),Y(:));

return
