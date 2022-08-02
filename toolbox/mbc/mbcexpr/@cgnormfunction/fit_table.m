function T = fit_table(LU,X,Y,M);
%FIT_TABLE  Returns data for comparison plot in breakpoint editor.
%
% T = FIT_TABLE(T,X,Y,M)
%  X & M are arrays of the same size.  Y is ignored and exists only to
%  provide a uniform interface with cglookuptwo objects.
%  M is the value of the model at points X.
%  T is an array of the same size as the values of the normaliser for this
%  lookup table, and is the best fit for the model at these points.
% Should be used after return_data has run. The reason for splitting them up
% is that we need to find new table values each time we edit the table, whereas
% we need to evaluate the model only when the input variables change.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.4.2.3 $  $Date: 2004/02/09 07:14:40 $


cgm = cgmathsobject;

xNormaliser = LU.Xexpr;
Xinput = xNormaliser.get('x');
BP = xNormaliser.get('breakpoints');
V = xNormaliser.get('values');

BP = eval(cgm,'linear1',V(:),BP(:),[0:V(end)]');
BP = mbcmonotonic(BP);

A = eval(cgm,'values_regression1',X(:),M(:),BP);

T = eval(cgm,'linear1',BP,A,X(:));

