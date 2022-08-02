function  utype_register(tmwName, userName, primary, userTypeDepend, varargin)
%UTYPE_REGISTER registers a user type relative to a MathWorks and base type.
%
%   UTYPE_REGISTER(TMWNAME, USERNAME, PRIMARY, USERTYPEDEPEND)
%         registeres a user type (userName) with a MathWorks type name
%         (tmwName). The association can be identified as a primary one 
%         (primary) for a many (user names) to one (MathWorks name) 
%         relationship. Also, if the user data type requires a include 
%         file (.h) to define the type name, it can be registered 
%         (userTypeDepend).
%
%   INPUT:
%         tmwName:           Name of MathWorks datatype
%         userName:          User defined name
%         primary:           Primary association for Many to One ('Yes','No')
%         userTypeDepend:    Include file required for user type.
%         varargin:          'Both', 'Parameter','Signal', or nothing

%   Steve Toeppe
%   Linghui Zhang
%   Copyright 2001-2004 The MathWorks, Inc.
%   $Revision: 1.8.4.5 $
%   $Date: 2004/04/15 00:29:14 $

% Future Plans:
%       Support duplication detection.

% Insert data type association into user types db list.

userTypes = rtwprivate('rtwattic', 'AtticData', 'userTypes');
index = length(userTypes);
next=index+1;
userTypes{next}.tmwName = tmwName;
userTypes{next}.userName = userName;
userTypes{next}.primaryUserName = lower(primary);
userTypes{next}.userTypeDepend = userTypeDepend;
if isempty(varargin) == 1
    userTypes{next}.type = 'Both';
else
   if isempty(varargin{1}) == 1
       userTypes{next}.type = 'Both';
   elseif strcmp(lower(varargin{1}),'parameter') == 1
       userTypes{next}.type = 'Parameter';
   elseif strcmp(lower(varargin{1}),'signal') == 1
       userTypes{next}.type = 'Signal';
   else
       userTypes{next}.type = 'Both';
   end
end
rtwprivate('rtwattic', 'AtticData', 'userTypes',userTypes);
