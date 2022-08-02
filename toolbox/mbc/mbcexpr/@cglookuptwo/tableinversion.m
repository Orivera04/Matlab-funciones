function [out,err] = tableinversion(T,invT,OutputFlag,InputFlag,fillFlag,flag)
%TABLEINVERSION Table inversion routine for two-d lookup tables.
%
% [OUT, ERR] = TABLEINVERSION(T, INVT, OUTPUTFLAG, INPUTFLAG, FILLFLAG)
%
% T is our table, that at the end of this will hopefully be an inverse of 
% invT. OUTPUTFLAG is either 1 or 2 depending on whether the x input or y input 
% to invT is the desired output of T. We use a combination of VALUES_REGRESSION2 
% to fill out as much of the table as possible, and then we'll extrapolate out 
% to fill up whatever remains. INPUTFLAG tells us which input to T corresponds 
% to the output of invT. FILLFLAG will tell us how to fill up the values that 
% we cannot determine by this method, case one means use our RBF function,case two
% means use the linear extrapolation routine.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.6.2.4 $  $Date: 2004/04/12 23:34:38 $

% Get the breakpoints for T

cgm = cgmathsobject;
h_extrapolate = gethandle(cgm,'extrapolate_values');
h_extrapolate_RBF = gethandle(cgm, 'extrapolate_values_RBF');
h_linear2 = gethandle(cgm, 'linear2');

xNormaliser = get(T,'x');
yNormaliser = get(T,'y');

Valx = xNormaliser.get('values');
Valy = yNormaliser.get('values');

BPx = xNormaliser.invert(0:Valx(end));
BPy = yNormaliser.invert(0:Valy(end));



% Extract info from the table we are going to invert.

invxNormaliser = get(invT,'x');
invyNormaliser = get(invT,'y');

invVal = get(invT,'values');

if isempty(invxNormaliser) || isempty(invyNormaliser) || isempty(invVal)
    err = [getname(invT), ' is empty, and cannot be inverted. Please select another table or set up this one',...
            ' using the Calibration Manager.' ];
    out = T;
    return
end

% Now get the interpolated breakpoints.
invValx = invxNormaliser.get('Values');
invBPx = invxNormaliser.invert(0:invValx(end));

invValy = invyNormaliser.get('Values');
invBPy = invyNormaliser.invert(0:invValy(end));

if any(diff(invBPx)<=0) || any(diff(invBPy)<=0)
    err = [getname(invT), ' does not have monotonic increasing breakpoints and cannot be inverted.'];
        out = T;
    return
end
% Now get the output in invT for a fairly hefty couple of inputs covering the range of 
% its input breakpoints.

inX = linspace(invBPx(1),invBPx(end),51);
inY = linspace(invBPy(1),invBPy(end),51);
Z = feval(h_linear2, invBPy,invBPx,invVal,inY,inX);
[X,Y] = meshgrid(inX,inY); X = X(:); Y = Y(:); Z = Z(:);

% We now have three column vectors X,Y, and Z such that Z = invT(X,Y). We are now in a position 
% to try and invert the table regression style by seeking a matrix of values that will achieve
% the following when plugged into T:
%
%           OutputFlag      InputFlag           Equation to solve
%               1               1                   X = T(Z,Y)
%               1               2                   X = T(Y,Z)
%               2               1                   Y = T(Z,X)
%               2               2                   Y = T(X,Z)
% In what follows, mask gives us the pattern of values in V that we should trust and those we don't.

if flag <= 3
    [tempX,tempY] = meshgrid(invBPx,invBPy);
    if OutputFlag == 1
        if InputFlag == 1
            [V,err] = i_inversionmap(tempX,tempY,invVal,BPy,BPx,flag);
            V = V';
        else
            [V,err] = i_inversionmap(tempX,tempY,invVal,BPx,BPy,flag);
        end
    else
        if InputFlag == 1
            [V,err] = i_inversionmap(tempY',tempX',invVal',BPy,BPx,flag);
            V = V';
        else
            [V,err] = i_inversionmap(tempY',tempX',invVal',BPx,BPy,flag);
        end
    end    
else
    if OutputFlag == 1
        if InputFlag == 1
            [V,mask,err] = values_regression2(Z,Y,X,BPx,BPy);
        else
            [V,mask,err] = values_regression2(Y,Z,X,BPx,BPy);
        end
    else
        if InputFlag == 1
            [V,mask,err] = values_regression2(Z,X,Y,BPx,BPy);
        else
            [V,mask,err] = values_regression2(X,Z,Y,BPx,BPy);
        end
    end    
    
    switch fillFlag
    case 1
        V = feval(h_extrapolate_RBF, V, logical(mask), BPx, BPy);
    case 2
        V = feval(h_extrapolate, V, logical(mask), BPx, BPy);
    end
end

if ~isempty(err)
    out = T;
    return
end

T = set(T,'values',{V,['Inversion of ',getname(invT)]});

out = T;

return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% i_inversionmap               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [V,err] = i_inversionmap(X,Y,Z,invbpY,invbpZ,flag)

% Produces a map of the x-y plane that shows where potential points for
% inversion. FLAG tells us whether we wish to try and use max (1), min (2) or
% intermediate (3) values. X, Y and Z should specify the surface in meshgrid stylie.

err = [];

[BPY,BPZ] = meshgrid(invbpY,invbpZ);

Xmax = max(X(:));
Xmin = min(X(:));
Xrange = linspace(Xmin,Xmax,1000);

goodY = [];
goodX = [];

for i = 1:length(BPY(:))
    Izc = [];
    tempy = BPY(i)*ones(size(Xrange));
    tempZ = interp2(X,Y,Z,Xrange,tempy)-BPZ(i);
    tempsgn = sign(tempZ);
    Izc = find(diff(tempsgn));
    if length(Izc) == 1
        goodY = [goodY;BPY(i)];
        goodX = [goodX;(Xrange(Izc)+Xrange(Izc+1))/2];
    elseif length(Izc) == 2
        if flag == 2 || flag == 3
            goodY = [goodY;BPY(i)];
            goodX = [goodX;Xrange(Izc(2))];
        else
            goodY = [goodY;BPY(i)];
            goodX = [goodX;Xrange(Izc(1))];
        end
    elseif length(Izc) > 2
        if flag == 2
            goodY = [goodY;BPY(i)];
            goodX = [goodX;Xrange(Izc(end))];
        elseif flag == 1
            goodY = [goodY;BPY(i)];
            goodX = [goodX;Xrange(Izc(1))];
        else
            goodY = [goodY;BPY(i)];
            Ind = ceil(length(Izc)/2);
            goodX = [goodX;Xrange(Izc(Ind))]; 
        end   
    else
        goodY = [goodY;BPY(i)];
        goodX = [goodX; NaN];
    end
end

tempX = reshape(goodX,size(BPY));

Mask = true(size(BPY));
Mask(isnan(tempX(:,:))) = false;
tempX(isnan(tempX(:,:))) = false;

if ~any(Mask(:))
    V = []; 
    err = 'Cannot invert the chosen table.';
    return
end

V = eval(cgmathsobject,'extrapolate_values_RBF',tempX,Mask);

return
