% INSTPVP   �p�����[�^/�l�̑g�ݍ��킹�����
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
% ����:
%   TagStyle   : 'None', 'Single', 'Pair' �̂����ꂩ�̕��������͂��܂��B
%                TagStyle �́AParamList �Ɋ܂܂��p�����[�^�ɂ��āA
%                �p�����[�^�ƒl�̑g���K�����Ă��Ȃ��������ǂ��������邩��
%                ���肵�܂��B
%     1)'None'   - �s�K���̈��������݂����ꍇ�ɁA�G���[�𐶐����܂��B
%     2)'Single' - �s�K���̈�����TagList�ɏo�͂��܂��B
%     3)'Pair'   - �s�K���̈������^�O�ƃf�[�^�̑g�ݍ��킹�Ƃ��ď�������
%                  ���B���̏ꍇ�A�p�����[�^�̃^�O�� TagList �ɏo�́A�l��
%                  �f�[�^�� DataList �ɏo�͂��܂��B
%   ParamList  : �p�����[�^���̕����񂩂�Ȃ� NUMPARAM �s1��̃Z���z��
%   ArgList    : �R���}��؂�̃��X�g�ɑΉ���������̃Z���z��
%
% �o�́F
%   ValueList  : ParamList �ɋL�ڂ���Ă���e�p�����[�^�ɂ��āA��͂�
%               ��蒊�o���ꂽ�l������ NUMPARAM �s1��̃Z���z��ł��B
%               �Ή�����p�����[�^���������X�g�ɂȂ������ꍇ�ɂ́A���Y
%               �Z���͋�ƂȂ�܂��B
% 
%   FoundFlags : ParamList �ɋL�ڂ���Ă���p�����[�^�̒��̂�����̃p��
%                ���[�^���������X�g���甭���ł����̂������� NUMPARAM �s
%                1��̘_���t���O�ł��B
% 
%   TagList    : �s�K���̈��������� NTAGS �s1��̃Z���z��ł��BTagStyle 
%                ���A'None' �ɐݒ肳��Ă����ꍇ�A�s�K���̃p�����[�^��
%                �G���[�ƂȂ�܂��B
% 
%   DataList   : �������̕s�K���̃^�O/�f�[�^�̑g�ɑΉ�����f�[�^�l�����
%                �� NTAGS �s1��̃Z���z��ł��BTagStyle ���A'Single' ��
%                �ꍇ�A�s�K���̈����́A�S�� TagList �ɋL�ڂ���ADataList
%                �͋�ƂȂ�܂��B
%
% ���ӁF
% �p�����[�^/�l�A�܂��́A�^�O/�f�[�^�̑g���\������p�����[�^�ƃ^�O�́A
% ���ɕ�����łȂ���΂Ȃ�܂���B


%   Author(s): J. Akao 21-Apr-1999
%   Copyright 1995-2002 The MathWorks, Inc. 
