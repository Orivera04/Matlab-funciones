function qr = getFitType(m)
%GETFITTYPE 

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:48:08 $

om = getFitOpt(m);
name = lower(getname(om));
switch name
    case 'uga2'
        qr= i_FindType(m,get(om,'CenterSelectionAlg'));
    case 'smoothspl'
        qr= 'smoothspl';
    case {'trialwidths','twostep','interlace'}
        qr = getFitType(m.rbfpart);
    otherwise
        error('mbc:xreghybridrbf:InvalidState', ...
            'Cannot determine FitType.');
end
 