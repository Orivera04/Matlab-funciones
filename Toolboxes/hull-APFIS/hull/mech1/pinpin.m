function [forces]=pinpin(x,s,m,a,EndSupports,E,I)
%PINPIN Redundant support forces.
%   PINPIN(X,SHEAR,MOMENT,PLACEMENT,ENDS,L,E,I) will find the redundant 
%   forces supplied by any redundant pin support along the length of the 
%   beam.
%
%   SHEAR is the shear acting along the beam, this should be created with 
%     the DIAGRAM routine.  It does not have to be summed into a single 
%     vector for use in the routine.
%   MOMENT is the moment acting along the beam, this should be only the
%     point moments created with the DIAGRAM routine.  It does not have to 
%     be summed into a single vector for use in the routine.  It should not
%     include the integral of the shear as created with the routine 
%     DIAGRAMINTEGRAL.
%   PLACEMENT is a vector with the location of every pin support.
%   ENDS is the placement of the two outermost pin supports along the length
%     of the beam.
%   L is the length of the beam, may extend beyond the pin supports.
%   E is the Young's modulus.
%   I is the area moment of inertia of the beam cross section.
%
%   See also DISPLACE, FIXEDFIXED, FIXEDPIN.

%   Details are to be found in Mastering Mechanics I, Douglas W. Hull,
%   Prentice Hall, 1998

%   Douglas W. Hull, 1998
%   Copyright (c) 1998-99 by Prentice Hall
%   Version 1.00


[ShearRows, ShearCols]=size(s);
[MomentRows, MomentCols]=size(m);

Shear=sum(s,1);

if MomentCols==1 %just sent a dummy
  Moment=diagramintegral(x,Shear);
else
  m(MomentRows+1,:)=diagramintegral(x,Shear);
  Moment=sum(m);
end;

d=displace(x,Moment,['place' 'place'],EndSupports,E,I);

for gapli=1:length(a);
  Deltas(gapli)=-interpolate(x,d,a(gapli));
end

L=EndSupports(2)-EndSupports(1);
a=a-EndSupports(1);
b=L-a;
coefs=makepins(a,L,0)/(6*E*I*L);


forces=inv(coefs)*Deltas';
