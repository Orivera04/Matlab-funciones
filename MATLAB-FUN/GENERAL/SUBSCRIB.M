function subscribe
%SUBSCRIBE Become a subscribing user of MATLAB.
%	Execute SUBSCRIBE to become a subscribing user of
%	MATLAB.  This command will prompt you for your name
%	and address.  If you are on a Unix system, it will
%	email your subscription to MathWorks.  If you are not,
%	it will create a log file that you can print out and
%	FAX or mail to MathWorks.

%	Copyright (c) 1984-94 by The MathWorks, Inc.

disp(' ')
disp('Join the MATLAB community by becoming a Subscribing User and keep')
disp('up-to-date on the latest MATLAB developments! Anybody who uses')
disp('MATLAB can become a Subscribing User at no cost -- you do NOT')
disp('have to be a registered user. Subscribing Users are entitled to:')
disp(' ')
disp('  - Receive a subscription to the MathWorks Newsletter by regular mail')
disp('  - Receive an email subscription to the MATLAB News Digest')
disp('  - Obtain technical support')
disp(' ')
com = computer;
if com(1:2) == 'PC' | com(1:2) == 'MA'
   yn = 'n';
else
   yn = input('Do you wish to subscribe via email (y/n) [y]? ','s');
end
if isempty(yn)
   yn = 'y';
end
ynf = 'y';
if lower(yn(1)) == 'n'
   ynf = input('Do you wish to subscribe by fax or regular mail (y/n) [y]? ','s');
   if isempty(ynf)
      ynf = 'y';
   end
end
if lower(yn(1)) == 'y' | lower(ynf(1)) == 'y'
   fid = fopen('subscribe.log','w');
   fprintf(fid,'%s\n','Please register me as a subscribing user!');
   s = input('Please enter your name:  ','s');
   fprintf(fid,'%s\n',s);
   s = input('Your Organization:  ','s');
   fprintf(fid,'%s\n',s);
   s = input('Street Address:  ','s');
   fprintf(fid,'%s\n',s);
   while ~isempty(s)
      if strcmp(deblank(fliplr(deblank(s))),'.')
         break
      end
      s = input('More address:  ','s');
      fprintf(fid,'%s\n',s);
   end
   s = input('E-mail address:  ','s');
   fprintf(fid,'%s\n',s);
   s = ['Computer:  ', com];
   fprintf(fid,'%s\n',s);
   if (strcmp(com(1:2),'PC') | strcmp(com(1:2),'MA'))
      s = ['MATLAB Serial Number:  ',siteid];
      fprintf(fid,'%s\n',s);
   else
      s = ['MATLAB Site ID:  ',siteid];
      fprintf(fid,'%s\n',s);
      s = ['MATLAB server hostid:  ',hostid];
      fprintf(fid,'%s\n',s);
   end
   fclose(fid);
   disp(' ')
   disp('Here''s the message you''ve created.')
   disp('--------------------------------------------')
   type subscribe.log
   disp('--------------------------------------------')
   disp(' ')
   if lower(yn(1)) == 'y'
      s = input('Is the message okay to send now (y/n) [y]? ','s');
   end
   if isempty(s)
      s = 'y';
   end
   if lower(s(1)) == 'y'
      if isunix
		if( strcmp(com,'HP700'))
         eval('!mailx -s Subscribe subscribe@mathworks.com < subscribe.log');
		else
         eval('!mail -s Subscribe subscribe@mathworks.com < subscribe.log');
		end
      elseif isvms
         disp('');
         disp('On VMS, if you have a way to send e-mail through Internet or Bitnet,');
         disp('you usually need to specify a transport.  This is done on the "SEND" line.');
         disp('For example, one networking package uses IN%"user@host.domain", another uses');
         disp('SMTP%"user@host.domain".');
         mailer=input('Please enter the prefix for your network e-mail package (e.g. IN%): ','s');
         eval(['!mail/subject="Subscribe" subscribe.log "' mailer '""subscribe@mathworks.com"""']);
      end
   else
      disp('Output saved in the file subscribe.log.  Please print and')
      disp('send to MathWorks at:')
      disp(' ')
      disp('  FAX:   508-653-2997')
      disp('  Mail:  The MathWorks, Inc., 24 Prime Park Way, Natick, MA 01760')
      disp('  Email: subscribe@mathworks.com')
      disp(' ')
   end
end
