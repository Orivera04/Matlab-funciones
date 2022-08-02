echo off
%The MODERN CONTROL SYSTEM THEORY AND DESIGN (MCSTD) TOOLBOX is breifly
%described in the MCSTD readme file.  This demonstration m-file was created
%to give the user a breif overview of the various utilities included in the
%MCSTD Toolbox and its interaction with other MathWorks toolboxes.  Help for 
% each utility is displayed.
%
%       MCTSD Toolbox feature demonstrations:
%
%       1) General Purpose Utilities
%       2) Linear, Frequency Domain, Bode Diagram
%       3) Linear, Frequency Domain, Nichols Chart
%       4) Linear, Frequency Domain, Root Locus
%       5) Non-Linear, Frequency Domain
%       6) Linear, Time Domain
%       7) Conversions between Discrete Time and Continuous Time Systems
%
%       0) Quit
%
% When plots are completed (if generated), press any key to continue
%
% If out of memory occurs, do each: "clear;", "clg;", "pack;", and restart demo.
while (1)
	clc,clg, help mcstd
	kk = input('Select a Demo number: ');
	if (kk==0), clear kk name; break; end;
	if (~ isempty(kk))
	  name = ['mcstd' num2str(kk)];
	  if exist(name), eval(name); end;
	end;
end;
clear kk name;
