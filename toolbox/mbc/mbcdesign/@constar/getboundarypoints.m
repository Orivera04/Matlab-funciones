function [c, bp] = getboundarypoints( c, X )
%GETBOUNDARYPOINTS Find those points that are on the boundary
%
%  [CON,IND] = GETBOUNDARYPOINTS(CON,X)
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.5.6.1 $    $Date: 2004/02/09 06:57:43 $ 

X = X(:,variables( c ));

om = getbdrypointoptions( c );
[c, bp, R] = run( om, c, X, c.Center );

om = set( om, 'ActualDilationRadius', R );
c = setbdrypointoptions( c, om );
