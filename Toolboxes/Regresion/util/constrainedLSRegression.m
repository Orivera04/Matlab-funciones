function [beta, exitflag] = constrainedLSRegression(x, y, constraintType)

    if nargin<3, constraintType='weighted';  end
    
    %All the input parametrs for optimization are prepared below
    %dataPoints = size(x,1);
    numIndicators = size(x,2);
    C = x;
    D = y;
    A = [];
    B = [];
    Aeq = [];
    Beq = [];
    lb = [];
    ub = [];
    x0 = ones(numIndicators,1) / numIndicators;
    options=optimset('lsqlin');
    options.TolX=1e-8; options.TolFun=1e-14; options.TolCon=1e-8; options.LargeScale='off';
    options.MaxFunEvals=15000; options.MaxIter=5000; options.MaxSQPIter=1000;
    
    if strcmpi(constraintType,'weighted')
        Aeq = ones(1,numIndicators);
        Beq = 1;
        lb = ones(numIndicators,1)*-1;
        ub = lb * -1;
    end
    
    [beta, resnorm,residual,exitflag] =  lsqlin(C,D,A,B,Aeq,Beq,lb,ub,x0,options);
end