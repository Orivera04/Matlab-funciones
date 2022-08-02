function xpcgencom(xpcsys)
% XPCGENCOM - Builds the xPC Target COM Signals and Parameters Interfaces
%
%   XPCGENCOM(XPCSYS) genearates ATL Code and builds the component
%   server library dll <XPCSYSCOM>COMiface.dll into build directory. 
%   The generated Componenet server library contains the COM Interfaces
%   Signal objects(<XPCSYS>BIO) and Parameter objects(XPCSYSCOM>PT) 
%   with properties holding the signal and parameter identifiers of
%   xPC tagged signals and parameters objects.

%   Copyright 1996-2003 The MathWorks, Inc.
%   $Revision: 1.9.6.3 $  $Date: 2004/04/08 21:03:35 $

warnst=warning('backtrace');
warnst.st='off';
warning(warnst);
xpcenv=getxpcenv;

if ~strcmp(xpcenv.actpropval{3},'VisualC')
    disp(['Warning: Skipping the Build process of COM Objects.',sprintf('\n'),... 
          'The Watcom Compiler is not supported to generate the COM Objects']);
    return;
end

disp(['###Parsing ',xpcsys,' for xPC Tagged Signals and Parameters'])
try
    par=xpctagpt(xpcsys);
    curdir=pwd;
    isbuildDir=findstr(['\',xpcsys,'_xpc_rtw'],curdir);
    if ~isempty(isbuildDir)
        cd ..
    end
    bio=xpctagbio(xpcsys);
   if ~isempty(isbuildDir)
        cd(curdir)
   end
catch
    error(lasterr)
end
if (isempty(par) & isempty(bio))
    warning('Can''t generate xPC COM interface code. ',...
          'No tagged xPC signals or block parameters found.');
    return
end

disp(['###Generating xPC COM interface code in build directory: ',xpcsys,'_xpc_rtw'])


msvcrootpath=char(getxpcenv('CompilerPath'));
currentdir=pwd;
cd(msvcrootpath);
isver6=exist('Vc98','dir');
isver7=exist('Vc7','dir');
cd(currentdir);
if (isver6)
    VSVARSPATH=[msvcrootpath,'\VC98\Bin\vcvars32.bat'];
    MSVCTOOLDIR=['\Common\Tools'];
    cc='ver6';
end

if (isver7)
    VSVARSPATH=[msvcrootpath,'\Common7\Tools\vsvars32.bat'];
    MSVCTOOLDIR=['\Common7\Tools'];
    cc='ver7';
end

implemdllxpc(xpcsys);
impifacesigdec(xpcsys,bio);
impifacesigdef(xpcsys,bio);
impifacepardec(xpcsys,par);
impifacepardef(xpcsys,par);
%createidlandrgs(xpcsys,bio,par); 
createidlandrgs(xpcsys,bio,par,MSVCTOOLDIR);
createrc(xpcsys);
%genprehead  %
genprehead(MSVCTOOLDIR)
createmk(xpcsys);
createdef(xpcsys,cc);
cpystr=['copy ',xpcroot,'\api\xpcinitfree.c'];
cpystr1=['copy ',xpcroot,'\api\xpcapi.h'];
%createbatch(xpcsys);%
%createbatch(xpcsys,VSVARSPATH);
%vcroot=getxpcenv('CompilerPath');
createbatch(xpcsys,msvcrootpath)

[xdos,wdos]=dos(cpystr);
if (xdos)
    warning(wdos);
end    
[xdos,wdos]=dos(cpystr1);
if (xdos)
    warning(wdos);
end    
regval = isobjreg(xpcsys);
if  (regval==1)
     deregstr=['regsvr32 -s -u ',xpcsys,'COMiface.dll'];
     dos(deregstr);
end
fprintf(1,['###Buidling ',xpcsys,'COMiface.dll %s\n']);
[status, result]=dos([xpcsys,'COMiface.bat'],'-echo');
if ~(status)
    cpystr=['copy ',xpcsys,'COMiface.dll ..'];
    fprintf(1,['\n### Successful completion of ',xpcsys,...
              ' COM Signals and parameters build procedure: %s\n']);
    [status, result]=dos(cpystr); 
    if (status)
        error(result);
    end    
else
    error(['Build failed while creating',xpcsys,'COMiface.dll']);
end
warnst.st='on';
warning(warnst);

%-------------------------------------------------------------------------------------------------------------------------
function implemdllxpc(modelname)
% generate code for the <modelname>xpcCOMiface.cpp
nl=sprintf('\n');
tb=sprintf('\t');
%dll entry point
Objentry=['CComModule _Module;',nl,nl,'BEGIN_OBJECT_MAP(ObjectMap)',nl,...
          'OBJECT_ENTRY(CLSID_',modelname,'bio, C',modelname,'bio)',nl,...
          'OBJECT_ENTRY(CLSID_',modelname,'pt, C',modelname,'pt)',nl,...
          'END_OBJECT_MAP()',nl];
dllentstr=['extern "C"',nl,'BOOL WINAPI DllMain(HINSTANCE hInstance,',...
           ' DWORD dwReason, LPVOID /*lpReserved*/)',nl,'{',nl,tb,...
           'if (dwReason == DLL_PROCESS_ATTACH)',nl,tb,'{',nl,tb,tb,...
           '_Module.Init(ObjectMap, hInstance, &LIBID_',upper(modelname),...
           'COMIFACELib);',nl,tb,tb,'DisableThreadLibraryCalls(hInstance);',...
            nl,tb,'}',nl,tb,'else if (dwReason == DLL_PROCESS_DETACH)',...
            nl,tb,tb,'_Module.Term();',nl,tb,'return TRUE;',nl,'}'];

dllunload=['STDAPI DllCanUnloadNow(void)',nl,'{',nl,tb,...
           'return (_Module.GetLockCount()==0) ? S_OK : S_FALSE;',nl,'}'];
   
classobj=['STDAPI DllGetClassObject(REFCLSID rclsid, REFIID riid, LPVOID* ppv)',nl,'{',nl,tb,...
          'return _Module.GetClassObject(rclsid, riid, ppv);',nl,'}'];
dllreg=['STDAPI DllRegisterServer(void)',nl,'{',nl,tb,'return _Module.RegisterServer(TRUE);',nl,'}'];

dllunreg=['STDAPI DllUnregisterServer(void)',nl,'{',nl,tb,'return _Module.UnregisterServer(TRUE);',nl,'}'];

fid = fopen([modelname,'COMiface.cpp'],'w');

fprintf(fid,['#include "stdafx.h"',nl,'#include "resource.h"',nl,'#include <initguid.h>',nl,'#include "',modelname,'COMiface.h"',nl,nl]);

fprintf(fid,['#include "',modelname,'COMiface_i.c"',nl,'#include "',modelname,'bio.h"',nl,'#include "',modelname,'pt.h"',nl,nl]);

fprintf(fid,[Objentry,nl]);
%1) insert include for download interface signal interface and param interface.
fprintf(fid,'\n\n');
fprintf(fid,dllentstr);
fprintf(fid,'\n\n');
fprintf(fid,dllunload);
fprintf(fid,'\n\n');
fprintf(fid,classobj);
fprintf(fid,'\n\n');
fprintf(fid,dllreg);
fprintf(fid,'\n\n');
fprintf(fid,dllunreg);
fclose(fid);
%-------------------------------------------------------------------------------------------
function impifacesigdec(modelname,sigbio)
% generate ATL code for the <modelname>bio.h
fid = fopen([modelname,'bio.h'],'w');
fprintf(fid,'\n\n');
nl=sprintf('\n');
tb=sprintf('\t');
mdlstr=upper([modelname,'COMiface']);
incl=['#ifndef __',upper(modelname),'BIO_H_',nl,'#define __',upper(modelname),'BIO_H_',nl,nl,'#include "resource.h"'];
fprintf(fid,[incl,nl,nl]);
classdef=['class ATL_NO_VTABLE C',modelname,'bio :',nl,tb,'public CComObjectRootEx<CComSingleThreadModel>,',nl,tb,...
          'public CComCoClass<C',modelname,'bio, &CLSID_',modelname,'bio>,',nl,tb,...
          'public IDispatchImpl<I',modelname,'bio, &IID_I',modelname,'bio, &LIBID_',mdlstr,'Lib>',nl,'{',nl,...
          'public:',nl,tb,'C',modelname,'bio() : port(-1)',nl,tb,'{',nl,tb,'}',nl,nl,...
          'DECLARE_REGISTRY_RESOURCEID(IDR_',upper(modelname),'BIO)',nl,nl,'DECLARE_PROTECT_FINAL_CONSTRUCT()',nl,nl,...
          'BEGIN_COM_MAP(C',modelname,'bio)',nl,tb,'COM_INTERFACE_ENTRY(I',modelname,'bio)',nl,tb,'COM_INTERFACE_ENTRY(IDispatch)',nl,...
          'END_COM_MAP()',nl,nl,'public:',nl];
fprintf(fid, classdef);
 for i=1:length(sigbio)
     pubdefstr=[tb,'STDMETHOD(get_',char(sigbio(i).comsiglabel),')( /*[out, retval]*/ long *plResult);',nl];
     fprintf(fid, pubdefstr);
 end
fprintf(fid,[tb,'STDMETHOD(Init)(/*[in]*/long xPCProtocolRefProp,/*[out, retval]*/ long* plResut);',nl]);
fprintf(fid,['private:',nl,tb,'long port;',nl]);
fprintf(fid, ['};',nl,nl,'#endif']);
fclose(fid);

%-------------------------------------------------------------------------------------------
function impifacesigdef(modelname,sigbio)
% generate ATL code for the <modelname>bio.h
nl=sprintf('\n');
tb=sprintf('\t');
fid = fopen([modelname,'bio.cpp'],'w');
fprintf(fid,['#include "stdafx.h"',nl,'#include "',modelname,'COMiface.h"',nl,'#include "',modelname,'bio.h"',nl,...
             '#include "xpcapi.h"',nl,nl,nl]);
initmethod=['STDMETHODIMP C',modelname,'bio::Init(long xPCProtocolRefProp, long *plResult)',nl,'{',nl,tb,...
            'if (xPCInitAPI())',nl,tb,'{',nl,tb,tb,'*plResult=-1;',nl,tb,tb,'return S_OK;',nl,tb,'}',nl,tb,...
            'else {',nl,tb,tb,tb,'if(xPCProtocolRefProp >= 0){',nl,tb,tb,tb,tb,'port=xPCProtocolRefProp;',nl,tb,tb,tb,tb...
            '*plResult=port;',nl,tb,tb,tb,'}',nl,tb,tb,tb,'else',nl,tb,tb,tb,tb,'*plResult= -1;',nl,tb,'}',nl,tb,...
            'return S_OK;',nl,'}',nl,nl];
fprintf(fid, initmethod);            
for i=1:length(sigbio)
     getsigmethod=['STDMETHODIMP C',modelname,'bio::get_',char(sigbio(i).comsiglabel),'(long *plResult)',nl,'{',nl,tb,...
     '*plResult = xPCGetSignalIdx(port,','"',char(sigbio(i).blkpath),'");',nl,tb,'return S_OK;',nl,'}',nl,nl];
     fprintf(fid, getsigmethod);
 end
fclose(fid);
%-------------------------------------------------------------------------------------------
function impifacepardef(modelname,par)
% generate code for the <modelname>pt.cpp
nl=sprintf('\n');
tb=sprintf('\t');
fid = fopen([modelname,'pt.cpp'],'w');
fprintf(fid,['#include "stdafx.h"',nl,'#include "',modelname,'COMiface.h"',nl,'#include "',modelname,'pt.h"',nl,...
             '#include "xpcapi.h"',nl,nl,nl]);
initmethod=['STDMETHODIMP C',modelname,'pt::Init(long xPCProtocolRefProp, long *plResult)',nl,'{',nl,tb,...
            'if (xPCInitAPI())',nl,tb,'{',nl,tb,tb,'*plResult=-1;',nl,tb,tb,'return S_OK;',nl,tb,'}',nl,tb,...
            'else {',nl,tb,tb,tb,'if(xPCProtocolRefProp >= 0){',nl,tb,tb,tb,tb,'port=xPCProtocolRefProp;',nl,tb,tb,tb,tb...
            '*plResult=port;',nl,tb,tb,tb,'}',nl,tb,tb,tb,'else',nl,tb,tb,tb,tb,'*plResult= -1;',nl,tb,'}',nl,tb,...
            'return S_OK;',nl,'}',nl,nl];
fprintf(fid, initmethod);  
for i=1:length(par)
     getsigmethod=['STDMETHODIMP C',modelname,'pt::get_',char(par(i).comparname),'(long *plResult)',nl,'{',nl,tb,...
                   '*plResult = xPCGetParamIdx(port,','"',char(par(i).blkpath),'","',char(par(i).parname),'");',nl,tb,'return S_OK;',...
                   nl,'}',nl,nl];
     fprintf(fid, getsigmethod);
 end
fclose(fid);
%-------------------------------------------------------------------------------------------
function impifacepardec(modelname,par)
% generate code for the <modelname>pt.h
fid = fopen([modelname,'pt.h'],'w');
fprintf(fid,'\n\n');
nl=sprintf('\n');
tb=sprintf('\t');
mdlstr=upper([modelname,'COMiface']);
incl=['#ifndef __',upper(modelname),'PT_H_',nl,'#define __',upper(modelname),'PT_H_',nl,nl,'#include "resource.h"'];
fprintf(fid,[incl,nl,nl]);
classdef=['class ATL_NO_VTABLE C',modelname,'pt :',nl,tb,'public CComObjectRootEx<CComSingleThreadModel>,',nl,tb,...
          'public CComCoClass<C',modelname,'pt, &CLSID_',modelname,'pt>,',nl,tb,...
          'public IDispatchImpl<I',modelname,'pt, &IID_I',modelname,'pt, &LIBID_',mdlstr,'Lib>',nl,'{',nl,...
          'public:',nl,tb,'C',modelname,'pt() : port(-1)',nl,tb,'{',nl,tb,'}',nl,nl,...
          'DECLARE_REGISTRY_RESOURCEID(IDR_',upper(modelname),'PT)',nl,nl,'DECLARE_PROTECT_FINAL_CONSTRUCT()',nl,nl,...
          'BEGIN_COM_MAP(C',modelname,'pt)',nl,tb,'COM_INTERFACE_ENTRY(I',modelname,'pt)',nl,tb,'COM_INTERFACE_ENTRY(IDispatch)',nl,...
          'END_COM_MAP()',nl,nl,'public:',nl];
fprintf(fid, classdef);
for i=1:length(par)
    pubdefstr=[tb,'STDMETHOD(get_',char(par(i).comparname),')(/*[out, retval]*/ long *plResult);',nl];
    fprintf(fid, pubdefstr);
end
fprintf(fid,[tb,'STDMETHOD(Init)(/*[in]*/long xPCProtocolRefProp,/*[out, retval]*/ long* plResut);',nl]);
fprintf(fid,['private:',nl,tb,'long port;',nl]);
fprintf(fid, ['};',nl,nl,'#endif']);
fclose(fid);

%-------------------------------------------------------------------------------------------
function genprehead(MSVCTOOLDIR)
%function genprehead
nl=sprintf('\n');
defs=['#if _MSC_VER > 1000',nl,'#pragma once',nl,'#endif',nl,nl,'#define STRICT',nl,'#ifndef _WIN32_WINNT',nl,...
      '#define _WIN32_WINNT 0x0400',nl,'#endif','#define _ATL_APARTMENT_THREADED',nl,nl,'#include <atlbase.h>',...
       nl,'extern CComModule _Module;',nl,'#include <atlcom.h>',nl,'#endif'];

load(xpcenvdata)
msvcpath=actpropval{4};
%[w,uuid]=dos([msvcpath,'\Common\Tools\uuidgen']);%
[w,uuid]=dos([msvcpath,MSVCTOOLDIR,'\uuidgen']);
if (w)
    error(uuid);
    return;
end    
uuid=uuid(1:36);
uuid=strrep(uuid(1:end-1),'-','_');
strh=['#if !defined(AFX_STDAFX_H__',uuid,'__INCLUDED_)',nl,'#define AFX_STDAFX_H__',uuid,'__INCLUDED_',nl,nl];
inlcpp=['#include "stdafx.h"',nl,nl,'#ifdef _ATL_STATIC_REGISTRY',nl,'#include <statreg.h>',nl,'#include <statreg.cpp>',...
        nl,'#endif',nl,nl,'#include <atlimpl.cpp>'];
fid = fopen('StdAfx.h','w');
fid1 = fopen('StdAfx.cpp','w');
fprintf(fid,strh);
fprintf(fid,defs);
fprintf(fid1,inlcpp);
fclose(fid);
fclose(fid1);
%-------------------------------------------------------------------------------------------
function createidlandrgs(modelname,bio,par,MSVCTOOLDIR)
%function createidlandrgs(modelname,bio,par)
%modelname='xptank'
fid = fopen([modelname,'COMiface.idl'],'w');
nl=sprintf('\n');
tb=sprintf('\t');
imp=['import "oaidl.idl";',nl,'import "ocidl.idl";',nl];
fprintf(fid,imp);
load(xpcenvdata)
msvcpath=actpropval{4};
%[w,uuid]=dos([msvcpath,'\Common\Tools\uuidgen']);%
[w,uuid]=dos([msvcpath,MSVCTOOLDIR,'\uuidgen']);
if (w)
    error(uuid);
    return;
end    
uuidlib=upper(uuid(1:end-1));
uuidlib=uuidlib(1:36);
%[w,uuid]=dos([msvcpath,'\Common\Tools\uuidgen']);%
[w,uuid]=dos([msvcpath,MSVCTOOLDIR,'\uuidgen']);
uuid=upper(uuid(1:end-1));
uuid=uuid(1:36);
%modelbio Interrface......................constant
mdlbioiface=[tb,'[',nl,tb,tb,'object,',nl,tb,tb,'uuid(',uuid,'),',nl,tb,tb,'dual,',nl,tb,tb,...
             'helpstring("I',modelname,'bio Interface"),',nl,tb,tb,'pointer_default(unique)',nl,tb,']',nl,tb...
             'interface I',modelname,'bio : IDispatch',nl,tb,'{'];
fprintf(fid,mdlbioiface);
idlinitstr=[nl,tb,tb,'[id(1), helpstring("method Init")] HRESULT Init([in] long xPCProtocolRefProp, [out,retval] long* plResult);'];
fprintf(fid,idlinitstr);
ij=1;
for i=1:length(bio)
    ij=ij+1;
    idlmethstr=[nl,tb,tb,'[propget, id(',num2str(ij),'), helpstring("method ',char(bio(i).comsiglabel),'")] HRESULT ',...
                char(bio(i).comsiglabel),'([out,retval] long *plResult);'];
    fprintf(fid,idlmethstr);
end
fprintf(fid,[nl,tb,'};',nl]);
%modelpt Interrface......................
%[w,uuid]=dos([msvcpath,'\Common\Tools\uuidgen']);%
[w,uuid]=dos([msvcpath,MSVCTOOLDIR,'\uuidgen']);
uuid=upper(uuid(1:end-1));
uuid=uuid(1:36);
mdliface1str=[nl,tb,'[',nl,tb,tb,'object,',nl,tb,tb,'uuid(',uuid,'),',nl,tb,tb,'dual,',nl,tb,tb,...
             'helpstring("I',modelname,'pt Interface"),',nl,tb,tb,'pointer_default(unique)',nl,tb,']',nl,tb...
             'interface I',modelname,'pt : IDispatch',nl,tb,'{'];
fprintf(fid,mdliface1str);
idlinitstr=[nl,tb,tb,'[id(1), helpstring("method Init")] HRESULT Init([in] long xPCProtocolRefProp,[out,retval] long* plResult);'];
fprintf(fid,idlinitstr);
ji=1;
for i=1:length(par)
    ji=ji+1;
    idlmethstr=[nl,tb,tb,'[propget, id(',num2str(ji),'), helpstring("method ',char(par(i).comparname),'")] HRESULT ',...
                char(par(i).comparname),'([out,retval] long *plResult);'];
    fprintf(fid,idlmethstr);
end
fprintf(fid,[nl,tb,'};',nl]);
%------------------------------------
%[w,uuid]=dos([msvcpath,'\Common\Tools\uuidgen']);%
[w,uuid]=dos([msvcpath,MSVCTOOLDIR,'\uuidgen']);
uuid=upper(uuid(1:end-1));
uuid=uuid(1:36);
%model Interrface......................constant
mdliface1str=[nl,tb,'[',nl,tb,tb,'uuid(',uuidlib,'),',nl,tb,tb,'version(1.0),',nl,tb,tb,'helpstring("',modelname,...
             'COMiface 1.0 Type Library")',nl,tb,']',nl,'library ',upper(modelname),'COMIFACELib',nl,'{',nl,tb,...
             'importlib("stdole32.tlb");',nl,tb,'importlib("stdole2.tlb");',nl];
fprintf(fid,mdliface1str);
mdluid{1}=uuid;
mdluid{2}=uuidlib;

%------------------------------------
%[w,uuid]=dos([msvcpath,'\Common\Tools\uuidgen']);%
[w,uuid]=dos([msvcpath,MSVCTOOLDIR,'\uuidgen']);
uuid=upper(uuid(1:end-1));
uuid=uuid(1:36);
mdliface1str=[tb,'[',nl,tb,tb,'uuid(',uuid,'),',nl,tb,tb,'helpstring("',modelname,'bio Class")', nl,tb,']',...
              nl,tb,'coclass ',modelname,'bio',nl,tb,'{',nl,tb,tb,'[default] interface I',modelname,'bio;',nl,tb,'};',nl];
fprintf(fid,mdliface1str);
baruid{1}=uuid;
baruid{2}=uuidlib;
creatergs([modelname,'COMiface'],[modelname,'bio'],baruid);
%------------------------------------
%[w,uuid]=dos([msvcpath,'\Common\Tools\uuidgen']);%
[w,uuid]=dos([msvcpath,MSVCTOOLDIR,'\uuidgen']);
uuid=upper(uuid(1:end-1));
uuid=uuid(1:36);
mdliface1str=[tb,'[',nl,tb,tb,'uuid(',uuid,'),',nl,tb,tb,'helpstring("',modelname,'pt Class")', nl,tb,']',nl,tb,...
             'coclass ',modelname,'pt',nl,tb,'{',nl,tb,tb,'[default] interface I',modelname,'pt;',nl,tb,'};',nl];
fprintf(fid,mdliface1str);
fprintf(fid,'};');
fclose(fid);
paruid{1}=uuid;
paruid{2}=uuidlib;
creatergs([modelname,'COMiface'],[modelname,'pt'],paruid);
%------------------------------------
function createrc(modelname)
nl=sprintf('\n');
tb=sprintf('\t');
fid = fopen([modelname,'COMiface.rc'],'w');
fid1 = fopen('Resource.h','w');
res=['#include "resource.h"',nl,nl,'#define APSTUDIO_READONLY_SYMBOLS',nl,'#include "winres.h"',nl,nl,...
     '#undef APSTUDIO_READONLY_SYMBOLS',nl,nl,'#if !defined(AFX_RESOURCE_DLL) || defined(AFX_TARG_ENU)',nl,nl,...
     '#ifdef _WIN32',nl,'LANGUAGE LANG_ENGLISH, SUBLANG_ENGLISH_US',nl,'#pragma code_page(1252)',nl,'#endif',nl,nl,...
     '#ifdef APSTUDIO_INVOKED',nl,'1 TEXTINCLUDE DISCARDABLE ',nl,'BEGIN',nl,tb,'"resource.h\\0"',nl,'END',nl,nl,...
     '2 TEXTINCLUDE DISCARDABLE ',nl,'BEGIN',nl,tb,'"#include ""winres.h""\\r\\n"',nl,tb,'"\\0"',nl,'END',nl,nl,...
     '3 TEXTINCLUDE DISCARDABLE ',nl,'BEGIN',nl,tb,'"1 TYPELIB ""',modelname,'COMiface.tlb""\\r\\n"',nl,tb,'"\\0"',...
     nl,'END',nl,nl,'#endif ',nl,nl,nl,'#ifndef _MAC',nl,nl,'VS_VERSION_INFO VERSIONINFO',nl,' FILEVERSION 1,0,0,1',...
     nl,' PRODUCTVERSION 1,0,0,1',nl,' FILEFLAGSMASK 0x3fL',nl,'#ifdef _DEBUG',nl,' FILEFLAGS 0x1L',nl,'#else',nl,...
     ' FILEFLAGS 0x0L',nl,'#endif',nl,' FILEOS 0x4L',nl,' FILETYPE 0x2L',nl,' FILESUBTYPE 0x0L',nl,'BEGIN',nl,tb,...
     'BLOCK "StringFileInfo"',nl,tb,'BEGIN',nl,tb,tb,'BLOCK "040904B0"',nl,tb,tb,'BEGIN',nl,tb,tb,tb,...
     'VALUE "CompanyName", "The MathWorks Inc."',nl,tb,tb,tb,'VALUE "FileDescription", "',modelname,...
     'COMiface Module\\0"',nl,tb,tb,tb,'VALUE "FileVersion", "1, 0, 0, 1\\0"',nl,tb,tb,tb,'VALUE "InternalName", "',...
     modelname,'COMiface\\0"',nl,tb,tb,tb,'VALUE "LegalCopyright", "Copyright 2001\\0"',nl,tb,tb,tb,...
     'VALUE "OriginalFilename", "',modelname,'COMiface.DLL\\0"',nl,tb,tb,tb,'VALUE "ProductName", "xPC Target API\\0"',...
     nl,tb,tb,tb,'VALUE "ProductVersion", "1, 0, 0, 1\\0"',nl,tb,tb,tb,'VALUE "OLESelfRegister", "\\0"',nl,tb,tb,'END',...
     nl,tb,'END',nl,tb,'BLOCK "VarFileInfo"',nl,tb,'BEGIN',nl,tb,tb,'VALUE "Translation", 0x409, 1200',nl,tb,'END',nl,...
     'END',nl,nl,'#endif',nl,nl,nl,'IDR_',upper(modelname),'BIO          REGISTRY DISCARDABLE    "',modelname,'bio.rgs"',...
     nl,'IDR_',upper(modelname),'PT           REGISTRY DISCARDABLE    "',modelname,'pt.rgs"',nl,nl,'STRINGTABLE DISCARDABLE ',...
     nl,'BEGIN',nl,tb,'IDS_PROJNAME            "',modelname,'COMiface"',nl,'END',nl,'#endif   ',nl,nl,'#ifndef APSTUDIO_INVOKED',nl,nl,...
     '1 TYPELIB "',modelname,'COMiface.tlb"',nl,'#endif  ',nl];
resdef=['#define IDS_PROJNAME                    100',nl,'#define IDR_',upper(modelname),'BIO                   101',nl,'#define IDR_',upper(modelname),'PT                   102',...
        nl,nl,'#ifdef APSTUDIO_INVOKED',nl,'#ifndef APSTUDIO_READONLY_SYMBOLS',nl,'#define _APS_NEXT_RESOURCE_VALUE        201',...
        nl,'#define _APS_NEXT_COMMAND_VALUE         32768',nl,'#define _APS_NEXT_CONTROL_VALUE         201',nl,...
        '#define _APS_NEXT_SYMED_VALUE           104',nl,'#endif',nl,'#endif',nl];
fprintf(fid,res);
fprintf(fid1,resdef);
fclose(fid);
fclose(fid1);
%------------------------------------------------
function creatergs(projname,class,uuid)
nl=sprintf('\n');
tb=sprintf('\t');

fid = fopen([class,'.rgs'],'w');
mdlnamergs=['HKCR',nl,'{',nl,tb,projname,'.',class,'.1 = s ''',class,' Class''',nl,tb,'{',nl,tb,tb,...
            'CLSID = s ''{',uuid{1},'}''',nl,tb,'}',nl,tb,projname,'.',class,' = s ''',class,' Class''',nl,tb...
            '{',nl,tb,tb,'CLSID = s ''{',uuid{1},'}''',nl,tb,tb,'CurVer = s ''',projname,'.',class,'.1''',nl,tb,'',...
            '}',nl,tb,'NoRemove CLSID',nl,tb,'{',nl,tb,tb,'ForceRemove {',uuid{1},'} = s ''',class,' Class''',nl,tb,tb,...
            '{',nl,tb,tb,tb,'ProgID = s ''',projname,'.',class,'.1''',nl,tb,tb,tb,'VersionIndependentProgID = s ''',...
            projname,'.',class,'''',nl,tb,tb,tb,'ForceRemove ''Programmable''',nl,tb,tb,tb,'InprocServer32 = s ''%%MODULE%%''',...
            nl,tb,tb,tb,'{',nl,tb,tb,tb,tb,'val ThreadingModel = s ''Apartment''',nl,tb,tb,tb,'}',nl,tb,tb,tb,'''TypeLib'' = s ''{',...
            uuid{2},'}''',nl,tb,tb,'}',nl,tb,'}',nl,'}'];

fprintf(fid,mdlnamergs);
fclose(fid);
%------------------------------------------------
function createdef(modelname,cc)
nl=sprintf('\n');
tb=sprintf('\t');
fid = fopen([modelname,'COMiface.def'],'w');

if strcmp('ver6',cc)
    defstr=['; ',modelname,'COMiface.def : Declares the module parameters.',nl,nl,'LIBRARY      "',modelname,'COMiface.DLL"',nl,nl,...
            'EXPORTS',nl,tb,'DllCanUnloadNow     @1 PRIVATE',nl,tb,'DllGetClassObject   @2 PRIVATE',nl,tb,'DllRegisterServer   @3 PRIVATE',...
            nl,tb,'DllUnregisterServer',tb,'@4 PRIVATE'];
end
if strcmp('ver7',cc)
    defstr=['; ',modelname,'COMiface.def : Declares the module parameters.',nl,nl,'LIBRARY      "',modelname,'COMiface.DLL"',nl,nl,...
            'EXPORTS',nl,tb,'DllCanUnloadNow     PRIVATE',nl,tb,'DllGetClassObject   PRIVATE',nl,tb,'DllRegisterServer   PRIVATE',...
            nl,tb,'DllUnregisterServer',tb,'PRIVATE'];
end

fprintf(fid,defstr);
fclose(fid);

%------------------------------------------------
function createmk(modelname)
fid=fopen([xpcroot,'\api\private\mktemplate'],'r');
fid1 = fopen('Makefilecom','W');
nl=sprintf('\n');
fprintf(fid1,['modelname = ',modelname,nl]);
ct=1;
while 1
    ct=ct+1;
    tline = fgetl(fid);
    if ~ischar(tline), break, end    
    tline=strrep(tline,'\','\\');
%     if ct == 64
%         tline
%     end
    fprintf(fid1,tline);
    fprintf(fid1,'\n');
end
fclose(fid);
fclose(fid1);

%------------------------------------------------
function createdep(modelname)
fid=fopen([xpcroot,'\api\private\COMiface.dep'],'r');
fid1 = fopen([modelname,'COMiface.dep'],'W');
xpcenv=getxpcenv;
msvcrootpath=xpcenv.actpropval{4};
msvcrootpath=msvcrootpath(4:end);
msvcrootpath=strrep(msvcrootpath,'\','\\');
while 1
    tline = fgetl(fid);
    if ~ischar(tline), break, end
    tline=strrep(tline,'\','\\');
    tline=strrep(tline,'$(msvcroot)',msvcrootpath);
    tline=strrep(tline,'$(system)',modelname);
    fprintf(fid1,tline);
    fprintf(fid1,'\n');
end
fclose(fid);
fclose(fid1);
%------------------------------------------------
function boolval=isobjreg(xpcsys)
comname=[xpcsys,'COMiface.',xpcsys];
%perlcomstr=[matlabroot,'\sys\perl\win32\bin\perl -w ',xpcroot,'\xpc\reg.pl ',comname,'bio'];
perlcomstr=[matlabroot,'\sys\perl\win32\bin\perl -I',xpcroot,'\api\private -w ', ...
            xpcroot,'\api\private\reg.pl ',comname,'bio'];
[s, w] = dos(perlcomstr);
if ~strncmp(w,'Died',4)
    boolval=1;
else
    boolval=0;
end
%--------------------------------------------------
% function createbatch(xpcsys,vsvarspath)
% fid=fopen(vsvarspath,'r');
% fid1 = fopen([xpcsys,'COMiface.bat'],'wt');
% while 1
%     tline = fgetl(fid);
%     if ~ischar(tline), break, end
%         tline=strrep(tline,'%','%%');
%         tline=strrep(tline,'\','\\');
%         fprintf(fid1,tline);
%         fprintf(fid1,'\n');
% end
% ccRoot=getxpcenv('Compiler');
% mkCommand=['nmake DEVSTUDIO_LOC="',ccRoot,'"',' -f Makefilecom'];
% mkCommand=strrep(mkCommand,'\','\\');
% fclose(fid);
% %fprintf(fid1,'nmake -f Makefilecom');
% fprintf(fid1,mkCommand);
% fclose(fid1);
%--------------------------------------------------
function createbatch(xpcsys,vcrootpath)

ccVer=verscionccCompiler;
if (ccVer == 6)
    createVerSixBuildbat(xpcsys,vcrootpath)
elseif (ccVer == 7)
    createVerSevenBuildbat(xpcsys,vcrootpath)
end

%--------------------------------------------------
function ccVer=verscionccCompiler
ccCompiler=char(getxpcenv('CC'));
ccPath=char(getxpcenv('Compilerpath'));

currentdir=pwd;
cd(ccPath);

isver6=exist('Vc98','dir');
isver7=exist('Vc7','dir');
cd(currentdir);

if (isver6)
    ccVer=6;
end

if (isver7)
    ccVer=7;
end
%--------------------------------------------------
function createVerSixBuildbat(system,vcrootpath)
nl=sprintf('\n');
if exist([system,'COMiface.bat'],'file')
    delete([system,'COMiface.bat'])
end
    
fid = fopen([system,'COMiface.bat'],'w');
setML=strrep(['set MATLAB=',matlabroot],'\','\\');
fprintf(fid,[setML,nl]);
setMSVCDir=strrep(['set MSVCDir=',vcrootpath,'\vc98'],'\','\\');
fprintf(fid,[setMSVCDir,nl]);
setMSDevDir=strrep(['set MSDevDir=',vcrootpath,'\common\msdev98'],'\','\\');
fprintf(fid,[setMSDevDir,nl]);
envcheckInc=strrep([matlabroot,'\rtw\bin\win32\envcheck INCLUDE "',vcrootpath,'\vc98\include"'],'\','\\');
fprintf(fid,[envcheckInc,nl]);
fprintf(fid,['if errorlevel 1 goto vcvars32',nl]);
envcheckPath=strrep([matlabroot,'\rtw\bin\win32\envcheck PATH "',vcrootpath,'\vc98\bin"'],'\','\\');
fprintf(fid,[envcheckPath,nl]);
fprintf(fid,['if errorlevel 1 goto vcvars32',nl]);
fprintf(fid,['goto make',nl]);
fprintf(fid,[':vcvars32',nl]);
setVSCommonDir=strrep(['set VSCommonDir=','\common'],'\','\\');
fprintf(fid,[setVSCommonDir,nl]);
callvcvars=strrep(['call "',matlabroot,'\toolbox\rtw\rtw\private\vcvars32_600.bat"'],'\','\\');
fprintf(fid,[callvcvars,nl]);
fprintf(fid,[':make',nl]);
mkCommand=['nmake -f Makefilecom'];
fprintf(fid,[mkCommand,nl]);
fprintf(fid,['@if not errorlevel 0 echo The make command returned an error of %%errorlevel%%',nl]);
fclose(fid);

%------------------------------------------------
function createVerSevenBuildbat(system,vcrootpath)
nl=sprintf('\n');
fid = fopen([system,'COMiface.bat'],'w');
setMSVCDir=strrep(['set MSVCDir=',vcrootpath,'\vc7'],'\','\\');
fprintf(fid,[setMSVCDir,nl]);
envcheckInc=strrep([matlabroot,'\rtw\bin\win32\envcheck INCLUDE "',vcrootpath,'\vc7\include"'],'\','\\');
fprintf(fid,[envcheckInc,nl]);
fprintf(fid,['if errorlevel 1 goto vcvars32',nl]);
envcheckPath=strrep([matlabroot,'\rtw\bin\win32\envcheck PATH "',vcrootpath,'\vc7\bin"'],'\','\\');
fprintf(fid,[envcheckPath,nl]);
fprintf(fid,['if errorlevel 1 goto vcvars32',nl]);
fprintf(fid,['goto make',nl]);
fprintf(fid,[':vcvars32',nl]);
setVSINSTALLDIR=strrep(['set VSINSTALLDIR=',vcrootpath,'\common7\ide'],'\','\\');
fprintf(fid,[setVSINSTALLDIR,nl]);
setVCINSTALLDIR=strrep(['set VCINSTALLDIR=',vcrootpath],'\','\\');
fprintf(fid,[setVCINSTALLDIR,nl]);
setFrameworkSDKDir=strrep(['set FrameworkSDKDir=',vcrootpath,'\FrameworkSDK'],'\','\\');
fprintf(fid,[setFrameworkSDKDir,nl]);
setFrameworkDir=strrep(['set FrameworkDir=',vcrootpath,'\Framework'],'\','\\');
fprintf(fid,[setFrameworkDir,nl]);
callvcvars=strrep(['call "',matlabroot,'\toolbox\rtw\rtw\private\vcvars32_700.bat"'],'\','\\');
fprintf(fid,[callvcvars,nl]);
mkCommand=['nmake -f Makefilecom'];
fprintf(fid,[mkCommand,nl]);
fclose(fid);
%------------------------------------------------


function [VSVARSPATH,MSVCTOOLDIR] = getVisaulCCinfo

msvcrootpath=char(getxpcenv('CompilerPath'));
currentdir=pwd;
cd(msvcrootpath);
isver6=exist('Vc98','dir');
isver7=exist('Vc7','dir');
cd(currentdir);
if (isver6)
    VSVARSPATH=[msvcrootpath,'\VC98\Bin\vcvars32.bat'];
    MSVCTOOLDIR=['\Common\Tools'];
    cc='ver6';
end

if (isver7)
    VSVARSPATH=[msvcrootpath,'\Common7\Tools\vsvars32.bat'];
    MSVCTOOLDIR=['\Common7\Tools'];
    cc='ver7';
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
