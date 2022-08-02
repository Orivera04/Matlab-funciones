function des = roundfactor(des, factind, method, opt)
%ROUNDFACTOR Round design points
%
%  OUT = ROUNDFACTOR(DES, FACTIND, METHOD, OPT) rounds the values in the
%  FACTIND-th column of the design.  METHOD can be either 'sigfig' or
%  'nearest'.  
%  If method is 'sigfig', OPT is the number of significant figures to round
%  the data to.
%  If method is 'nearest', OPT is the interval to round to, for example
%  OPT=50 rounds to the nearest of 0, 50, 100, 150, etc.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 07:07:39 $ 

% Only edit the non-fixed points
freep = freepoints(des);
data = des.design(freep, factind);
data = invcode(model(des), data, factind);
switch method
    case 'sigfig'
        % Round each number to intervals that are powers of 10.  The power
        % is decided by log-ing the data to decide its magnitude
        if opt<1
            error('mbc:xregdesign:InvalidArgument', ...
                'Number of significant figures must be greater than one.');
        end
        nonzerodata = (data~=0);
        interval = 10.^(floor(log10(abs(data(nonzerodata))))-opt+1);
        data(nonzerodata) = interval.*round(data(nonzerodata)./interval);
    case 'nearest'
        if opt<=0
            error('mbc:xregdesign:InvalidArgument', ...
                'Rounding interval must be greater than zero.');
        end
        data = opt.*round(data./opt);
end
data = code(model(des), data, factind);
des.design(freep, factind) = data;

des.designindex(freep) = 0;
des.designstate = des.designstate + 1;
des = DesignType(des,0,[]);
des = timestamp(des,'stamp');
