function [Svect,Name,Ver]=mbcaddonscan(fname,defS)
%MBCADDONSCAN  Scan for additional features
%
%  SVECT=MBCADDONSCAN(MARKERFILE, DEFS)
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.5.2.2 $  $Date: 2004/02/09 06:48:43 $

if ~isempty(fname)
   % scan MATLAB path for instances of file
   loc=which('-all',fname);
   k=1;
   Svect=defS;
   Name={};
   Ver={};
   [nul,mbcv]=mbcver;
   for n=1:length(loc)
      try
         contents=load('-mat',loc{n});
         if isfield(contents,'MBC_EXTENSION_FILE')
            if contents.MBC_EXTENSION_FILE            % Provides simple way of disabling extras package
               % scope for checking the extensionversion field too at this point
               if mbcv >= contents.MinimumMBCVersion        % check that mbc version satisfies min requirements of package
                  UDfiles=contents.ExtensionMFiles;
                  % loop over extender providers
                  for m=1:length(UDfiles)
                     Svect(k) = feval(UDfiles{m},defS);
                     k = k+1;
                  end
                  Name=[Name {contents.Name}];
                  Ver=[Ver {contents.Version}];
               end
            end
         end
      end
   end
else
   Svect=defS;
   Name={};
   Ver={};
end