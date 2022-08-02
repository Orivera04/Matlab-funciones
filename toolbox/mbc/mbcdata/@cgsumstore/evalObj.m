function [sumst, ysum, g] = evalObj(sumst, x, funcindex)
%EVALOBJ Evaluate the sum objectives 
%
%  [SUMST, YSUM] = EVALOBJ(SUMST, X, FUNCINDEX) evaluates the objective
%  functions specified in the index vector FUNCINDEX at the value of FVARS
%  given by X. The structure of X can either be 
%  a) Column vector with the same structure as X0
%  b) Matrix of size length(FVARS)-by-NPOP
%  In case a) YSUM is a length(FUNCINDEX) column vector containing the
%  calculated objective sum values, whereas in case b) YSUM is a
%  length(FUNCINDEX)-by-NPOP matrix. In case b) YSUM(i, j) is the
%  evaluation of the FUNCINDEX(i)-th objective sum for the j-th population
%  member. 
%  [SUMST, YSUM, G] = EVALOBJ(SUMST, X, FUNCINDEX) evaluates the gradient
%  of the objective functions specified in FUNCINDEX in addition to to the
%  objective function calculation if SUMST.OBJGRAD is TRUE (if FALSE, then
%  G = []). G is a length(FUNCINDEX)-by-length(FVARS) matrix where G(I, J)
%  is the partial derivative of the FUNCINDEX(i)-th objective sum w.r.t
%  FVARS(j). Note that if X is specified as a matrix, the gradient
%  calculation is ignored (i.e. G = [])
%
%  See also CGSUMSTORE/GETINITVALS, CGSUMSTORE/EVALCON

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.1.6.3 $  $Date: 2004/04/04 03:26:17 $

os = sumst.os;
gradglob = sumst.gradglob;
OBJGRADFLAG = sumst.objgrad;

% Always ignore gradient calculation, if X is specified as a matrix
% (population based algorithm). The reason for this is speed - we could
% implement this if required (the gradient matrix would have to be
% length(FUNCINDEX)-by-length(FVARS)-by-NPOP)
szx = size(x);
if OBJGRADFLAG & all(szx > 1)
    OBJGRADFLAG  = false;
end

[FY, ysum] = i_evalObjSumFn(funcindex, x, os, sumst);
g = [];
if OBJGRADFLAG

    nvars= length(x);
    nt = get(os, 'numfreevariables');
    nobj = get(os, 'numobjectivefuncs');
    
    [CGNBIG_OBJ, CGNBIFAC_OBJ, JP, THRESH] = pgetGlobals(sumst, 'objective');    
    if isempty(CGNBIFAC_OBJ)
        CGNBIFAC_OBJ= cell(1,nobj);
        CGNBIG_OBJ= CGNBIFAC_OBJ;
        THRESH= max(abs(double(x(:))*1e-8),1e-8);
        JP= repmat( speye(nvars/nt) , 1, nt );
    end
    
    % derivatives with jacobian Pattern
    x= x(:);
    
    g= zeros(nvars,length(funcindex));
    for j=1:length(funcindex)
        i= funcindex(j);
        if size(FY, 2) > 1
            fn_at_x = FY(:, i);
        else
            fn_at_x = FY(:);
        end
        [J,CGNBIFAC_OBJ{i},CGNBIG_OBJ{i}]= numjac(@i_evalObjSumFn,i,x,fn_at_x,THRESH,CGNBIFAC_OBJ{i},0,JP,CGNBIG_OBJ{i}, os, sumst);
        g(:,j) = sum(J,1)';
    end
    g = g';
    
    % Store 'globals'
    sumst = psetGlobals(sumst, 'objective', CGNBIG_OBJ, CGNBIFAC_OBJ, JP, THRESH);

end
ObjectiveFuncTypes = get(os, 'ObjectiveFuncTypes');

for j = 1:length(funcindex)
    switch ObjectiveFuncTypes{funcindex(j)}
    case 'max' % apply to the negative of the function to be maximimzed
        ysum(j,:) = -ysum(j,:);
        if ~isempty(g)
            g(j,:) = -g(j,:);
        end
    case 'min' % no change
    otherwise 
        error('This optimization routine can only deal with objective functions to be maximimized or minimized')
    end
end

%------------------------------------------------------------------
function [y, ysum] = i_evalObjSumFn(funcindex, x, os, sumst)
%------------------------------------------------------------------

for j =1:length(funcindex)
    objectives{j} = ['Objective' num2str(funcindex(j))];
end

nfreevariables = get(os, 'numfreevariables');
nrowsData = getNumRowsInDataset(os, 'OperatingPointSet1'); 
nzt = getNonZeroWtPts(sumst);
nNzt = length(nzt);

% For NBI, the free variable pattern is 
% v1(1) v1(2) ... v1(N) v2(1) ... v2(N) etc
% where vr(s) is the r-th  free variable at operating point s
M = size(x, 2);
if M > 1

    newx = [];
    for i = 1:nfreevariables
        temp = x((1 + nNzt*(i-1)):(nNzt*i), :);
        newx = [newx, temp(:)];
    end
    x2eval = zeros(nrowsData*M, nfreevariables);
    inds = false(nrowsData, 1);
    inds(nzt) = true;
    inds = repmat(inds, M, 1);
    x2eval(inds, :) = newx;
    ysum = [];
    for i = 1:M
        thisinds = (1 + nrowsData*(i-1)):(nrowsData*i);
        [y, thissum] = evaluate(os, x2eval(thisinds, :), objectives,'OperatingPointSet1', 1:nrowsData);
        ysum = [ysum, thissum'];
    end
else
    x = reshape(x, nNzt, nfreevariables);
    x2eval = zeros(nrowsData, nfreevariables);
    x2eval(nzt, :) = x;
    [y, ysum] = evaluate(os, x2eval, objectives,'OperatingPointSet1', 1:size(x2eval,1));
    y = y(nzt, :);
    ysum = ysum';    
end


%
% Preferred option. Core code (cgoptim/eval) currently disallows this 
%
%     newx = [];
%     for i = 1:nfreevariables
%         temp = x((1 + nNzt*(i-1)):(nNzt*i), :);
%         newx = [newx, temp(:)];
%     end
%     x2eval = zeros(nrowsData*M, nfreevariables);
%     inds = false(nrowsData, 1);
%     inds(nzt) = true;
%     inds = repmat(inds, M, 1);
%     x2eval(inds, :) = newx;
%     y = gridevaluate(os, x2eval, objectives,'OperatingPointSet1');
%     resy = reshape(y, nrowsData, M);
%     ysum = sum(resy, 1);
%     ysum = ysum';


