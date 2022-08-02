function setParam(s)

ObjRef=findobj(gcf,'Tag','Listbox1');
ObjRef2=findobj(gcf,'Tag','PopupMenu2');
ObjRef3=findobj(gcf,'Tag','PopupMenu1');
ObjRef4=findobj(gcf,'Tag','Symmflag');
switch s
	case 'symmetric',
      solvers={'CG';'SYMMLQ';'MINRES';'CR'};
      precond={'kein';'ICC';'ICC(THRESHOLD)';'Eigener'};
      matrix={'BCSSTK14';'BCSSTK16';'BCSSTK19';'BCSSTK21';'BCSSTK22';'BCSSTK23';'BCSSTK24';'BCSSTK26';'BCSSTK28';'BCSSTM20';'gr_30_30';'nos1';'nos5';'nos7';'s1rmq4m1';'s2rmq4m1';'Eigene'};
      set(ObjRef4,'Value',1);
   case 'unsymmetric'
      solvers={'GMRES';'BICG';'BICGSTAB';'QMR-2';'QMR-3';'TFQMR';'QMRBCGSTAB';'CGNR';'CGS'};
      precond={'kein';'ILU';'ILU(THRESHOLD)';'Eigener'};
      matrix={'west0067';'west0132';'west0497';'watt__1';'sherman2';'jpwh_991';'impcol_d';'gre__115';'fs_541_1';'bfw398a';'bfw782a';'cavity01';'cavity11';'ck400';'dw2048';'dwb512';'fs_680_1';'Eigene'};
      set(ObjRef4,'Value',0);
      selectmod('ron');
end
set(ObjRef3,'Value',1);
set(ObjRef,'Value',1);
set(ObjRef,'String',solvers);
set(ObjRef2,'String',precond);
set(ObjRef3,'String',matrix);
   