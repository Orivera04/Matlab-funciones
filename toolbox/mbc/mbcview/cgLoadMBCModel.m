function [OK, msg, out] = cgLoadMBCModel(filename, out)

% out.models is a cell array of MBC models 
%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.6.4.4 $  $Date: 2004/02/09 08:39:13 $

OK = 0;
msg = '';

warnstate = warning;
warning off;
try  
    lastwarn('');
    s = load(filename , '-mat');
    if ~isempty(lastwarn) & exist('mv2mbc.m','file')
        newname = [tempname,'.exm'];
        matconvert(filename, newname, mv2mbc);
        s = load(newname , '-mat');
        delete(newname);
    end
    warning(warnstate);
catch
    warning(warnstate);
    msg = 'Cannot read file.  It is missing or contains invalid data.';
    return;
end


fields = fieldnames(s);
if length(fields) > 1
    OK = 0;
    msg = ['Too many variables found in the EXM file ' filename '.'];
    return;
end

mod = s.(fields{1});

if isa(mod , 'xregexportmodel')
    % replace the model name with the field name when we have only
    % one model.  This is ugly, but see G168686
    mod = setname(mod,fields{1});
    out.models = {mod};
    OK = 1;
    msg = '';
elseif isa(mod , 'cell')
   modelList = [];
   count = 0;
   for i = 1:length(mod)
      % pull off the export models
      if isa(mod{i} , 'xregexportmodel')
         count = count + 1;
         modelList = [modelList mod(i)];
      end
   end
   
   if count == 0
      OK = 0;
      msg = 'No MBC models found in the .EXM file.';
      return;
   end
   
    out.models = modelList;
    OK = 1;
    msg = '';
 
else
   OK = 0;
   msg = 'No MBC models found in the .EXM file.';
   return;
end

