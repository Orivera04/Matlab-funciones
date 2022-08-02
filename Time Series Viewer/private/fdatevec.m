function [y,mo,d,h,mi,s] = fdatevec(t,pivotyear)
% FDATEVEC: FDATEVEC is a much Faster version of DATEVEC  
% when the input string array is very large. The fastness comes from 
% implementing a divide-and-conqure strategy in FSTR2NUM, a fast 
% version of STR2NUM, so make sure you also download FSTR2NUM and 
% DIVCONQ before you use this function. You can call FDATEVEC in the
% same way as you call DATEVEC.  FDATEVEC inherits the assumptions on 
% the type of date formats by DATEVEC (see below), but in addition, 
% it also assumes each row of the string array T has the same data format. 
% This additional assumption should be reasonable. I hardly can think why
% one should have different format for each entry of his/her date strings. 
%
% Also see FSTR2NUM, FDATENUM, FDATE_DEMO, DIVCONQ which are all 
% downloadable from the same place as this function.
%
% Zhigang Xu, xuz@dfo-mpo.gc.ca, Sept. 17, 2003
% 
%DATEVEC Date components.
%   C = DATEVEC(T) separates the components of date strings and date
%   numbers into date vectors containing [year month date hour mins
%   secs] as columns.  If T is a date string, it must be in one of the
%   date formats 0,1,2,6,13,14,15,16,23 (as defined by DATESTR).  Date
%   strings with 2 character years are interpreted to be within the 100
%   years centered around the current year.
%
%   [Y,M,D,H,MI,S] = DATEVEC(T) returns the components of the date
%   vector as individual variables.
%
%   [...] = DAVEVEC(T,PIVOTYEAR) uses the specified pivot year as the
%   starting year of the 100-year range in which a two-character year
%   resides.  The default pivot year is the current year minus 50 years.
%
%   Examples
%     d = '12/24/1984';
%     t = 725000.00;
%     c = datevec(d) or c = datevec(t) produce c = [1984 12 24 0 0 0].
%     [y,m,d,h,mi,s] = datevec(d) returns y=1984, m=12, d=24, h=0, mi=0, s=0.
%     c = datevec('5/6/03') produces c = [2003 5 6 0 0 0] until 2054.
%     c = datevec('5/6/03',1900) produces c = [1903 5 6 0 0 0].
%
%   See also DATENUM, DATESTR, CLOCK, DATETICK.

%   Copyright 1984-2001 The MathWorks, Inc. 
%   $Revision: 1.26 $  $Date: 2001/04/15 12:03:23 $

