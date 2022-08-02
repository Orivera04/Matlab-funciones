function [forces]=fixedfixed(x,s,m,a,L,E,I)
%FIXEDFIXED Redundant support moments and forces.
%   FIXEDFIXED(X,SHEAR,MOMENT,PLACEMENT,L,E,I) will find the redundant 
%   moment at the fixed supports and the force supplied by any redundant pin 
%   supports along the length of the beam.
%
%   SHEAR is the shear acting along the beam, this should be created with 
%     the DIAGRAM routine.  It does not have to be summed into a single
%     vector for use in the routine.
%   MOMENT is the moment acting along the beam, this should be only the
%     point moments created with the DIAGRAM routine.  It does not have to 
%     be summed into a single vector for use in the routine.  It should not
%     include the integral of the shear as created with the  routine 
%     DIAGRAMINTEGRAL.
%   PLACEMENT is a vector with the location of every pin support.
%   L is the length of the beam.
%   E is the Young's modulus.
%   I is the area moment of inertia of the beam cross section.
%
%   See also DISPLACE, FIXEDPIN, PINPIN.

%   Details are to be found in Mastering Mechanics I, Douglas W. Hull,
%   Prentice Hall, 1998

%   Douglas W. Hull, 1998
%   Copyright (c) 1998-99 by Prentice Hall
%   Version 1.00

b=L-a;

[ShearRows, ShearCols]=size(s);
[MomentRows, MomentCols]=size(m);

if ShearRows>1
  Shear=sum(s);
else
  Shear=s;
end

if MomentCols==1 %just sent a dummy
  Moment=diagramintegral(x,Shear);
else
  m(MomentRows+1,:)=diagramintegral(x,Shear);
  Moment=sum(m);
end

[d sl]=displace(x,Moment,['place' 'place'],[0 L],E,I);

Deltas(1)=-interpolate(x,sl,0);
Deltas(2)=-interpolate(x,sl,L);
coefs=[2*L^2 -L^2;-L^2 2*L^2]/(6*E*I*L);

if a~=0
  i=1;
  for gapli=3:length(a)+2;
    Deltas(gapli)=-interpolate(x,d,a(gapli-2));
    i=i+1;
  end
  SubSca=[2*L^2 -L^2;-L^2 2*L^2];
  SubCol=[(a.*((a.^2)-(3*L*a)+(2*L^2)))' -((L-a).*(((L-a).^2)-(3*L*(L-a))+(2*L^2)))'];
  SubRow=[(a.*b.*(L+b));-(a.*b.*(L+a))];
  SubMat=makepins(a,L,0);
  coefs=[SubSca SubRow; SubCol SubMat]/(6*E*I*L);
end
forces=inv(coefs)*Deltas';

