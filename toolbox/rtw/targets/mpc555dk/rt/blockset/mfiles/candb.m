function varargout  = candb(action,varargin)
%CANDB
%
% Parameters
%
%   action - 'getdb' | 'getmessages' | 'getsignals'
%   varargin -
%       action   == 'getdb'
%       varargin == {dbaseSource tableName}
%
%       action   == 'getmessages'
%       varargin == {dbaseSource tableName MSGNAME_FILTER  }
%
%       action   == 'getsignals'
%       varargin == {dbaseSource tableName MSGNAME_FILTER }
%
%   Examples
%
%       Get a list of all messages in the database
%       candb('getmessages','%')
%
%       Get all the signals associated with WheelInfo
%       candb('getsignals','WheelInfo')
%
%       View the entire database
%       candb('getdb')
%

%   Copyright 2001-2002 The MathWorks, Inc.
%   $Revision: 1.8.4.2 $
%   $Date: 2004/04/29 03:40:19 $

import('java.sql.*');
import('java.util.*');
import('java.lang.*');
    

switch action
    
case 'getdb'
    %-----------------------------------------
    % Have a look at the entire database
    %-----------------------------------------
    
    source = varargin{1}
    tblName = varargin{2};

    con = openConnection(source);
    stmt = con.createStatement;
    qry = ['SELECT * FROM ' tblName ' WHERE (DLC NOT LIKE '''')' ];
    rs = stmt.executeQuery(qry);
    
    s={};
    
    fields = {  'MSGNAME'       'char' ;
        'MSGID'         'hex'  ;
        'DLC'           'int'  ;
        'SIGNAME'       'char' ;
        'STARTBIT'      'int'  ; 
        'SIZE'          'int'  ;
        'MIN'           'int'  ;
        'MAX'           'int'  ;
        'OFFSET'        'int'  ;
        'FACTOR'        'float';
    };
    
    s = buildCell(rs,fields);
    
    
    stmt.close;
    rs.close;
    con.close
    
    varargout{1} = s;
    
case 'getmessages'
    %------------------------------------------
    % Query the messages only
    %
    % varargin{1} is the message name
    %
    %------------------------------------------

    source = varargin{1}
    tblName = varargin{2};
    filter = varargin{3};

    con = openConnection(source);
    stmt = con.createStatement;
    
    qry = [ 'SELECT DISTINCT MSGNAME,MSGID,DLC '       ... 
            ' FROM ' tblName ...
            ' WHERE (DLC NOT LIKE '''') AND ' ...
            ' MSGNAME LIKE ''' filter ''' ' ...
            ' ORDER BY MSGNAME '];
            
    rs = stmt.executeQuery(qry);
    
    
    fields = {  
        'MSGNAME'       'char' ;
        'MSGID'         'hex'  ;
        'DLC'           'int'  ;
    };
    
    s = buildCell(rs,fields);
    
    
    stmt.close;
    rs.close;
    
    con.close;
    
    varargout{1} = s;
    
case 'getsignals'
    %-------------------------------------------------
    % Have a look at the information from individual
    % messages. All the signal information for
    % the specified message is returned.
    %
    % varargin{1} is the message name
    %-------------------------------------------------

    source = varargin{1}
    tblName = varargin{2};
    filter = varargin{3};

    con = openConnection(source);
    stmt = con.createStatement;
    
    qry = [ 'SELECT * '       ... 
            ' FROM ' tblName  ...
            ' WHERE (DLC NOT LIKE '''') AND ' ...
            ' MSGNAME LIKE ''' filter ''' ' ...
            ' ORDER BY MSGNAME '];
            
    rs = stmt.executeQuery(qry);
    
    fields = {  
      %  'MSGNAME'       'char' ;
      %  'MSGID'         'hex'  ;
      %  'DLC'           'int'  ;
        'SIGNAME'       'char' ;
        'STARTBIT'      'int'  ; 
        'SIZE'          'int'  ;
        'MIN'           'int'  ;
        'MAX'           'int'  ;
        'OFFSET'        'int' ;
        'FACTOR'        'float';
    };
   
    
    s = buildCell(rs,fields);
    
    
    stmt.close;
    rs.close;
    con.close;
    
    varargout{1} = s;
    
    
otherwise
    error([action ' is not a supported action ']);
end

%----------------------------------------------------
% Get a connection to the CanDB database
function con = openConnection(dbName)

import('java.sql.*');
import('java.util.*');
import('java.lang.*');
Class.forName('sun.jdbc.odbc.JdbcOdbcDriver');

url = ['jdbc:odbc:' dbName ];

con = DriverManager.getConnection(url);

%--------------------------------------------------------
% Build a cell array from the query
function s = buildCell(rs,fields)
s = {};
while(rs.next)
        
        row = {};
        
        for i=1:(size(fields,1))
            str = char(rs.getString(fields{i,1}));
            switch fields{i,2}
            case 'char'
                element = str ;    
            case 'int'
                element = eval(str);
            case 'float'
                element = eval(str);
            case 'hex'
                element = hex2dec(str);
            otherwise
                error([ fields{i,2} ' is not a valid data type ']);
            end  
            row = { row{:} element };
        end
        
        
        s = vertcat(s, row );
        
    end
    
   

