function ver(arg)
%VER	MATLAB version number.
%	VER displays the current MATLAB and toolbox version numbers.
%	VER(TBX) displays the current version information for the
%	toolbox specified by the string TBX.

%	Copyright (c) 1984-94 by The MathWorks, Inc.

p = path;
pathsep = ':';
filesep = '/';
c = computer;
sys = 'u';
if strcmp(c(1:2),'PC')
   pathsep = ';';
   filesep = '\';
   sys = 'p';
elseif strcmp(c(1:2),'MA')
   pathsep = ';';
   filesep = ':';
   sys = 'm';
elseif isvms
   pathsep = ',';
   filesep = '.';
   sys = 'v';
end
seps = find(p == pathsep);
first = [1 seps+1];
last = [seps-1 length(p)];
n = length(first);
if nargin > 0
   larg = length(arg);
   if strcmp('matlab',lower(deblank(arg)))
       disp(['MATLAB Version ',version]);
       if sys == 'v' | sys == 'u'
          disp(['MATLAB Server Hostid: ',hostid])
       end
       disp(['MATLAB Site Identification Number: ',siteid]);
       arg = 'general';
       larg = length(arg);
   end
   for i=1:n
      pp = p(first(i):last(i));
      lp = length(pp);
      if lp >= larg
         if sys == 'v'
            if lp-larg < 1
               scret = 0;
            else
               scret = strcmp(arg,pp(lp-larg:lp-1));
            end
         else
            scret = strcmp(arg,pp(lp-larg+1:lp));
         end

         if scret
            if sys == 'v'
               file = [pp 'Contents.m'];
            else
               file = [pp filesep 'Contents.m'];
            end
            if exist(file) == 2
               c = computer;
               if c(1:2) == 'PC'
                  fp = fopen(file,'rb');
               else
                  fp = fopen(file,'r');
               end
               s = [fgetl(fp) '  '];
               s1 = [fgetl(fp) '  '];
               s(1:2) = [];
               s1(1:2) = [];
               if strcmp(deblank(lower(arg)),'general')
                  disp(s1)
               else
                  disp([s '  ' s1])
               end
               fclose(fp);
            else
               disp(['No Contents.m file for ' pp])
            end
         end
      end
   end
   return
end
% before we do this, we want to strip off the MATLAB portion of the
% path because we don't want to see all the separate Contents.m files
% for the MATLAB toolbox --- at the moment, there are 20 MATLAB directories.
disp(['MATLAB Version ',version]);
if sys == 'v' | sys == 'u'
   disp(['MATLAB Server Hostid: ',hostid])
end
disp(['MATLAB Site Identification Number: ',siteid]);
for i=1:n
   pp = p(first(i):last(i));
% don't do ones with toolbox/matlab/*
% or toolbox/local (or PC, VMS, or MAC equivs)
% peel apart name
   mlorloc = 0;
% find fileseps within this
   filind = find(pp == filesep);
   filind = [0 ; filind(:)];
   nsep = length(filind);
   if sys == 'v'
      nsep = nsep + 1;
      if nsep > 2,
         filind = [0 ; filind(:)];
      end
   end
% check for toolbox/local last
   last2 = pp(filind(nsep-1)+1:length(pp));
   last1 = deblank(lower(pp(filind(nsep)+1:length(pp))));
   if sys == 'v'
      loc = strcmp(lower(last2),['toolbox:[local]']);
   else
      loc = strcmp(lower(last2),['toolbox' filesep 'local']);
   end
   ml = 0;
   if nsep > 2
      last3 =  pp(filind(nsep-2)+1:filind(nsep)-1);
      if sys == 'v'
         ml = strcmp(lower(last3),['toolbox:[matlab']);
      else
         ml = strcmp(lower(last3),['toolbox' filesep 'matlab']);
      end
   end
   mlorloc = ml | loc;
   if sys == 'v'
% I don't know if this should have a '.' before general or not - MM
      if strcmp(last1,'general]');
         mlorloc = 0;
      end
   else
      if strcmp(last1,'general');
         mlorloc = 0;
      end
   end
% find file separators
   if ~mlorloc  % not toolbox/matlab/ or local
      if sys == 'v'
         file = [pp 'Contents.m'];
      else
         file = [pp filesep 'Contents.m'];
      end
      if exist(file) == 2
         c = computer;
         if c(1:2) == 'PC'
            fp = fopen(file,'rb');
         else
            fp = fopen(file,'r');
         end
         s = [fgetl(fp) '  '];
         s1 = [fgetl(fp) '  '];
         s(1:2) = [];
         s1(1:2) = [];
         if sys == 'v'
% I don't know if this should have a '.' before general or not - MM
            gl = strcmp(last1,'general]');
         else
            gl = strcmp(last1,'general');
         end
         if gl
            disp(s1)
         else
            disp([s '  ' s1])
         end
         fclose(fp);
      else
         disp(['No Contents.m file for ' pp])
      end
   end
end