if isstr(t) | iscell(t)
   if isstr(t)
      m = size(t,1);
   else
      m = length(t);
   end
   y = zeros(m,6);
   for i = 1:1
      % Convert date input to date vector
      % Initially, the six fields are all unknown.
      c(1,1:6) = NaN;
      pm = -1; % means am or pm is not in datestr
      if isstr(t)
         str = lower(t(i,:));
      else
         str = lower(t{i});
      end
      d = [' ' str ' '];
      
      % Replace 'a ', 'am', 'p ' or 'pm' with ': '.
      
      p = max(find(d == 'a' | d == 'p'));
      if ~isempty(p)
         if (d(p+1) == 'm' | d(p+1) == ' ') & d(p-1) ~= lower('e')
            pm = (d(p) == 'p');
            if d(p-1) == ' '
               d(p-1:p+1) = ':  ';
            else
               d(p:p+1) = ': ';
            end
         end
      end
      
      % Any remaining letters must be in the month field
      p = find(isletter(d));
      if ~isempty(p)
         k = min(p);
         if d(k+3) == '.', d(k+3) = ' '; end
         M = ['jan'; 'feb'; 'mar'; 'apr'; 'may'; 'jun'; ...
              'jul'; 'aug'; 'sep'; 'oct'; 'nov'; 'dec'];
         c(2) = find(all((M == d(ones(12,1),k:k+2))'));
         d(p) = setstr(' '*ones(size(p)));
      end
      mop=p-1;      
      % Find all nonnumbers.
      
      p = find((d < '0' | d > '9') & (d ~= '.'));
      
      % Pick off and classify numeric fields, one by one.
      % Colons delinate hour, minutes and seconds.
      
      k = 1;
      while k < length(p)
         if d(p(k)) ~= ' ' & d(p(k)+1) == '-'
            f = str2double(d(p(k)+1:p(k+2)-1));
            k = k+1;
         else
            f = str2double(d(p(k)+1:p(k+1)-1));
         end
         if ~isnan(f)
            if d(p(k))==':' | d(p(k+1))==':'
               if isnan(c(4))
                  c(4) = f;             % hour
                  hp = [p(k)+1:p(k+1)-1]-1;
                  if pm == 1 & f ~= 12 % Add 12 if pm specified and hour isn't 12
                     c(4) = f+12;
                  elseif pm == 0 & f == 12
                     c(4) = 0;
                  end
               elseif isnan(c(5))
                  c(5) = f;             % minutes
                  mip = [p(k)+1:p(k+1)-1]-1;
               elseif isnan(c(6)) 
                  c(6) = f;             % seconds
                  sp = [p(k)+1:p(k+1)-1]-1;
               else
                  error(['Too many time fields in ' str])
               end
            elseif isnan(c(2))
               if f > 12
                  error([num2str(f) ' is too large to be a month.'])
               end
               c(2) = f;                % month
               mpo = [p(k)+1:p(k+1)-1]-1;
            elseif isnan(c(3))
               c(3) = f;                % date
               dp = [p(k)+1:p(k+1)-1]-1;
            elseif isnan(c(1))
               if (f >= 0) & (p(k+1)-p(k) == 3) % two char year
                  if nargin < 2
                    clk = clock;
                    pivotyear = clk(1)-50;  % (current year - 50 years)
                  end
                  % Moving 100 year window centered around current year
                  c(1) = pivotyear + rem(f + 100 - rem(pivotyear,100),100);
                  yp = [p(k)+1:p(k+1)-1]-1;
               else
                  c(1) = f;             % year
                  yp = [p(k)+1:p(k+1)-1]-1;
               end
            else
               error(['Too many date fields in ' str])
            end
         end
         k = k+1;
      end

      if sum(isnan(c)) >= 5
         error(['Cannot parse date ' str])
      end

      % If the any of the day fields have been set, set an unspecified
      % year to the current year
      if isnan(c(1)) & any(~isnan(c(2:3))), clk = clock; c(1) = clk(1); end
      
      % If any field has not been specified, set it to zero. 
      p = find(isnan(c));
      if ~isempty(p)
         c(p) = zeros(1,length(p));
      end
      
      % Normalize components to correct ranges.
      y(i,:) = datevecmx(datenummx(c));
   end
   
%    ind.yp=yp; ind.mop=mop; ind.dp=dp; ind.hp=hp; ind.mip=mip; ind.sp=sp;
   
   if isletter(t(1,mop))
        i=strmatch('jan',lower(t(:,mop)));
        if ~isempty(i), t(i,mop)=repmat('001', size(i)); end
        
        i=strmatch('feb',lower(t(:,mop)));
        if ~isempty(i), t(i,mop)=repmat('002', size(i)); end
        
        i=strmatch('mar',lower(t(:,mop)));
        if ~isempty(i), t(i,mop)=repmat('003', size(i)); end
        
        i=strmatch('apr',lower(t(:,mop)));
        if ~isempty(i), t(i,mop)=repmat('004', size(i));  end

        i=strmatch('may',lower(t(:,mop)));
        if ~isempty(i), t(i,mop)=repmat('005', size(i)); end
        
        i=strmatch('jun',lower(t(:,mop)));
        if ~isempty(i), t(i,mop)=repmat('006', size(i));  end
        
        i=strmatch('jul',lower(t(:,mop)));
        if ~isempty(i), t(i,mop)=repmat('007', size(i)); end
        
        i=strmatch('aug',lower(t(:,mop)));
        if ~isempty(i), t(i,mop)=repmat('008', size(i)); end

        i=strmatch('sep',lower(t(:,mop)));
        if ~isempty(i), t(i,mop)=repmat('009', size(i));  end
        
        i=strmatch('oct',lower(t(:,mop)));
        if ~isempty(i), t(i,mop)=repmat('010', size(i));  end
        
        i=strmatch('nov',lower(t(:,mop)));
        if ~isempty(i), t(i,mop)=repmat('011', size(i)); end
        
        i=strmatch('dec',lower(t(:,mop)));
        if ~isempty(i), t(i,mop)=repmat('012', size(i)); end    
   end
   
   y =  fstr2num(t(:, yp ));
   mo = fstr2num(t(:, mop));
   d =  fstr2num(t(:, dp ));
   h =  fstr2num(t(:, hp ));
   mi = fstr2num(t(:, mip));
   s  = fstr2num(t(:, sp ));
   
   
   i = find(y<100); % two char year
   if ~isempty(i)
       if nargin < 2
          clk = clock;
          pivotyear = clk(1)-50;  % (current year - 50 years)
        end
       % Moving 100 year window centered around current year
         y(i) = pivotyear + rem(y(i) + 100 - rem(pivotyear,100),100);
    end
     
   
   if nargout <= 1
       y=[y mo d  h mi s];
   end
   
elseif nargout <= 1
   y = datevecmx(t);
elseif nargout == 3
   [y,mo,d] = datevecmx(t);
else
   [y,mo,d,h,mi,s] = datevecmx(t);
end

