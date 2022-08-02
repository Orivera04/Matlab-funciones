% INSTADDFIELD   商品集合変数に新しい商品を追加
%
% ユーザが自分で作成したタイプの商品を生成したい場合、または、既存の集合
% に新しい商品を追加したい場合、関数 INSTADDFIELD を実行してください。
%
%   商品変数を1つ作成するには、つぎのように設定します。
%   InstSet = instaddfield('FieldName', FieldList, ... 
%                       'Data' , DataList, ...      
%                       'Type', TypeString)
%
%   InstSet = instaddfield('FieldName', FieldList, ... 
%                       'FieldClass', ClassList, ...
%                       'Data' , DataList, ...      
%                       'Type', TypeString)
%
%   商品を追加するには、つぎのように設定します。
%   InstSet = instaddfield(InstSetOld, 'FieldName', FieldList, ... 
%                             'Data' , DataList, ...      
%                             'Type', TypeString)
%
% 入力: 
% 複数のパラメータ値の組を任意の順序で入力することができます。ただし、
% 一番目の引数には、既存の InstSet 変数を入力してください。
%
%   InstSetOld - 商品の集合からなる変数です。商品は、タイプ毎に分類され
%                ており、それぞれのタイプについて異なるデータフィールド
%                を設定できます。記憶されたデータフィールドは、商品のそ
%                れぞれに対応する行ベクトル、または、文字列となっていま
%                す。
%
%   FieldList  - 各データフィールドの名称を記載した文字列、または、文字
%                列の NFIELDS 行1列のセル配列。FieldList には、 'Type'、
%                または、'Index' という名称を記載することはできません。
%                これらのフィールド名は登録されています。
% 
%   DataList   - 各データフィールドの中身を構成するデータからなる NINST 
%                行 M 列の配列、または、NFIELDS 行1列のセル配列。データ
%                配列の各行は、個々の商品に対応しています。単一の行の場
%                合、複写され、対象となる全ての商品に適用されます。列の
%                数は、任意で、データは列を基準にしてパディングされます。
% 
%   ClassList  - 各データフィールドのデータクラスを記載する文字列、また
%                は、文字列の NFIELDS 行1列のセル配列。DataList の解析法
%                は、ここで指定されたデータクラスによって決定されます。
%                入力可能な文字列は、'dble', 'date', 'char' です。
%                'FieldClass' と ClassList のペアは、常にオプションとなり
%                ます。ClassList は、既存のフィールド名、または、既存の
%                フィールド名が入力されていない場合、データから推定される
%                ことになります。
%   TypeString - 追加される商品のタイプを指定する文字列。異なるタイプの
%                商品は、異なるフィールド名集合をもつことができます。
%
% 出力:   
%   InstSet    - 新しい入力データを含む商品集合変数です。
%
% 例題:7月オプションを基準にポートフォリオを構築します。
%   % Strike Call  Put
%   %  95    12.2  2.9
%   % 100     9.2  4.9
%   % 105     6.8  7.4
%   Strike = (95:5:105)'
%   CallP = [12.2; 9.2; 6.8]
%   
%   %  データフィールド 'Strike', 'Price', 'Opt' を有する3コールオプ
%      ションを入力します。
%   ISet = instaddfield('Type','Option', ...
%                       'FieldName',{'Strike','Price','Opt'}, ...
%                       'Data',{ Strike,  CallP, 'Call'});
%   instdisp(ISet)
%   
%   % 先物契約を入力し、入力解釈クラスを設定します。
%   ISet = instaddfield(ISet,'Type','Futures', ...
%                       'FieldName',{'Delivery','F'}, ...
%                       'FieldClass',{  'date'  , 'dble'}, ...
%                       'Data' ,{'01-Jul-99' , 104.4  });
%   instdisp(ISet)
%   
%   % プットオプションを入力します。
%   FN = instfields(ISet,'Type','Option')
%   ISet = instaddfield(ISet,'Type','Option','FieldName',FN,...
%                       'Data',{105, 7.4, 'Put'});
%   instdisp(ISet)
%   
%   % もう一方のプットについてプレースホルダを作成します。
%   ISet = instaddfield(ISet,'Type','Option','FieldName','Opt',....
%          'Data','Put')
%   instdisp(ISet)
%   
%   % 現金商品を追加します。
%   ISet = instaddfield(ISet, 'Type', 'TBill', 'FieldName',....
%          'Price','Data',99)
%   instdisp(ISet)
%   
%
% 参考 : INSTSETFIELD, INSTGETCELL, INSTGET, FINARGPARSE, INSTDISP.


%   Copyright 1995-2002 The MathWorks, Inc. 
