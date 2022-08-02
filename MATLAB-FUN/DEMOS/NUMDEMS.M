function numdems
%NUMDEMS For setting up numeric computation demos from the MATLAB Expo.

%	Ned Gulley, 6-21-93
%	Copyright (c) 1984-94 by The MathWorks, Inc.

labelList=str2mat( ...
	'Spectral Analysis', ...
	'Census Example', ...
	'Graphics Input', ...
	'ODEs', ...
	'Quadrature', ...
	'Zerofinding', ...
	'Function Plot');

nameList=str2mat( ...
	'fftdemo', ...
	'census', ...
	'spline2d', ...
	'odedemo', ...
	'quaddemo', ...
	'zerodemo', ...
	'fplotdemo');

if ~isstudent
	labelList=str2mat( ...
	    'Earthquake Example', ...
	    'MATLAB Benchmark');
	nameList=str2mat( ...
	    'quake', ...
	    'bench');
end

cmdlnwin(labelList,nameList);
