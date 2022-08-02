function fcell = getFreeVar(cgc, rind, pO)
%GETFREEVAR Return free variable values at a given operating point
%
%  FCELL = GETFREEVAR(CGC, RIND, PO)
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 06:52:25 $ 

% Input checks
[ok, msg] = i_CheckInput(pO, rind);

if ok
    ops = pO.get('outputoppoints');
    parops = pO.get('paretooutput');
    
    fcell = cell(1, 2);
    
    % Get free variable data
    freeptrs = pO.get('values');
    nfree = length(freeptrs);
    fcell{1} = zeros(length(rind), nfree);
    
    for i = 1:length(rind)
        % This is a very noddy way - could be sped up
        alldata = parops(rind(i)).get('data');
        ptrs = parops(rind(i)).get('ptrlist');
        freeinds = find(ismember(double(ptrs), double(freeptrs)));
        fcell{1}(i, :) = alldata(cgc.solutionNo(rind(i)), freeinds);
    end
    
    % Get free variable names
    fcell{2} = cell(1, nfree);
    for i = 1:nfree
        fcell{2}{i} = freeptrs(i).getname;
    end
    
else
    error(['CGOPTCSOL\GETFREEVAR: ', msg]);
end

%---------------------------------------------------------------
function [ok, msg] = i_CheckInput(pO, rind)
%---------------------------------------------------------------

msg = '';
ok = 0;

outputops = pO.get('outputoppoints');
nrows = outputops(1).get('numpoints');

if ~isnumeric(rind) | ~isreal(rind) | any(abs(rind - round(rind)) > 0.001)
    msg = 'Operating point index must be integer';
elseif ~any(size(rind)== 1)
    msg = 'Operating point index must be a row or column vector';
elseif length(rind) > nrows
    msg = 'Operating point index must have length <= no of operating points';
elseif any(rind > nrows)
    msg = 'Each element of operating point index must be less than no of operating points';    
else
    ok = 1;
end
   
