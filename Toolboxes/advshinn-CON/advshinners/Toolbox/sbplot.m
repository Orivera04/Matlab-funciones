 function sbplot(v);
% SBPLOT : compatability for subplot in all MATLAB versions.
%
%function sbplot(v);
%
% V : input arguement to subplot, 3 digit number
%
%Utility that does the subplot syntax according to the MATLAB version.
%
if exist('clf');
  i3 = rem(v,10);
  i2 = rem(floor(v/10),10);
  i1 = floor(v/100);
  subplot(i1,i2,i3);
else
  subplot(v);
end;
