function visdems
%VISDEMS For setting up visualization demos from the MATLAB Expo.

%	Ned Gulley, 6-21-93
%	Copyright (c) 1984-94 by The MathWorks, Inc.

labelList=str2mat( ...
	'Images and Colormaps', ...
	'Viewing a Penny', ...
	'Earth''s Topography', ...
	'Superquadrics', ...
	'Fourier Series');

nameList=str2mat( ...
	'imagedemo', ...
	'penny', ...
	'earthmap', ...
	'sqdemo', ...
	'xfourier');

comp=computer;
if comp(1:2)~='PC' & comp(1:2)~='MA',
    labelList=str2mat(labelList,'Hurricane Andrew');
    nameList=str2mat(nameList,'andrew');
end;

if isstudent
    labelList(3,:) = [];
    nameList(3,:) = [];
    labelList(2,:) = [];
    nameList(2,:) = [];
end

cmdlnwin(labelList,nameList);
