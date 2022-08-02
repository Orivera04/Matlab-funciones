function [ok,outids]= mbcchecklicenses(ids)
%MBCCHECKLICENSES  attempt to checkout licenses for MBC Toolbox
%
%  [ok, ids]=mbchecklicenses(ids) attempts to checkout the licenses
%  identified by the codes in the vector ids.  If all the licenses 
%  are available, ok is set to 1 and the output ids is empty.  If any
%  licenses fail, an error dialog is displayed explaining the error, 
%  the ok flag is set to 0 and the output ids is set to the code(s) 
%  that failed.
%
%  The list of valid ids may be found in the help for mbccheckoutlic

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.4.2 $  $Date: 2004/02/09 06:48:46 $


ok=1;
outids=[];
errstr={};
for n=1:length(ids)
   localok=mbccheckoutlic(ids(n));
   if ~localok
      % append an error string
      errstr(end+1)=i_codes_to_licenses(ids(n));
      outids(end+1)=ids(n);
   end
   ok=ok&localok;
end

if ~ok
   % display error
   if length(outids)==1
      str={'The following necessary product is not available';...
            'from your license server:';...
            '';...
            ['\bullet    ' errstr{1}];...
            '';...
            'Please contact your System Administrator to ensure that';...
            'you have access to this product.'
      };
   else
      str={'The following necessary products are not available';...
            'from your license server:';...
            ''};
      for n=1:length(errstr)
         str=[str; {['\bullet    ' errstr{n}]}];
      end
      str=[str; {'';...
               'Please contact your System Administrator to ensure that';...
               'you have access to these products.'
         }];
   end
   opts.Interpreter='Tex';
   opts.WindowStyle='modal';
   h=errordlg(str,'Error',opts);
   drawnow;
   waitfor(h);   
end
return



function strings=i_codes_to_licenses(codes)
lics={'Simulink', 'StateFlow', 'Statistics Toolbox', 'Neural Networks Toolbox',...
      'Optimisation Toolbox', 'Report Generator', 'Extended Symbolic Toolbox',...
      'Simulink Report Generator', 'Symbolic Toolbox'};
strings=cell(size(codes));
for n=1:length(codes)
   strings(n)=lics(codes(n)+1);
end
