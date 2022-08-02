function [sumst, ysum, yeq, ygci, ygce] = evalCon(sumst, x)
% EVALCON Evaluate the sum constraints
%
%  [SUMST, YSUM, YEQ] = EVALCON(SUMST, X) evaluates all the constraints in
%  the optimization in SUMST at the free variable values X. Evaluation of
%  inequality constraints is returned in YSUM. Note that inequality
%  constraints can include both 'sum' constraints and 'point' constraints.
%  For each 'point' constraint that is specified, EVALCON returns a column
%  vector of the constraint status at each non-zero weighted operating
%  point. For each 'sum' constraint, EVALCON returns a single value
%  showing the status of the constraint. YEQ is a placeholder for equality
%  constraints, which are currently not implemented. In the case where X is
%  a matrix, note that 
%  a) YSUM is a NPOP-by-[NO_SUM_CON + nN*NO_PT_CON] matrix of constraint
%  calcualtions
%  b) Constraint gradients are not calculated.
%  [SUMST, YSUM, YEQ, YGCI, YGCE] = EVALCON(SUMST, X) evaluates the
%  gradient of the constraint functions in addition to the constraint
%  status. YGCI is a length(FVARS)-by-[NO_SUM_CON + nN*NO_PT_CON] matrix
%  where YGCI(i, j) is the partial derivative of the j-th constraint w.r.t
%  FVARS(i). YGCE is a placeholder for gradient of equality constraints.
%  
%  See also CGSUMSTORE/GETINITVALS, CGSUMSTORE/EVALOBJ
%
%  Notes:
%  1. This function does not support a user inputted FUNCINDEX.
%  2. Equality constraints are currently not supported.
%  3. The gradient matrix for constraints is the transpose of that for
%  objectives. 

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.1.6.3 $  $Date: 2004/04/04 03:26:16 $

os = sumst.os;
gradglob = sumst.gradglob;
CONGRADFLAG = sumst.congrad;

% Gradient evaluation not supported for the 'population' case.
szx = size(x);
if CONGRADFLAG & all(szx > 1)
    CONGRADFLAG  = false;
end

%%% NONLINEAR INEQUALITY CONSTRAINTS %%%
constraints = get(os, 'nonlinearconstraints');
sumconstraints = get(os, 'constraintsums');
if ~isempty(sumconstraints)
    suminds = find(ismember(constraints, sumconstraints));
else
    suminds = [];
end
ptinds = setdiff(1:length(constraints), suminds);
pointconstraints = constraints(ptinds);

