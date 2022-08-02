function keep = isCloseToMbt(SPK, TQ, LOGNO, delta)
%ISCLOSETOMBT Limit points to be "close" to MBT
%
%  KEEP = ISCLOSETOMBT(SPK, TQ, LOGNO)
%  KEEP = ISCLOSETOMBT(SPK, TQ, LOGNO, delta)
%  KEEP = ISCLOSETOMBT(SPK, TQ, LOGNO, [a, b])

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.4.1 $    $Date: 2004/04/22 01:36:26 $ 

if nargin < 4,
    delta_low  = 16;
    delta_high = 16;
elseif numel( delta ) == 1,
    delta_low  = delta;
    delta_high = delta;
else
    delta_low  = delta(1);
    delta_high = delta(2);
end

keep = true( size( LOGNO ) );

logNumbers = unique( LOGNO );
logNumbers = logNumbers(:)';

for i = logNumbers,
    j = find( LOGNO == i );
    spk = SPK(j);
    
    % fit a quadratic to sweep i
    p = polyfit( spk, TQ(j), 2 ); 
    
    % the maximum (mbt) is half way between the roots
    mbt = mean( roots( p ) );

    % only keep those points within delta degrees of MBT
    keep(j) = (spk > mbt - delta_low) & (spk < mbt + delta_high);
end
