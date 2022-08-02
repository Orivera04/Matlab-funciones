function TALKASCI01(GAn)
%TALKASCI01: run sample code.

try
if nargin==0 | GAn==1 
  disp('>> % 1 DEMOvectors');
  if nargin~=0
    DEMOvectors
  end
end
if nargin==0 | GAn==2 
  disp('>> % 2 DEMOouter');
  if nargin~=0
    DEMOouter
  end
end
if nargin==0 | GAn==3 
  disp('>> % 3 DEMOcontainment');
  if nargin~=0
    DEMOcontainment
  end
end
if nargin==0 | GAn==4 
  disp('>> % 4 DEMOinner');
  if nargin~=0
    DEMOinner
  end
end
if nargin==0 | GAn==5 
  disp('>> % 5 DEMOdual');
  if nargin~=0
    DEMOdual
  end
end
if nargin==0 | GAn==6 
  disp('>> % 6 DEMOinvertible');
  if nargin~=0
    DEMOinvertible
  end
end
if nargin==0 | GAn==7 
  disp('>> % 7 DEMOgeoprod');
  if nargin~=0
    DEMOgeoprod
  end
end
if nargin==0 | GAn==8 
  disp('>> % 8 DEMOproj');
  if nargin~=0
    DEMOproj
  end
end
if nargin==0 | GAn==9 
  disp('>> % 9 DEMOplanerot');
  if nargin~=0
    DEMOplanerot
  end
end
if nargin==0 | GAn==10 
  disp('>> % 10 DEMOrotdefinition');
  if nargin~=0
    DEMOrotdefinition
  end
end
if nargin==0 | GAn==11 
  disp('>> % 11 DEMOrotreflect');
  if nargin~=0
    DEMOrotreflect
  end
end
if nargin==0 | GAn==12 
  disp('>> % 12 DEMOrotor');
  if nargin~=0
    DEMOrotor
  end
end
if nargin==0 | GAn==13 
  disp('>> % 13 DEMOquaternion');
  if nargin~=0
    DEMOquaternion
  end
end
if nargin==0 | GAn==14 
  disp('>> % 14 DEMOinterpolation');
  if nargin~=0
    DEMOinterpolation
  end
end
if nargin==0 | GAn==15 
  disp('>> % 15 DEMOmeetlineplane');
  if nargin~=0
    DEMOmeetlineplane
  end
end
if nargin==0 | GAn==16 
  disp('>> % 16 DEMOmeetplanes');
  if nargin~=0
    DEMOmeetplanes
  end
end
if nargin==0 | GAn==17 
  disp('>> % 17 DEMOaffine');
  if nargin~=0
    DEMOaffine
  end
end
if nargin==0 | GAn==18 
  disp('>> % 18 DEMOaffinemeet');
  if nargin~=0
    DEMOaffinemeet
  end
end
if nargin==0 | GAn==19 
  disp('>> % 19 DEMOtriangle');
  if nargin~=0
    DEMOtriangle
  end
end
if nargin==0 | GAn==20 
  disp('>> % 20 DEMOspinorderivative');
  if nargin~=0
    DEMOspinorderivative
  end
end
if nargin==0 | GAn==21 
  disp('>> % 21 DEMOdiffinv');
  if nargin~=0
    DEMOdiffinv
  end
end
if nargin==0 | GAn==22 
  disp('>> % 22 DEMOdiffunit');
  if nargin~=0
    DEMOdiffunit
  end
end
if nargin==0 | GAn==23 
  disp('>> % 23 DEMOdiffrefl');
  if nargin~=0
    DEMOdiffrefl
  end
end
   disp(' ');
   if nargin~=0
     disp('End of GAD sequence.  Returning to Matlab.');
   end
catch ; end
