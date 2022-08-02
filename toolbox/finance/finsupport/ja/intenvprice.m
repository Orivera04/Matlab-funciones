% INTENVPRICE   1�g�̃[���Ȑ��ɑ΂���m�藘�t�،��̉��i����
%
% 1�g�̃[���N�[�|�����^������ƁA��������ƂɊm�藘�t���i�̉��i
% ������s���܂� 
%
%   Price = intenvprice(RateSpec, InstSet)
%
% ����:
%   RateSpec - ���i����ɗp����N�����Z���ꂽ�[���������ԍ\���BRateSpec
%              �� 'Rates' �t�B�[���h�͔N�����Z�[��������NPOINTS�s
%              NUMCURVES��̔z��ł��B���ԍ\���̐����Ɋւ���ڍׂɂ�
%              �ẮA"help intenvset"���^�C�v���Ă��������B
%
%   InstSet  - NINST�̐����݂���m�藘�t���i�̏W������Ȃ�ϐ��ł��B
%              �m�藘�t���i�́A�^�C�v���Ƃɕ��ނ���A���ꂼ��̃^�C�v��
%              �قȂ�f�[�^�t�B�[���h�����蓖�Ă��܂��B
%
% �o��:
%   Price   - �e�m�藘�t���i�̉��i����Ȃ�NINST�sNUMCURVES��̍s��ł��B
%             ���i���肪�s���Ȃ������ꍇ�́ANaN�l���o�͂��܂��B
%
% ����:
% INTENVPRICE �́A���̃^�C�v�̊m�藘�t���������邱�Ƃ��ł��܂��B
% 'Bond', 'CashFlow',   'Fixed', 'Float', 'Swap'.  
% �����̃^�C�v�̍��𐶐�����ɂ́A"help instadd"���^�C�v���Ă��������B
%
% ���i����Ɋւ�������������邽�߂ɁA�P��^�C�v�̉��i�֐����Q�Ƃ����
% �́A���Ƃ��� "help swapbyzero"�̂悤�Ƀ^�C�v���Ă��������B
%
%   bondbyzero   - 1�g�̃[���Ȑ��ɂ���č��̉��i�����肵�܂��B
%   cfbyzero     - 1�g�̃[���Ȑ��ɂ���ĔC�ӂ̃L���b�V���t���[�̉��i��
%                  ���肵�܂��B
%   fixedbyzero  - 1�g�̃[���Ȑ��ɂ���Ċm�藘�t�̉��i�����肵�܂��B
%   floatbyzero  - 1�g�̃[���Ȑ��ɂ���ĕϓ����t�̉��i�����肵�܂��B
%   swapbyzero   - 1�g�̃[���Ȑ��ɂ���ăX���b�v�̉��i�����肵�܂��B
%
%
% ���:	
%   load deriv
%   instdisp(ExInstSet)
%   Price = intenvprice(ExRateSpec,ExInstSet)
%
% �Q�l : INTENVSENS, INTENVSET, INSTADD, HJMPRICE, HJMSENS.


%   Author(s): P. N. Secakusuma, M. Reyes-Kattar, 3-Jan-2000
%   Copyright 1998-2002 The MathWorks, Inc. 
