% INSTENGINESET   instaddfield 及び instsetfield に対応するサブルーチン
%
% 新しい商品の追加及び既存商品にデータを付加、または、既存商品のデータの
% リセットを行います。
%
%   ISet = instengineset(NewFlag, ISet, 'FieldName', FieldList, ... 
%                                       'Data' , DataList, ...      
%                                       'FieldClass', ClassList, ...
%                                       'Index', IndexSet, ...
%                                       'Type', TypeList)
%
% 入力:
% 複数のパラメータ値の組を任意の順序で入力することができます。ただし、
% 1番目の引数には既存の ISet 変数を入力してください。
%
%    NewFlag - 新しい商品を追加する場合は1、既存の商品を修正する場合は
%              0に設定します。
%
%    ISet    - 商品集合からなる変数です。NewFlag = 1 の場合はオプション
%              となり、NewFlag = 0 のときは必須となります。
%
% 出力:   
%    ISet    - 入力されたデータを含む新しい商品変数
%
% 参考 : INSTADDFIELD, INSTSETFIELD.


%   Author(s): J. Akao 22-Mar-1999
%   Copyright 1995-2002 The MathWorks, Inc. 
