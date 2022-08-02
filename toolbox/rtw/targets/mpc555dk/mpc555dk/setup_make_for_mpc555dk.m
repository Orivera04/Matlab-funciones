function makeCmdOut = setup_make_for_mpc555dk(args)
%
% Function: setup_make_for_mpc555dk ========================================================
% Abstract:
%       Configures the initialization for the makefile for
%       all mpc555 template makefile invocations

%   Copyright 2003 The MathWorks, Inc.
%   $Revision: 1.1.6.1 $  $Date: 2003/07/31 18:09:51 $
  makeCmd        = args.makeCmd;
  modelName      = args.modelName;
  verbose        = args.verbose;

  cmdFile = ['.\',modelName, '.bat'];
  cmdFileFid = fopen(cmdFile,'wt');
  if ~verbose
     fprintf(cmdFileFid, '@echo off\n');
  end
  fprintf(cmdFileFid, 'set MATLAB=%s\n', strrep(matlabroot,'\', '/'));
  fprintf(cmdFileFid, '%s\n', makeCmd );
  fclose(cmdFileFid);
  makeCmdOut = cmdFile;
