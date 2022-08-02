function objectList = get_mpt_data_object_registry()
%GET_MPT_DATA_OBJECT_REGISTRY returns the mpt data object registry
%
%   [OBJECTLIST]=GET_MPT_DATA_OBJECT_REGISTRY()
%   This function returns the registered data objects for use with the data
%   object wizard for Module Packaging Tool.  
%
%   INPUTS:
%          NONE
%
%   OUTPUTS:
%         objectList : structure of data objects to be registerd for use
%                      with the data object wizard.
%     dataObject(1).class = {'Simulink'};
%     dataObject(1).type{1} ={'Signal'};
%     dataObject(1).type{2} ={'Parameter'};
%     dataObject(1).derivedbyMPT = 'No';
%     dataObject(2).class = {'mpt'};
%     dataObject(2).type{1} ={'Signal'};
%     dataObject(2).type{2} ={'Parameter'};
%     dataObject(2).derivedbyMPT = 'Yes';
%     dataObject(3).class = {'ASAP2'};
%     dataObject(3).type{1} ={'Signal'};
%     dataObject(3).type{2} ={'Parameter'};
%     dataObject(3).derivedbyMPT = 'No';
%
%     Each object has a class and at least one type that it supports 
%     class ='Simulink'
%     type = 'Signal' or 'Parameter'

%   Patrick W. Menter, Linghui Zhang
%   Copyright 2002-2003 The MathWorks, Inc.
%   $Revision: 1.3.4.3 $  $Date: 2004/04/15 00:29:26 $

objectList(1).class={'mpt'};
objectList(1).type{1}={'Signal'};
objectList(1).type{2}={'Parameter'};
objectList(1).derivedbyMPT = 'Yes';

objectList(2).class={'Simulink'};
objectList(2).type{1}={'Signal'};
objectList(2).type{2}={'Parameter'};
objectList(2).derivedbyMPT = 'No';

