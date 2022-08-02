function F = Frame(fname,v1,v2,v3,n1,n2,n3)
%Frame(fname,v1,v2,v3,n1,n2,n3): Creates a frame for GA basis vectors 
%Takes a name, and three linearly independent vectors (of type GA) 
% and optionally the three vectors can be named, 
%If they are not named, then the names are the frame name followed by 
% 1,2, or 3 respectively.
%
%See also gable, FE, OFrame.

% GABLE, Copyright (c) 1999, University of Amsterdam
% Copying, use and development for non-commercial purposes permitted.
%          All rights for commercial use reserved; for more information
%          contact Leo Dorst (leo@wins.uva.nl).
%
%          This software is unsupported.
 if nargin < 4
    disp('The frame needs a name, and three linearly independent vectors.');
    F.m=eye(8);
    F.b1='e1';
    F.b2='e2';
    F.b3='e3';
 else
    if nargin < 7
       n1=[fname,'1'];
       n2=[fname,'2'];
       n3=[fname,'3'];
    else
    end
    if isa(v1,'GA')&isa(v2,'GA')&isa(v3,'GA')
       E=v1^v2^v3;
       EM=E.m;
       W=EM(8);
       if W == 0
	  disp('The frame needs three linearly independent vectors.');
	  F.m=eye(8);
	  F.b1='e1';
	  F.b2='e2';
	  F.b3='e3';
       else
	  r1=(1/W)*Edual(v2^v3);
	  r2=(1/W)*Edual(v3^v1);
	  r3=(1/W)*Edual(v1^v2);
%Bivectors
	  r12=r1^r2;
	  r23=r2^r3;
	  r31=r3^r1;
	  G=[1,0,0,0,0,0,0,0; 
	     r1.m'; 
	     r2.m'; 
	     r3.m';
	     r12.m';
	     r23.m';
	     r31.m';
	     0,0,0,0,0,0,0,1/W];
	  F.m=G;
	  F.b1=n1;
	  F.b2=n2;
	  F.b3=n3;
       end
    else
       disp('The frame needs three linearly independent vectors.');
       F.m=eye(8);
       F.b1='e1';
       F.b2='e2';
       F.b3='e3';
    end
 end
