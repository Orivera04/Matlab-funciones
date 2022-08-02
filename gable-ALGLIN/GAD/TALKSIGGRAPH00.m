function TALKSIGGRAPH00(GAn)
%TALKSIGGRAPH00: run sample code.

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
  disp('>> % 3 DEMOtrivector');
  if nargin~=0
    DEMOtrivector
  end
end
if nargin==0 | GAn==4 
  disp('>> % 4 DEMOcontainment');
  if nargin~=0
    DEMOcontainment
  end
end
if nargin==0 | GAn==5 
  disp('>> % 5 DEMOinner');
  if nargin~=0
    DEMOinner
  end
end
if nargin==0 | GAn==6 
  disp('>> % 6 DEMOdual');
  if nargin~=0
    DEMOdual
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
  disp('>> % 10 DEMOrotor');
  if nargin~=0
    DEMOrotor
  end
end
if nargin==0 | GAn==11 
  disp('>> % 11 DEMOquaternion');
  if nargin~=0
    DEMOquaternion
  end
end
if nargin==0 | GAn==12 
  disp('>> % 12 DEMOinterpolation');
  if nargin~=0
    DEMOinterpolation
  end
end
if nargin==0 | GAn==13 
  disp('>> % 13 DEMOaffine');
  if nargin~=0
    DEMOaffine
  end
end
if nargin==0 | GAn==14 
  disp('>> % 14 DEMOaffinemeet');
  if nargin~=0
    DEMOaffinemeet
  end
end
if nargin==0 | GAn==15 
  disp('>> % 15 DEMOpappus');
  if nargin~=0
    DEMOpappus
  end
end
   disp(' ');
   if nargin~=0
     disp('End of GAD sequence.  Returning to Matlab.');
   end
catch ; end
