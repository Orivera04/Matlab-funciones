function modifier = get_storage_class_modifier(storageClassCat);
%GET_STORAGE_CLASS_MODIFIER  Returns the storage class modifier 
%
%   [MODIFIER]=GET_STORAGE_CLASS_MODIFIER(STORAGECLASS)
%   This function takes in teh storage class and returns the 
%   associated modifier.
%
%   Inputs: 
%           storageClass : Input storage class of data object item
%
%   Output:
%           modifier : Returned storage class modifier for the item.
%

%
%  Patrick W. Menter
%  Copyright 2002 The MathWorks, Inc.
%   $Revision: 1.1.4.1 $  $Date: 2004/04/15 00:29:28 $
%

if isempty(storageClassCat) == 0
    switch(storageClassCat)
        case 'RAM'
            modifier = '';
        case 'ROM'
            modifier = 'const';
        case 'KAM'
            modifier = '';
        case 'REG'
            modifier = '';
        case '#DEFINE'
            modifier = '#DEFINE';
        otherwise
            modifier = storageClassCat;
    end
else
    modifier = '';
end

return