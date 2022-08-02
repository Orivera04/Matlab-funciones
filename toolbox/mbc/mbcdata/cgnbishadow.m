function [SHADOWX, SHADOWFVAL, EXITFLAG, OUTPUT] = cgnbishadow(FUN, X, NumberOfObjectives, A,B,Aeq,Beq,LB,UB,NONLCON, options, varargin); 
%CGNBISHADOW

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.4.6.1 $    $Date: 2004/02/09 06:56:28 $

% Globals needed for the call to numjac in mbcOSnbi
global CGNBIG_OBJ CGNBIFAC_OBJ CGNBIG_CON CGNBIFAC_CON 

% Determine the shadow minima SHADOWFVAL that occurs at SHADOWX
numberOfVariables = size(X,1);

SHADOWX = zeros(numberOfVariables,NumberOfObjectives);
SHADOWFVAL = zeros(NumberOfObjectives,1);
EXITFLAG = 1;
OUTPUT.shadowIterations = 0;
OUTPUT.shadowFuncCount = 0;


for i =1: NumberOfObjectives
    
    % Reset the numjac working vectors
    CGNBIFAC_OBJ = [];
    CGNBIFAC_CON=[];

    % determine shadow minima
    [SHADOWX(:,i),SHADOWFVAL(i,1), EXITFLAGi, OUTPUTi] = fmincon(FUN,X,A,B,Aeq,Beq,LB,UB,NONLCON, options,i,varargin{:});
     % update exitflag and output
    if EXITFLAGi <  0
        EXITFLAG = -1;
    elseif EXITFLAGi == 0 & EXITFLAG >=0
        EXITFLAG = 0;
    end
    OUTPUT.shadowIterations =  OUTPUT.shadowIterations + OUTPUTi.iterations;
    OUTPUT.shadowFuncCount = OUTPUT.shadowFuncCount+ OUTPUTi.funcCount;

end
 
F = zeros(NumberOfObjectives, NumberOfObjectives);
for j = 1:size(SHADOWX,2)
    F(:,j) = feval(FUN, SHADOWX(:,j), [1:NumberOfObjectives], varargin{:});
end

for i =1:NumberOfObjectives
     % find the smallest value of the objective
    [bestF,bestindex] = min(F(i,:));
    if ~bestindex==i
        %We did not find the global minimum for one of the shadow problems 
        %so recompute from improved starting point
        if options.Display
            fprintf('Global minimum not found for one of the shadow problems. Recomputing with alternative start position.');
        end
        
        % Reset the numjac working vectors
        CGNBIFAC_OBJ = [];
        CGNBIFAC_CON=[];
        
        [SHADOWX(:,i),SHADOWFVAL(i,1), EXITFLAGi, OUTPUTi] = fmincon(FUN,SHADOWX(:,bestindex),A,B,Aeq,Beq,LB,UB,NONLCON, options,i,varargin{:});
    end
end