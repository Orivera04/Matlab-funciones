function set_function_resolution_db(element)
%SET_FUNCTION_RESOLUTION_DB Loads a new function into the function db. 
%
%  SET_FUNCTION_RESOLUTION_DB(ELEMENT)
%        It will load a new user function into the function database with 
%        registration and translation
%
%  INPUT:  
%        element:  new element for registration 
%
%  OUTPUT:
%        none 

%  Steve Toeppe
%  Copyright 2000-2002 The MathWorks, Inc.
%  $Revision: 1.7 $  
%  $Date: 2002/04/14 17:32:03 $

global ac_fdb;
ac_fdb{end+1}=element;