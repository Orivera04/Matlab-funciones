function [OK,s]= isProjectFile(MP,Filename)
% MDEVPROJECT/ISPROJECTFILE
%
%  OK= isProjectFile(MP,Filename);
% Inputs
%   MP         mdevproject object
%   Filename   name of project file
% Output
%   OK         true if file is a project file

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.5.4.2 $  $Date: 2004/02/09 08:03:34 $



if nargin==1
   Filename= MP.Filename;
end

if exist(Filename,'file')
   try
      s= whos('-file',Filename);
      if length(s)~=1 | (~strcmp(s.name,'MP') & ~strcmp(s.name,'Project'))
         OK= false;
      else
         OK= true;
      end
   catch
      OK=false;
      s=[];
   end
else
   OK= false;
   s=[];
end

