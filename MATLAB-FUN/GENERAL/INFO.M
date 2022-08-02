function info(arg)
%INFO	Information about MATLAB and The MathWorks.
%	INFO <toolboxpath> displays the Readme files for the toolbox
%	with the specified toolbox path.
%
%	See also WHATSNEW.

%	Copyright (c) 1984-94 by The MathWorks, Inc.

if nargin == 0
clc
disp(' ')
disp('MATLAB is available for PC, Macintosh, Sun, VAX, Apollo, HP, ')
disp('DECstation, SGI, RS/6000, Convex, and Cray computers. ')
disp(' ')
disp('Optional toolboxes include:')
disp(' ')
disp('    Signal Processing Toolbox')
disp('    System Identification (Parametric Modelling) Toolbox')
disp('    Optimization Toolbox')
disp('    Neural Network Toolbox')
disp('    Control System Toolbox')
disp('    Robust-Control Toolbox')
disp('    Mu-analysis and Synthesis Toolbox')
disp('    Spline Toolbox')
disp('    Chemometrics Toolbox')
disp('    MMLE3 Identification Toolbox')
disp('    SIMULINK (Dynamic System Simulation Software)')
disp(' ')
disp('Press any key for more. . .')
pause,clc
disp(' ')
disp('For MATLAB assistance or information, contact:')
disp(' ')
disp('   The MathWorks, Inc.')
disp('   24 Prime Park Way')
disp('   Natick, MA 01760')
disp(' ')
disp('   Ph:  508-653-1415')
disp('   FAX: 508-653-2997')
disp(' ')
disp('   Email:  ')
disp('       tech@mathworks.com - Technical support')
disp('       bugs@mathworks.com - Bug reports')
disp('        doc@mathworks.com - Documentation error reports')
disp('    suggest@mathworks.com - Product enhancement suggestions')
disp('    service@mathworks.com - Order status, license renewals, passcodes')
disp('  subscribe@mathworks.com - Subscribing User registration')
disp('       info@mathworks.com - Sales, pricing, and general information')
disp(' ')
disp('Press any key for more. . .')
pause,clc

disp(' ')
disp('If you would like to become a Subscribing User, which subscribes')
disp('you to our newsletter, send us your name and postal address.  Be')
disp('sure to indicate the type of computer you are using and the license')
disp('number or serial number displayed by executing the VER command.')
disp('Send it by regular mail, FAX, or email to:')
disp(' ')
disp('   The MathWorks, Inc.')
disp('   24 Prime Park Way')
disp('   Natick, MA 01760')
disp('   FAX: 508-653-2997')
disp('   email: subscribe@mathworks.com')
disp(' ')
disp('Anybody can become a Subscribing User -- you don''t have to be the')
disp('"officially licensed" user.')

disp(' ')
disp('If you would like to join the MATLAB Users Group and receive')
disp('the email MATLAB News digest, send your email')
disp('address to: matlab-users-request@mcs.anl.gov')
disp('Submissions to: matlab-users@mcs.anl.gov')
disp('Library contributions to: matlab-library@mcs.anl.gov')

disp(' ')
disp('Press any key for more. . .')
pause, clc
disp(' ')
disp('Notice to U.S. GOVERNMENT users: If Licensee is acquiring the software')
disp('on behalf of any unit or agency of the U.S. Government, the following')
disp('shall apply:')
disp('(a) For units of the Department of Defense:')
disp('    RESTRICTED RIGHTS LEGEND: Use, duplication, or disclosure by the')
disp('    Government is subject to restrictions as set forth in subparagraph')
disp('    (c)(1)(ii) of the Rights in Technical Data Clause at DFARS 252.227-7013.')
disp('(b) For any other unit or agency:')
disp('    NOTICE - Notwithstanding any other lease or license agreement that')
disp('    may pertain to, or accompany the delivery of, the computer software and')
disp('    accompanying documentation, the rights of the Government regarding its')
disp('    use, reproduction and disclosure are as set forth in Clause')
disp('    52.227-19(c)(2) of the FAR.')
disp('Manufacturer is The MathWorks, Inc., 24 Prime Park Way, Natick, MA 01760.')
disp(' ')
return
end   % end nargin == 0
% nargin == 1 - want info for a particular item
p = path;
pathsep = ':';
filesep = '/';
c = computer;
if strcmp(c(1:2),'PC')
    pathsep = ';';
    filesep = '\';
elseif strcmp(c(1:2),'MA')
    pathsep = ';';
    filesep = ':';
elseif isvms
    pathsep = ',';
    filesep = ']';
end
if strcmp(arg,'matlab')
   arg = 'general';
end
seps = find(p == pathsep);
first = [1 seps+1];
last = [seps-1 length(p)];
larg = length(arg);
wd = cd;
for i = 1:length(first)
   pp = p(first(i):last(i));
   lp = length(pp);
   if lp >= larg
      if strcmp(arg,pp(lp-larg+1:lp))
         cd(pp);
         if exist([pp filesep 'Readme.m'])==2
            help Readme
         end
      end
   end
end
cd(wd);


