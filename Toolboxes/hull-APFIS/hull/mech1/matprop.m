function [value]=matprop (name,constant,USSI)
%MATPROP Material properties look up.
%   MATPROP(NAME,PROPERTY,UNITS) will find the value of a material property
%   given the material name, the property and the unit system, either US or
%   SI units.  Type 'matprop ('list')' to see available materials and 
%   properties.

%   Details are to be found in Mastering Mechanics I, Douglas W. Hull,
%   Prentice Hall, 1998

%   Douglas W. Hull, 1998
%   Copyright (c) 1998-99 by Prentice Hall
%   Version 1.00

if nargin<2
  name='list';
end
if nargin==2
  disp('US or SI units must be specified.')
  return
end
load matprop.mat

[NumMaterials NumConstants]=size(ValuesMatrix);
ColSp=blanks(NumMaterials)';
ColTab=[ColSp ColSp ColSp ColSp ColSp];
RowSp=blanks(NumConstants)';
RowTab=[RowSp RowSp RowSp RowSp RowSp];

if strcmp(name,'list')
  disp(' ');
  disp('Known Materials');
  disp([ColTab(1:NumMaterials/2,:) NamesVector(1:NumMaterials/2,:)]);
  disp(' ');
  disp('Known Constants and their Units (SI/US)');
  disp([RowTab ConstantsVector RowSp UnitsVectorSI RowSp UnitsVectorUS]);
  disp(' ');
disp('The third argument must be either ''SI'' or ''US'' to choose units.');
  disp(' ');
  disp('When specifying arguments to the function, single quotes must');
  disp('be used around all inputs and capitalization must be as shown');
  return
end

if strcmp(USSI,'US')
  SI=0;
elseif strcmp(USSI,'SI')
  SI=1;
else
  disp ('Invalid unit system specification. Try ''SI'' or ''US''.' )
  return
end

rowname=strmatch(name,NamesVector,'exact');
rowSI=find(SIVector==SI);
row=intersect(rowSI,rowname);
col=strmatch(constant,ConstantsVector,'exact');
if isempty(row)
   disp ('Material not found. Try ''list'' for valid choices')
   return
end

if isempty(col)
   disp ('Property not found. Try ''list'' for valid choices')
   return
end

value=ValuesMatrix(row,col);
