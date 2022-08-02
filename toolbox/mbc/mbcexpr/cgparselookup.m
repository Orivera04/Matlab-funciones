function ptr = cgparselookup(b,blockname,neweqn,type, PLIST)
%CGPARSELOOKUP - A CAGE Simulink parse function
%
%  PTR = CGPARSELOOKUP(blockHandle,blockName,neweqn,type, pPointerList)
%  Handles all types of lookup block

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%  Inc.

%  $Revision: 1.3.6.3 $    $Date: 2004/02/09 07:17:19 $

ud=get_param(b,'userdata');
switch type
    case 'L2'
        ptr = decodeLookupTwo(b,blockname,ud,neweqn, PLIST);
    case {'NF','L1'}
        ptr = decodeLookupOne(b,blockname,ud,neweqn, PLIST);
end


% ---------------------------------------------
function p = i_makeNormaliser(p,pL2,index, PLIST)
% ---------------------------------------------
if p.isa('cgnormaliser')
    % Nothing needs to be done
else
    if p.isa('cgnormfunction') && isempty(p.get('sflist'))
        % converts a newly created normfunction or lookupone to a normaliser
        in = p.get('x');
        name = p.getname;
        newnorm = cgnormaliser;
        try
            val = p.get('values');
            bp = p.get('breakpoints');
            newnorm = set(newnorm,'matrix',[bp val]);
            freedummynormptr(p.info);
        end
        % put the normaliser where the lookupone used to be
        p.info = newnorm;
        p.info = p.setname(name);
        p.info = p.setX(in);
    else
        % Input to the lookuptwo is not a table
        % so we need to create a normaliser and insert it
        name = [pL2.getname,'_norm',index];
        q = cgnormaliser(name);
        q.info = q.setX(p);
        PLIST.info=[PLIST.info;q];
        p=q;
    end
end


% ---------------------------------------------
function ptr = decodeLookupOne(b,blockname,ud,neweqn, PLIST)
% ---------------------------------------------

try
    ud.info = ud.setname(blockname);
    if neweqn(1).isa('cglookupone')
        i_makeNormaliser(neweqn(1));
    end
    if neweqn(1).isa('cgnormaliser')
        % ud is a normfunction
        ud.info = ud.setX(ud,neweqn(1));
    else
        % e.g. neweqn is a value and ud is a normaliser or a lookupone
        ud.info = ud.setX(neweqn(1));
    end
    ptr = ud;
catch
    ptr = cgsl2exprcheckname(blockname, PLIST);
    if neweqn.isa('cgnormaliser')
        if ~isvalid(ptr)
            ptr = cgnormfunction(blockname);
            PLIST.info=[PLIST.info;ptr];
        end
        ptr.info = ptr.setX(ptr,neweqn);
    elseif neweqn.isa('cglookupone')
        i_makeNormaliser(neweqn);
        if ~isvalid(ptr)
            ptr = cgnormfunction(blockname);
            PLIST.info=[PLIST.info;ptr];
        end
        ptr.info = ptr.setX(ptr,neweqn);
    else
        parent = cgsl2exprdestblock(b);

        if cgsl2expristabletype( parent(1) )
            if ~isvalid(ptr)
                ptr = cgnormaliser(blockname);
                PLIST.info=[PLIST.info;ptr];
            end
            ptr.info = ptr.setX(neweqn);
        else
            if ~isvalid(ptr)
                % make a new cglookupone
                ptr = cglookupone(blockname);
                PLIST.info=[PLIST.info;ptr];
            end
            ptr.info = ptr.setX(neweqn);
        end
    end
    ptr.info = ptr.set('precision',cgprecfloat);
end
% ---------------------------------------------
function ptr = decodeLookupTwo(b,blockname,ud,neweqn, PLIST)
% ---------------------------------------------

try
    ud.info = ud.setname(blockname);
    ud.info = ud.setX(ud,neweqn(1));
    ud.info = ud.setY(ud,neweqn(2));
    ptr = ud;
catch
    ptr = cgsl2exprcheckname(blockname, PLIST);
    if ~isvalid(ptr)
        ptr = cglookuptwo(blockname);
        PLIST.info=[PLIST.info;ptr];
    end
    neweqn(1) = i_makeNormaliser(neweqn(1),ptr,'1', PLIST);
    neweqn(2) = i_makeNormaliser(neweqn(2),ptr,'2', PLIST);
    ptr.info=ptr.setX(ptr,neweqn(1));
    ptr.info=ptr.setY(ptr,neweqn(2));
    ptr.info = ptr.set('precision',cgprecfloat);
end
