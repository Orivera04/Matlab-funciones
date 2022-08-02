function T = fit_table(LU,X,Y,M)
%FIT_TABLE  Returns data for comparison plot in breakpoint editor.
%
% T = FIT_TABLE(L,X,Y,M)
%   X,Y,M are matrices of the same size.  M is the value of the model at
%   points (X,Y).  T is a matrix of the same size as the values of the
%   normalisers for this lookup table, and is the best fit for the model
%   at these points.
% Should be used after return_data has run. The reason for splitting them up
% is that we need to find new table values each time we edit the table, whereas
% we need to evaluate the model only when the input variables change.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.4.2.3 $  $Date: 2004/02/09 07:11:34 $

cgm = cgmathsobject;
linear1fH = gethandle(cgm,'linear1');
extinterp2fH = gethandle(cgm,'extinterp2');

xNormaliser = LU.Xexpr; 
yNormaliser = LU.Yexpr;

BPx = xNormaliser.get('breakpoints');% breakpoints in x
BPy = yNormaliser.get('breakpoints');% breakpoints in y 

Valx = xNormaliser.get('values');
Valy = yNormaliser.get('values');

BPx = feval(linear1fH,Valx,BPx,[0:Valx(end)]); % Fill in missing breakpoints.
BPy = feval(linear1fH,Valy,BPy,[0:Valy(end)]);

BPx = mbcmonotonic(BPx);
BPy = mbcmonotonic(BPy);
    
A = values_regression2(X(:),Y(:),M(:),BPx,BPy); % private method in this class

T_temp = feval(extinterp2fH, BPx,BPy,A,X(:),Y(:));

T = reshape(T_temp,size(X));

return
