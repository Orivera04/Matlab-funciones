% DATEDISP   �V���A���f�[�g���͂���t������ɕϊ������s��̕\��
% 
% ���l���͂ƃV���A�����t�ԍ����͂̑o���ɂ���č\������Ă���s��
% �^������ƁADATEDISP�̓V���A�����t����t������ɕϊ������s���\��
% ���܂��B�V���A�����t�̓��t������ւ̕ϊ��ɂ������Ă͓��t�ԍ�
% ('01-Jan-1900')������t�ԍ�('01-Jan-2200')�܂ł͈̔͂ɂ��鐮����
% ���Ă̓V���A�����t�ԍ��Ƃ݂Ȃ��v�Z���܂��B���͈̔͊O�ɂ���l��
% ���Ă͐��l���͂Ƃ��ď������܂��B
%
%   datedisp(NumMat)
%   datedisp(NumMat, DateForm)
%   CharMat = datedisp(NumMat, DateForm)
% 
% ����:
%   NumMat   - �\���ΏۂƂȂ鐔�l�s��
%   DateForm - �I�v�V�����Ŏw�肷����t�����B���p�\�ȏ����y�уf�t�H��
%              �g�̏����t���O�ɂ��ẮA"help datestr"�ƃ^�C�v���邱��
%              �ɂ��Q�Ƃł��܂��B
% 
% �o��: 
%   CharMat  - �s��������L�����N�^�z��B�o�͕ϐ������蓖�Ă��Ă��Ȃ�
%              �ꍇ�A���̊֐��̓f�B�X�v���C��ɐ����\�����܂��B
%
% ���:
%   NumMat = [ 730730, 0.03 , 1200 730100;
%              730731, 0.05 , 1000 NaN ]
%   NumMat =
%      1.0e+05 *
%       7.3073    0.0000    0.0120    7.3010
%       7.3073    0.0000    0.0100       NaN
%
%   datedisp(NumMat)
%   01-Sep-2001   0.03   1200   11-Dec-1998   
%   02-Sep-2001   0.05   1000      NaN        
%
% �Q�l : DATESTR.


%   Copyright 1995-2002 The MathWorks, Inc. 