function regcw(obj, action, bindir, varargin)
% regcw(this, action, bindir)
%
% Abstract : 
%  Register / unregister CodeWarrior ActiveX Support
%
% Arguments :
%  this        -   mpc555_tgtaction object
%  action		-   'register' : Register CodeWarrior ActiveX Support
%                  'unregister': Unregister CodeWarrior ActiveX Support
%  bindir		-   Path to CodeWarrior installation bin dir 
%
% Usage :
%
%	regcw(obj, 'register', 'd:\Metrowerks\CodeWarrior8\bin')  - register support
%	regcw(obj, 'unregister', 'd:\Metrowerks\CodeWarrior8\bin')  - unregister support
%
%  Please note: UNC paths are not supported.

% Copyright 2004 The MathWorks, Inc.
% $Revision: 1.1.6.1 $ 
% $Date: 2004/03/15 22:23:38 $

   thisdir = fileparts(mfilename('fullpath'));
   switch lower(action)
   case 'register'
      batchfile = fullfile(thisdir, 'regservers.bat');
   case 'unregister'
      batchfile = fullfile(thisdir, 'unregservers.bat');
   otherwise 
      error('Unknown action!');
   end

   % get drive from bindir
   drive = bindir(1:2);

   cmd = [batchfile ' ' drive ' ' bindir ' /s'];
   disp('----------------------------------------------------------------------------------');
	disp(cmd);
	disp('----------------------------------------------------------------------------------');
   
   [s] = system(cmd);
   % check for error
   if s ~= 0
      error(sprintf('Error trying to register CodeWarrior DLLS!\n\n'));
   end;
