function out=get(obj,param)
% GET  Get csetInterface information
%
%   Valid operations via get are:
%
%     'FullNames'
%     'ShortNames'
%     'ClassNames'
%     'TypeIDs'
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.5.2.2 $  $Date: 2004/02/09 07:02:24 $

% Created 5/11/2000

% CSET_INFO is a cell array.  Each row contains info on a candidate set class
%  Each row has 4 columns:  {Class Name | Full Name | Short Name | Type ID}
persistent  CSET_INFO

% test whether to initialise CSET_INFO
if isempty(CSET_INFO)
   CSET_INFO=i_initinfo;
end



switch lower(param)
case 'fullnames'
   INFO_TMP=i_filter(obj,CSET_INFO);
   out=INFO_TMP(:,2);
case 'shortnames'
   INFO_TMP=i_filter(obj,CSET_INFO);
   out=INFO_TMP(:,3);
case 'classnames'
   INFO_TMP=i_filter(obj,CSET_INFO);
   out=INFO_TMP(:,1);
case 'typeids'
   INFO_TMP=i_filter(obj,CSET_INFO);
   out=INFO_TMP(:,4);
case 'nflimits'
   INFO_TMP=i_filter(obj,CSET_INFO);
   out=INFO_TMP(:,5:7);
case 'typefilter'
   out=obj.filtertype;   
case 'dorehash'
   % secret option: redo the class finding
   CSET_INFO=i_initinfo;
   out=1;
case 'clean'
   clear CSET_INFO
   out=1;
end

return


function out=i_filter(obj,in);
% filter if filter is on
if ~isempty(obj.filtertype)
   out= i_filterinfo(in, obj.filtertype);
else
   out= in;
end
% filter by number of factors
if ~isnan(obj.filternf)
   out= i_filterinfo_by_nf(out, obj.filternf);
end



function out=i_initinfo
funcs=which('-all','CandidateSetInformation');
nfuncs=length(funcs);
out=cell(nfuncs,7);
del=[];
for n=1:nfuncs
   func=funcs{n};
   % find "@"
   ind=findstr('@',func);
   if ~isempty(ind)
      % strip off "\CandidateSetInformation.m"
      func((end-25):end)=[];
      func=func((ind(end)+1):end);
      out(n,1)={func};
      try
         obj=feval(func);
         [out{n,2} out{n,3} out{n,4}]= CandidateSetInformation(obj);
         % add limit information
         [out{n,5} out{n,6} out{n,7}]=supportednfactors(obj);
      catch
         del=[del n];
      end
   else
      del=[del n];
   end
end
if ~isempty(del)
   out(del,:)=[];
end
out=sortrows(out,1);
return



function out = i_filterinfo(in,type)
if size(in,1)
   match=false(size(in,1),1);
   for n=1:length(type)
      for m=1:size(in,1)
          match(m)=match(m) | any(in{m,4}==type(n));
      end
   end
   out=in(match,:);   
else
   out=in;
end
return

function out=i_filterinfo_by_nf(in, nf)
if size(in,1)
   match=false(size(in,1),1);
   for k=1:length(match)
      if nf>=in{k,5} & nf<=in{k,6} & (isempty(in{k,7}) | any(in{k,7}==nf))
         match(k)=1;
      end
   end
   out=in(match,:); 
else
   out=in;
end
return