% INSTPVP   パラメータ/値の組み合わせを解析
%
%   [ValueList, FoundFlags] = instpvp('None',ParamList,...
%        'PARAM1', VALUE1, 'PARAM2', VALUE2, ...)
%   
%   [ValueList, FoundFlags, TagList] = instpvp('Single',ParamList,...
%        'PARAM1', VALUE1, 'PARAM2', VALUE2, ...
%        'TAG1', 'TAG2', 'TAGNTAGS', ... )
%
%   [ValueList, FoundFlags, TagList, DataList] = instpvp('Pair',...
%       ParamList,'PARAM1', VALUE1, 'PARAM2', VALUE2, ...
%        'TAG1', DATA1, 'TAG2', DATA2, 'TAG3', DATA3, ... )
%
%   [...] = instpvp(TagStyle, ParamList, ArgList{:})
%
%
% 入力:
%   TagStyle   : 'None', 'Single', 'Pair' のいずれかの文字列を入力します。
%                TagStyle は、ParamList に含まれるパラメータについて、
%                パラメータと値の組が適合していない引数をどう処理するかを
%                決定します。
%     1)'None'   - 不適合の引数が存在した場合に、エラーを生成します。
%     2)'Single' - 不適合の引数をTagListに出力します。
%     3)'Pair'   - 不適合の引数をタグとデータの組み合わせとして処理しま
%                  す。この場合、パラメータのタグを TagList に出力、値の
%                  データを DataList に出力します。
%   ParamList  : パラメータ名の文字列からなる NUMPARAM 行1列のセル配列
%   ArgList    : コンマ区切りのリストに対応する引数のセル配列
%
% 出力：
%   ValueList  : ParamList に記載されている各パラメータについて、解析に
%               より抽出された値を示す NUMPARAM 行1列のセル配列です。
%               対応するパラメータが引数リストになかった場合には、当該
%               セルは空となります。
% 
%   FoundFlags : ParamList に記載されているパラメータの中のいずれのパラ
%                メータが引数リストから発見できたのかを示す NUMPARAM 行
%                1列の論理フラグです。
% 
%   TagList    : 不適合の引数を示す NTAGS 行1列のセル配列です。TagStyle 
%                が、'None' に設定されていた場合、不適合のパラメータは
%                エラーとなります。
% 
%   DataList   : 引数内の不適合のタグ/データの組に対応するデータ値からな
%                る NTAGS 行1列のセル配列です。TagStyle が、'Single' の
%                場合、不適合の引数は、全て TagList に記載され、DataList
%                は空となります。
%
% 注意：
% パラメータ/値、または、タグ/データの組を構成するパラメータとタグは、
% 共に文字列でなければなりません。


%   Author(s): J. Akao 21-Apr-1999
%   Copyright 1995-2002 The MathWorks, Inc. 
