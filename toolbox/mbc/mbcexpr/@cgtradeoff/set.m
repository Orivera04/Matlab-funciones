function varargout = set(in , varargin)
%SET

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:16:12 $

if nargin == 1
   varargout{1} = i_ShowFields;   
else
   mod_object = varargin{1};
   if nargin < 3
      error('cgtradeoff::set: Insufficient arguments.');
   end
   
   for i = 1:2:length(varargin)
      
      prop = varargin{i};
      val = varargin{i+1};
      
      switch lower(prop)
      case 'sameylimits'
         in.sameYlimits = val;
      case 'errordisp'
         in.showError = val;
      case 'currentrow'
         in.currentRow = val;
      case 'currentcol'
         in.currentCol = val;
      case 'currentrows'
        in.currentRows = val;
      case 'currentcols'
        in.currentCols = val;
      case 'viewstore'
         %We'll trust that the viewstore is ok.
         in.viewStore = val;
      case 'oppoint'
         %We'll trust that the operating point is of the correct form.
         in.opPoint.info = val;
         in = applyoppoint(in);
      case 'hiddenfactors'
         in.hiddenFactors = val;
      case 'hiddenmodels'
         in.hiddenModels = val;
      case 'fillmask'
         
         %If the val isn't a cell array, then the mask is to be applied to all tables.
         if ~iscell(val)
            %Check that the mask is big enough.
            r = []; c = [];
            for i = 1:length(in.tablePtrs)
               dat = in.tablePtrs(i).get('values');
               r = [r size(dat(1))];
               c = [c size(dat(2))];
            end
            
            if ~all(diff(r)==0) | ~all(diff(c)==0)
               error('Not all of the tables in this object are of the same size, so this one mask can''t be applied everywhere.');
            else
               %Make sure that the mask is of the correct size, but only if it's a cell array.
               
               if iscell(val)
                  [r1,c1] = size(val);
                  
                  if r1 ~= r(1) | c1 ~= c(1)
                     error('Mask of incorrect size.');
                  end
               end
            end
            
            in.fillMask = val;
            
         else
            
            %Work out which element is the pointer to the table.
            el1 = val{1};
            el2 = val{2};
            
            if isa(el1 , 'xregpointer')
               ptr = el1;
               mask = el2;
            else
               ptr = el2;
               mask = el1;
            end
            
            indx = find(in.tableList == ptr);
            %First of all, make sure that this table is actually in the object.
            if isempty(indx)
               error('Table referenced by xregpointer isn''t in this object.');
            end
            
            %Then, make sure that the mask is of the correct size, but only if it's a cell.
            if iscell(mask)
               dat = ptr.get('values');
               [r,c] = size(dat);
               [r1,c1] = size(mask);
               
               if r~=r1 | c~=c1
                  error('Mask of incorrect size.');
               end
               
            end
            
            if ~iscell(in.fillMask)
               tempMask = in.fillMask;
               %Replicate the current mask over all of them before replacing the indx-th.
               for i = 1:length(in.tablePtrs)
                  in.fillMask(i) = tempMask;
               end
            end
            
            %ok = CheckFillingMask(mask);
            in.fillMask{indx} = mask;
            
         end
         
      case 'fillreg'
         
         %If the val isn't a cell array, then the reg is to be applied to all tables.
         if ~iscell(val)
            %Check that the region is big enough.
            r = []; c = [];
            for i = 1:length(in.tablePtrs)
               dat = in.tablePtrs(i).get('values');
               r = [r size(dat(1))];
               c = [c size(dat(2))];
            end
            
            if ~all(diff(r)==0) | ~all(diff(c)==0)
               error('Not all of the tables in this object are of the same size, so this one region can''t be applied everywhere.');
            else
               %Make sure that the region is of the correct size, but only if it's a cell array.
               
               if iscell(val)
                  [r1,c1] = size(val);
                  
                  if r1 ~= r(1) | c1 ~= c(1)
                     error('Region of incorrect size.');
                  end
               end
            end

            in.fillReg = val;
            
         else
            
            %Work out which element is the pointer to the table.
            el1 = val{1};
            el2 = val{2};
            
            if isa(el1 , 'xregpointer')
               ptr = el1;
               reg = el2;
            else
               ptr = el2;
               reg = el1;
            end
            
            indx = find(in.tableList == ptr);
            %First of all, make sure that this table is actually in the object.
            if isempty(indx)
               error('Table referenced by xregpointer isn''t in this object.');
            end
            
            %Then, make sure that the region is of the correct size, but only if it's a cell.
            if iscell(reg)
               dat = ptr.get('values');
               [r,c] = size(dat);
               [r1,c1] = size(mask);
               
               if r~=r1 | c~=c1
                  error('Region of incorrect size.');
               end
               
            end
            
            if ~iscell(in.fillReg)
               tempReg = in.fillReg;
               %Replicate the current region over all of them before replacing the indx-th.
               for i = 1:length(in.tablePtrs)
                  in.fillReg(i) = tempReg;
               end
            end
            
            %ok = CheckFillingMask(mask);
            in.fillReg{indx} = reg;
            
         end
         
      case 'fillptrs'

         % regions aren't altered
         
         %Work out which element is the pointer to the table.
         el1 = val{1};
         el2 = val{2};
         
         if isa(el1 , 'xregpointer') & el1.isa('cglookuptwo')
            ptr = el1;
            mask = el2;
         else
            ptr = el2;
            mask = el1;
         end
         
         indx = find(in.tablePtrs == ptr);
         %First of all, make sure that this table is actually in the object.
         if isempty(indx)
            error('Table referenced by xregpointer isn''t in this object.');
         end
         
         %Then, make sure that the mask is of the correct size, but only if it's a cell.
         if iscell(mask)
            dat = ptr.get('values');
            [r,c] = size(dat);
            [r1,c1] = size(mask);
            
            if r~=r1 | c~=c1
               error('Mask of incorrect size.');
            end
            
         end
           
         in.fillPtrs{indx} = mask;
         in = RectifyFactors(in,mask);
         
         
      otherwise 
         error(['cgtradeoff: Unknown property: ' prop '.']);
      end
      
   end
   
   %If we are out here, then we should be able to set the property of the object.
   if nargout > 0
      varargout{1} = in;
   elseif ~isempty(inputname(1))
      assignin('caller' , inputname(1) , in);
   end
   
end

%--------------------------------------------------------------------------------------
function out = i_ShowFields
%--------------------------------------------------------------------------------------
%Simply returns a structure, the fieldnames of which are the set-able
%fields of the Value object, and the fields contain more details.
out.name = 'Char';
out.fillmask = 'Mask for autofill routines.';
out.fillmask = 'xregpointer to a cgvalue, or a cell array mask of xregpointers to cgvalue';