if ~isempty(constraints)
    
    [CGNBIG_CON, CGNBIFAC_CON, JP, THRESH] = pgetGlobals(sumst, 'constraint');
    nvars= length(x);
    nt = get(os, 'numfreevariables');
    npts = nvars/nt;
    if isempty(CGNBIFAC_CON)
        CGNBIFAC_CON= cell(1,length(constraints));
        CGNBIG_CON= CGNBIFAC_CON;
        JP= repmat( speye(npts) , 1, nt ) ;
        THRESH= max(abs(double(x(:))*1e-8),1e-8);
        sumst = psetGlobals(sumst, 'constraint', CGNBIG_CON, CGNBIFAC_CON, JP, THRESH);
    end

    ysum = [];ygci = [];
    if ~isempty(suminds)
        [FYs, ysum] = i_evalConSumFn(suminds, x, os, sumst);
        
        if CONGRADFLAG
            %
            %% Gradient for sum constraints
            %
            nvars= length(x);
            nt = get(os, 'numfreevariables');
            
            
            % derivatives with jacobian Pattern
            x= x(:);
            
            g= zeros(nvars,length(suminds));
            for i=1:length(suminds)
                if size(FYs, 2) > 1
                    fn_at_x = FYs(:, i);
                else
                    fn_at_x = FYs(:);
                end
                [J,CGNBIFAC_CON{suminds(i)},CGNBIG_CON{suminds(i)}]= numjac(@i_evalConSumFn,suminds(i),x,fn_at_x,THRESH,CGNBIFAC_CON{suminds(i)},0,JP,CGNBIG_CON{suminds(i)}, os, sumst);
                g(:,i) = sum(J,1)';
            end
            ygci = g;
            
        end
    end
    
    FY = [];
    gpoint = [];
    if ~isempty(pointconstraints)
        FY= i_evalConSumFn(ptinds, x, os, sumst);        
        %
        %% Gradient for point constraints
        %
        if CONGRADFLAG
            [gpoint, CGNBIG_CON, CGNBIFAC_CON] = i_evalPtGrad(sumst, ptinds, x, FY, os);
        end
    end
    
    % Concatenate constraint and gradient evaluation
    ysum = [ysum';FY(:)];
%     if size(FY, 2) > 1
%         ysum = [ysum, FY];
%     else
%         ysum = [ysum; FY(:)];
%     end
    ygci = [ygci, gpoint];

    % Store 'globals'
    sumst = psetGlobals(sumst, 'constraint', CGNBIG_CON, CGNBIFAC_CON, JP, THRESH);
    
else
    ysum = [];
    ygci = [];
end

%%% NONLINEAR EQUALITY CONSTRAINTS %%%
% CURRENTLY NOT IMPLEMENTED
yeq = [];
ygce = [];

%------------------------------------------------------------------
function [y, ysum] = i_evalConSumFn(funcindex, x, os, sumst)
%------------------------------------------------------------------

% nonlinear inequality constraint
constraints = get(os, 'nonlinearconstraints');

constraints = constraints(funcindex); 

nfreevariables = get(os, 'numfreevariables');
nrowsData = getNumRowsInDataset(os, 'OperatingPointSet1'); 
[nzt, junk, wtsc] = getNonZeroWtPts(sumst);
nNzt = length(nzt);

% For NBI, the free variable pattern is 
% v1(1) v1(2) ... v1(N) v2(1) ... v2(N) etc
% where vr(s) is the r-th  free variable at operating point s
y = [];
ysum = [];
M = size(x, 2);
if M > 1
    % Want to evaluate constraints at a population of points (this case
    % will be called for MOGA with sums)
    if ~isempty(constraints)
        newx = [];
        for i = 1:nfreevariables
            temp = x((1 + nNzt*(i-1)):(nNzt*i), :);
            newx = [newx, temp(:)];
        end
        x2eval = newx;
        ysum = [];
        ypoint = [];
%         for i = 1:M
%             thisinds = (1 + nNzt*(i-1)):(nNzt*i);
%             [y, thissum] = evaluate(os, x2eval(thisinds, :), constraints,'OperatingPointSet1', nzt);
%             ysum = [ysum; thissum];
%             ypoint = [ypoint; y(:)'];
%         end
        yall = mogaevaluate(os, x2eval, constraints,'OperatingPointSet1', nzt);
        % yall contains 'constraints' evaluated over dataset for all the
        % population. 
        constraintsums = get(os, 'constraintsums');
        if ~isempty(constraintsums)
            % Constraint sum evaluation
            %ycsum = reshape(yall, M*length(inds), nNzt);
            in = 1:nNzt:M*nNzt;
            ycsum = [];
            yallt = yall';
            for i = 1:nNzt
                temp = yallt(in, :);
                ycsum(:, i) = temp(:);
                in = in + 1;
            end
            ycell = {};
            for i =1:length(inds)
                thisinds = (1 + M*(i-1)):(M*i);
                ycell{i} = ycsum(thisinds, :);
            end
            bigY = blkdiag([ycell{:}]);
            bigW = wtsc(:);
            ycsum2 = bigY*bigW;
            ysum = reshape(ycsum2, M, length(inds));
        else
            % Point constraint evaluation
            % Need to return a NPOP-by-(NCON*nNZT) point constraint matrix to
            % MOGA
            ypoint = [];
            for i = 1:M
                thisinds = (1 + nNzt*(i-1)):(nNzt*i);
                temp = yall(thisinds, :);
                ypoint = [ypoint; temp(:)'];
            end
            y = ypoint;
        end
    end
else
    % Evaluate constraints at a single population point.
    x = reshape(x, nNzt, nfreevariables);
    x2eval = zeros(nrowsData, nfreevariables);
    x2eval(nzt, :) = x;
    if ~isempty(constraints)
        [y, ysum] = evaluate(os, x2eval, constraints,'OperatingPointSet1', [1:size(x2eval,1)]);
        y = y(nzt, :);
    else
        y = [];
        ysum = [];
    end
end

%------------------------------------------------------------------
function [gpoint, CGNBIG_CON, CGNBIFAC_CON] = i_evalPtGrad(sumst, pointinds, x, FY, os)
%------------------------------------------------------------------

[CGNBIG_CON, CGNBIFAC_CON, JP, THRESH] = pgetGlobals(sumst, 'constraint');        

nvars= length(x);
nt = get(os, 'numfreevariables');
npts = nvars/nt;

% derivatives with jacobian Pattern
x= x(:);
    
gpoint = zeros(length(x), npts*length(pointinds));
for i = 1:length(pointinds)
    if size(FY, 2) > 1
        fn_at_x = FY(:, i);
    else
        fn_at_x = FY(:);
    end
    [J,CGNBIFAC_CON{pointinds(i)},CGNBIG_CON{pointinds(i)}]= numjac(@i_evalConSumFn,pointinds(i),x,fn_at_x,THRESH,CGNBIFAC_CON{pointinds(i)},0,JP,CGNBIG_CON{pointinds(i)}, os, sumst);
    st = (i-1)*npts + 1;
    ed = i*npts;
    gpoint(:, st:ed) = J';
end
