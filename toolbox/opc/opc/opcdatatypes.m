% OPC Toolbox Data Type Handling.
%
% OPC Servers require all values to be written to server items in COM
% Variant format. The server also provides the OPC Toolbox with COM
% Variants when an item’s Value property is read or returned by the server.
% The OPC Toolbox automatically converts between the COM Variant type and
% MATLAB data types according to the table shown below. Entries marked N/A
% indicate that the data type is not supported.
%
%   MATLAB Data Type    COM Variant Type
%   ----------------    ----------------
%   double              VT_R8	
%   single              VT_R4	
%   char                VT_BSTR	
%   logical             VT_BOOL	
%   uint8               VT_UI1	
%   uint16              VT_UI2	
%   uint32              VT_UI4	
%   uint64              VT_UI8	
%   int8                VT_I1	
%   int16               VT_I2	
%   int32               VT_I4	
%   int64               VT_I8	
%   double              VT_CY
%   double              VT_DATE     (MATLAB date number)
%   function_handle     N/A         
%   cell                N/A
%   struct              N/A
%   object              N/A
%   N/A                 VT_DISPATCH
%   N/A                 VT_BYREF	
%   []                  VT_EMPTY
% 
% For all of the data types listed above that can be converted between
% MATLAB and a COM Variant, scalar and array data is permitted by the OPC
% Toolbox. However, the OPC Specification supports only one-dimensional
% arrays of data. Higher dimension MATLAB arrays are flattened into a
% 1-dimensional vector when writing data to the OPC Server.

% Copyright 2003-2004 OPTI-NUM solutions (Pty) Ltd.
% $Revision: 1.1.6.1 $ $Date: 2004/03/24 20:43:34 $