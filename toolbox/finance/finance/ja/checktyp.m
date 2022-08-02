% CHECKTYP   入力引数が与えられたデータタイプ仕様と適合するか検証
%
% ECODE = CHECKTYP(ARG_NAMES,ACTUAL,DATA_TYPE,FUN)は、与えられた引数が
% 指定されたデータタイプと適合しているかどうかを検証します。
% ARG_NAMES は、関数の入力引数の名称を示す文字列行列、ACTUAL は与えられ
% た入力引数の実際の値、DATA_TYPE は、データタイプの指定を示す文字列行列
% FUN は CHECKTYP を呼び出す関数の名称です。
%
%       DATA_TYPE 引数        データタイプ
%             int                  整数
%             str                  文字列
%             rea                  実数
%             cpx                  複素数
%
% 例題：
% ecode = checktyp('nper',12,'int',mfilename)は、入力引数 nper が整数値
% で入力されているか否かをチェックします。


%       Author(s): C.F. Garvin, 7-18-95
%       Copyright 1995-2002 The MathWorks, Inc. 
