function obj= mbcstore
%MBCSTORE Constructor for mbcstore object
%
%  OUT = MBCSTORE creates a new instance of an mbcstore object.  The
%  mbcstore object allows storage and retrieval of information based on an
%  associated key.
%
%  Keys can be any datatype that support the horzcat, eq and length
%  methods.
%  Data can be any datatype that supports horzcat and indexing.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 06:45:30 $ 


obj.KeyList = [];
obj.DataList = [];


obj = class(obj, 'mbcstore');