function [out,err] = tableinversion(T,invT,varargin)
%TABLEINVERSION

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.6.2.2 $  $Date: 2004/02/09 07:15:12 $

% NORMFUNCTION/TABLEINVERSION manages table inversion for a lookupone object.
% T = TABLEINVERSION(T,invT);
% T = TABLEINVERSION(T,invT,flag);
% T is our lookupone invT is the table which is to be inverted, flag is an optional 
% arguement that tells us what to try and do in the case of multiple choices - 
% flag = 1  use minima
% flag = 2  use maxima
% flag - 3  use intermediate values.

x = T.Xexpr;
BP =  x.get('allbreakpoints');
if isa(invT,'cgnormfunction')
    invBP = get(invT,'allbreakpoints');
elseif isa(invT,'cglookupone')
   invBP = get(invT, 'allbreakpoints');
else
    invBP = get(invT,'allbreakpoints');
end
inVal = get(invT,'values');

if isempty(varargin)
    flag = 2; % default we'll go for the max.
else
    flag = varargin{1};
end

% Quick check on the inputs
if isempty(invBP) | isempty(inVal)
    err = [getname(invT), ' needs to be set up, please go to the Calibration Manager to do this.'];
    out = T;
    return
end
if length(unique(inVal)) == 1
    err = [getname(invT), ' is a constant function and cannot be inverted.'];
    out = T;
    return
end
if any(diff(invBP)<=0)
    err = [getname(invT), ' does not have monotonic increasing breakpoints and cannot be inverted.'];
        out = T;
    return
end
if flag < 4
    [V,err] = i_inversionmap(invBP,inVal,BP,flag);
else
    [V,err] = eval(cgmathsobject,'invert_1D',BP,invBP,inVal,flag);    
end

if ~isempty(V) 
    T.Values = V;
    err = [];
end

T = set(T,'values',{V,['Inversion of ',getname(invT)]});

out = T;

return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% i_inversionmap                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [V,err] = i_inversionmap(X,Z,invbpZ,flag)

% Invert the function defined by X and Z by looking at which values of X correspond to the 
% breakpoints in invbpZ. Flag specifieswhich one to look for - 1 for min, 2 for max, 3 for int.

err = [];

BPZ = invbpZ;

Xmax = max(X(:));
Xmin = min(X(:));
Xrange = linspace(Xmin,Xmax,1000);
cgm = cgmathsobject;
curve = interp1(X,Z,Xrange);

goodZ = [];
goodX = [];

for i = 1:length(BPZ(:))
    Izc = [];
    tempZ = curve-BPZ(i);
    tempsgn = sign(tempZ);
    Izc = find(diff(tempsgn));
    if length(Izc) == 1
        goodX = [goodX;(Xrange(Izc)+Xrange(Izc+1))/2];
    elseif length(Izc) == 2
        if flag == 2 | flag == 3
            goodX = [goodX;Xrange(Izc(2))];
        else
            goodX = [goodX;Xrange(Izc(1))];
        end
    elseif length(Izc) > 2
        if flag == 2
            goodX = [goodX;Xrange(Izc(end))];
        elseif flag == 1
            goodX = [goodX;Xrange(Izc(1))];
        else
            Ind = ceil(length(Izc)/2);
            goodX = [goodX;Xrange(Izc(Ind))]; 
        end   
    else
        goodX = [goodX; NaN];
    end
end

tempX = reshape(goodX,size(BPZ));

Mask = ones(size(BPZ));
Mask(isnan(tempX(:))) = 0;
tempX(isnan(tempX(:))) = 0;

s = sum(Mask(:));
if s < 2
    if s== 0
        err = ['No breakpoints of the table being filled lie within '...
               'the output range of the table being inverted.'];
    else
        err = ['Only one breakpoint of the table being filled lies within '...
               'the output range of the table being inverted.'];
    end
    V = []; 
    return;
end

Zdata = BPZ(Mask(:)==1);
Ydata = tempX(Mask(:)==1);

V = eval(cgm,'extinterp1',Zdata,Ydata,BPZ);

return
