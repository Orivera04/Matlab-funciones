% INTENVSENS   ���̊����x�y�щ��i��1�g�̃[���Ȑ����猈��
%
% �[���N�[�|���̗������ԍ\�����g�p���āA���̃h�������x�A���i���v�Z
% ���܂��B
%
%   [Delta, Gamma, Price] = intenvsens(RateSpec, InstSet)
%
% ����:
%   RateSpec - ���i����ɗp����N�����Z���ꂽ�[���������ԍ\���BRateSpec
%              �� 'Rates' �t�B�[���h�͔N�����Z�[��������NPOINTS�s
%              NUMCURVES��̔z��ł��B���ԍ\���̐����Ɋւ���ڍׂɂ�
%              �ẮA"help intenvset"���^�C�v���Ă��������B
%
%   InstSet  - NINST�̐����݂�����̏W������Ȃ�ϐ��ł��B���́A
%              �^�C�v���Ƃɕ��ނ���A���ꂼ��̃^�C�v�ɈقȂ�f�[�^
%              �t�B�[���h�����蓖�Ă��܂��B
% �o��:
%   Delta   - �ϑ����ꂽ�t�H���[�h�����Ȑ��̃V�t�g�ɂ���Ăǂꂾ����
%             �̉��i���ω����邩�A���̊����������f���^����Ȃ�NINST�s
%             NUMCURVES��̍s��ł��B�f���^�͍����ɂ���Čv�Z����܂��B
%
%   Gamma   - �ϑ����ꂽ�t�H���[�h�����Ȑ��̃V�t�g�ɂ���āA�ǂꂾ��
%             ���̃f���^���ω����邩�A���̊����������K���}����Ȃ�
%             NINST�sNUMCURVES��̍s��ł��B�K���}�͍����ɂ���Čv�Z
%             ����܂��B
%
%   Price   - �e���̉��i����Ȃ�NINST�sNUMCURVES��̍s��ł��B���i����
%             ���s���Ȃ������ꍇ�́ANaN�l���o�͂��܂��B
%
% ���ӁF
%   INTENVSENS �͎��̃^�C�v�̍����������Ƃ��ł��܂��B
%   'Bond', 'CashFlow','Fixed', 'Float', 'Swap'.  
%   �����Œ�`���ꂽ�^�C�v�̍��𐶐�����ɂ́A"help instadd"���Q��
%   ���Ă��������B
%
% ���:
%   load deriv
%   instdisp(ExInstSet)
%   [Delta, Gamma]= intenvsens(ExRateSpec,ExInstSet)
%
% �Q�l : INTENVPRICE, INTENVSET, INSTADD, HJMPRICE, HJMSENS.


%   Author(s): P. N. Secakusuma, M. Reyes-Kattar, 3-Jan-2000
%   Copyright 1998-2002 The MathWorks, Inc. 
