% RATETIMES   ���q�������`���鎞�ԃC���^�[�o����ύX
%
% ���q�������A���ԃC���^�[�o���̏W���ɑ΂��闘���Œ�`���A���̎���
% �C���^�[�o���̏W���ɑ΂��闘�����v�Z���܂��B�[�����͎��Ԃɑ΂���
% �敪�I�ɐ��`�ł���Ɖ��肳��܂��B
%
% �g�p�@ 1
%   [Rates, EndTimes, StartTimes] = ratetimes(Compounding, ...
%      RefRates, RefEndTimes, RefStartTimes, EndTimes)
%
%   [Rates, EndTimes, StartTimes] = ratetimes(Compounding, ...
%      RefRates, RefEndTimes, RefStartTimes, EndTimes, StartTimes)
%     
%   �I�v�V����: RefStartTimes, StartTimes
%
% �g�p�@ 2 : 
%   ValuationDate �͏ȗ��ł��܂��B�Ȃ��A�C���^�[�o���|�C���g�͓��t��
%   ���͂��Ă��������B
%   [Rates, EndTimes, StartTimes] = ratetimes(Compounding, ...
%      RefRates, RefEndDates, RefStartDates, EndDates, StartDates, ...
%      ValuationDate)
%
% ����:
%   Compounding - �N�����Z���ɁA���͂��ꂽ�[�������ǂ̂悤�ȓx���ŕ���
%                 �v�Z���邩�������X�J���l�ł��B���̈����́A�����t�@�N�^
%                 �y�� Times �̉��߂ɓK�p���鎮�����̂悤�Ɍ��肵�܂��B
%     1)Compounding = 1, 2, 3, 4, 6, 12 = F
%        Disc = (1 + Z/F)^(-T), �����ŁAF �͕����x���ł��BZ �̓[�����A 
%        T �͊��ԒP��(periodic unit)�Ŏ����ꂽ�񐔂ŁAT = F �̏ꍇ�A1�N��
%        �w�������܂��B
%     2)Compounding = 365 
%        Disc = (1 + Z/F)^(-T)�A�����ŁAF �͊�ƂȂ�N�̓����AT �͊
%        �ƂȂ�N�Ɋ�Â��Čv�Z�����o�ߓ����ł��B
%     3)Compounding = -1
%        Disc = exp( -T * Z ), T �͔N�Ŏ����ꂽ���Ԃ������Ă��܂��B
%
%   RefRates    - ��ƂȂ闘����10�i���Ŏ��� NREFPTS �s NCURVES ���
%                 �x�N�g���ł��BRefRates �́A�L���b�V���t���[���]������� 
%                 RefStartTimes ����A�L���b�V���t���[�̎����ł��� 
%                 RefEndTimes ���I�_�Ƃ��铊���C���^�[�o���ɑ΂��闘���
%                 �ł��B
%
%   �g�p�@ 1: ValuationDate ���ȗ�����Ȃ��ꍇ�A3�Ԗڋy��4�Ԗڂ̈�����
%             ���ԂƂ��ĉ��߂���܂��B
%
%   RefEndTimes   - RefRates �ɑΉ�����C���^�[�o���̏I�_�ƂȂ鎞�Ԃ�
%                   ���ԒP�ʂŎ��� NREFPTS �s1��̃x�N�g���ł��B
%
%   RefStartTimes - RefRates �ɑΉ�����C���^�[�o���̎n�_�ƂȂ鎞�Ԃ�
%                   ���ԒP�ʂŎ��� NREFPTS �s1��x�N�g���ł��B
%                   RefStartTimes �́A�I�v�V�����̈����ŁA�f�t�H���g�l��
%                   0�ł��B
%
%   EndTimes      - �������K�p�����C���^�[�o���̏I�_�ƂȂ鎞�Ԃ�����
%                   �P�ʂŎ��� NPOINTS �s1��̃x�N�g���ł��B
%
%   StartTimes    - �������K�p�����C���^�[�o���̎n�_�ƂȂ鎞�Ԃ�����
%                   �P�ʂŎ��� NPOINTS �s1��̃x�N�g���ł��BStartTimes ��
%                   �I�v�V�����̈����ŁA�f�t�H���g�l��0�ł��B
%
%   �g�p�@ 2:ValuationDate ���ȗ����ꂽ�ꍇ�A3�Ԗڋy��4�Ԗڂ̈����͓��t
%            �Ƃ��ĉ��߂���܂��B ���t ValuationDate �́A���Ԃ��v�Z����
%            �ۂ̃[�����W�Ƃ��ėp�����܂��B
%
%   RefEndDates   - RefRates �ɑΉ�����C���^�[�o���̏I�_�ƂȂ閞������
%                   �V���A�����t�`���Ŏ����X�J���l�A�܂��́ANREFPTS �s
%                   1��̃x�N�g���ł��B
%
%   RefStartDates - RefRates �ɑΉ�����C���^�[�o���̎n�_�ƂȂ���t��
%                   �V���A�����t�`���Ŏ����X�J���l�A�܂��́ANREFPTS�s1��
%                   �̃x�N�g���ł��BRefStartDates �́A�I�v�V�����̈�����
%                   �f�t�H���g�l�́AValuationDate �Ɠ��l�ł��B
%
%   EndDates      - ��]���闘���ƂȂ�V�����C���^�[�o���̏I�_�ƂȂ�
%                   ���������V���A�����t�`���Ŏ����X�J���l�A�܂��́A
%                   NPOINTS�s1��̃x�N�g���ł��B
%
%   StartDates    - ��]���闘���ƂȂ�V�����C���^�[�o���̎n�_�ƂȂ���t
%                   ���V���A�����t�`���Ŏ����X�J���l�A�܂��́ANPOINTS�s
%                   1��̃x�N�g���ł��BStartDates �̓I�v�V�����̈����ŁA
%                   �f�t�H���g�l�� ValuationDate �Ɠ��l�ł��B
%
%   ValuationDate - StartDates �� EndDates �œ��͂��ꂽ�������E�̊ϑ���
%                   (observation date)���V���A�����t�`���Ŏ����X�J���l��
%                   ���BValuationDate �͎g�p�@2�ł͕K�{�ƂȂ�܂��B���
%                   �g�p�@1�ł́AValuationDate �͏ȗ����邩�A��s���
%                   ����ē��͂��p�X���Ȃ���΂Ȃ�܂���B
%
% �o��:
%   Rates         - ������\���ɂ���ĈÎ�����A�V�����C���^�[�o����
%                   �T���v�����O����闘�q�������� NPOINTS x NCURVES ��
%                   ��x�N�g���ł��B
% 
%   StartTimes    - ��]���闘���ƂȂ�V�����C���^�[�o���̎n�_�ƂȂ鎞��
%                   ������ NPOINTS �s1��̗�x�N�g���ł��B�Ȃ��A���̎���
%                   �́A���ԒP�ʂő��肳��܂��B
%
%   EndTimes      -  ��]���闘���ƂȂ�V�����C���^�[�o���̏I�_�ƂȂ�
%                    ���Ԃ����� NPOINTS �s1��̗�x�N�g���ł��B�Ȃ��A
%                    ���̎��Ԃ́A���ԒP�ʂő��肳��܂��B
%  
% ���ӁF
% Compounding = 365 (daily)�̏ꍇ�A StartTimes �� EndTimes �́A���P�ʂ�
% ���肳��܂��B����ȊO�̏ꍇ�A���̈����́ASIA ���N�^�C���t�@�N�^ Tsemi
% ����A���� T = Tsemi/2 * F �ɂ���Čv�Z���ꂽ�l���܂ނ��ƂɂȂ�܂��B
% �����ŁAF �͕����v�Z�̕p�x�������Ă��܂��B���Ƃ��΁A�A�������̏ꍇ�A
% F ��1�ɐݒ肳��܂��B
%
% �����C���^�[�o���́A���͂��ꂽ���� (�g�p�@ 1)�A�܂��́A���͂��ꂽ���t
% (�g�p�@ 2)�̂����ꂩ�ɂ���Ďw��ł��܂��B���� ValuationDate ������
% �����ƁA���t���߂��Ăяo����A���� ValuationDate ���ȗ������ƁA
% �f�t�H���g�̎��ԉ��߂��Ăяo����邱�ƂɂȂ�܂��B
%
% ���:
%   1)������A6�A12�A24�������_�ł̃[�����̏W���ł���Ƃ��܂��B����
%     0�A6�A12�����ɃX�^�[�g����1�N�t�H���[�h�����̏W�����o�͂��܂��B
%
%   RefRates = [0.05; 0.06; 0.065];
%   RefEndTimes = [1; 2; 4];
%   StartTimes = [0; 1; 2];
%   EndTimes   = [2; 3; 4];
%   Rates = ratetimes(2, RefRates, RefEndTimes, 0, EndTimes, StartTimes)
% 
%   2)�قȂ���t�Ƀ[�������Ȑ�����}���܂��B�[���Ȑ��́AValuationDate 
%     �̃f�t�H���g�̓��t�ɃX�^�[�g���܂��B
%
%   RefRates = [0.04; 0.05; 0.052];
%   RefDates = [729756; 729907; 730121];
%   Dates    = [730241; 730486];
%   ValuationDate   = 729391;
%   [Rate] = ratetimes(2, RefRates, RefDates, [], Dates, [],....
%              ValuationDate)
%
% �Q�l : RATE2DISC, DISC2RATE.


%   Author(s): J. Akao 12/15/98
%   Copyright 1995-2002 The MathWorks, Inc. 
