% CLASSFIN   金融オブジェクトの生成、または、金融クラス名の出力
% 
% 使用法1: ClassNameクラスの金融構造体を出力します。
%    Obj = classfin(ClassName)
%    Obj = classfin(Struct, ClassName)
%
% 入力:
%    Struct    - 金融構造体に変換される構造体です。
%    ClassName - 金融構造体クラスの名前からなる文字列です。
%
% 出力:
%    Obj       - 金融構造体の例です。
%
%
% 使用法 2: 金融構造体のクラス名を出力します。
%    ClassName = classfin(Obj)
% 
% 入力:
%    Obj       : 金融構造の例です。
%
% 出力:
%    ClassName : 金融構造体のクラス名からなる文字列です。
%
% 例題:
%   1)  HJMTimeSpec金融構造体の具体例を生成し、生成した構造体のフィール
%       ドを完成させます(通常は、関数hjmtimespecが、HJMTimeSpec構造体の
%       生成には用いられます)。
%
%     TimeSpec = classfin('HJMTimeSpec');
%     TimeSpec.ValuationDate = datenum('Dec-10-1999');
%     TimeSpec.Maturity = datenum('Dec-10-2001');
%     TimeSpec.Compounding = 2;
%     TimeSpec.Basis = 0;
%     TimeSpec.EndMonthRule = 1;
%
%   2)既存の構造体から金融構造体を生成します。
%
%     TSpec.ValuationDate = datenum('Dec-10-1999');
%     TSpec.Maturity = datenum('Dec-10-2001');
%     TSpec.Compounding = 2;
%     TSpec.Basis = 0;
%     TSpec.EndMonthRule = 0;
%     TimeSpec = classfin(TSpec, 'HJMTimeSpec');
%
%   3)金融構造体のクラス名を取得します。
%     load HJMExamples
%     ClassName = classfin(ExHJMTree)
%
%
% 参考 : ISAFIN.


%   Author(s): J. Akao 12/17/98
%   Copyright 1995-2002 The MathWorks, Inc. 
