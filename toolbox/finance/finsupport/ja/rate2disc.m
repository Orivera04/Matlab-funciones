% RATE2DISC   ���q�����L���b�V���t���[�����t�@�N�^�ɕϊ�
%
% NPOINTS �̎��ԊԊu�ɓn���āA�N������^���āA�L���b�V�����������肵�܂��B
% NCURVES �̈قȂ闘���Ȑ��́A����̎��ԍ\�������ꍇ�Ɍ���A��x��
% �ϊ����邱�Ƃ��ł��܂��B�C���^�[�o���̓[���Ȑ��A�܂��́A�t�H���[�h�Ȑ�
% �ŕ\�����邱�Ƃ��\�ł��B
%
% �g�p�@ 1: �C���^�[�o���|�C���g�́A���ԒP�ʕ\���̎��Ԃœ��͂��܂��B
%   [Disc] = rate2disc(Compounding, Rates, EndTimes)
%   [Disc] = rate2disc(Compounding, Rates, EndTimes, StartTimes)
%
% �g�p�@ 2: ValuationDate �͏ȗ��ł��܂��B�܂��A�C���^�[�o���|�C���g��
%           ���t�œ��͂��܂��B
%   [Disc, EndTimes, StartTimes] = rate2disc(Compounding, Rates, ... 
%     EndDates, StartDates, ValuationDate)
% 
% ����
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
%   Rates       - 10�i�@�ŕ\�킵�� NPOINTS �s NCURVES ��̍s��ł��B����
%                 ���΁A5 �́ARates �ł́A0.05 �ł��BRates �́A�L���b�V��
%                 �t���[���]������� StartTimes ����A�L���b�V���t���[
%                 �̎����ł��� EndTimes ���I�_�Ƃ��铊���C���^�[�o����
%                 �΂��闘���ł��B
%
%   �g�p�@ 1:ValuationDate ���ȗ�����Ȃ������P�[�X�ł́A3�Ԗڋy��4�Ԗ�
%            �̈����́A���ԂƂ��ĉ��߂���܂��B
%
%   EndTimes    - �������K�p�����C���^�[�o���̏I�_�ƂȂ鎞�Ԃ����ԒP��
%                 �Ŏ��� NPOINTS �s1��̃x�N�g���ł��B
%
%   StartTimes  - �������K�p�����C���^�[�o���̎n�_�ƂȂ鎞�Ԃ����ԒP��
%                 �Ŏ��� NPOINTS �s1��̃x�N�g���ł��BStartTimes �̓I�v
%                 �V�����̈����Ńf�t�H���g�l��0�ł��B
%
%   �g�p�@ 2:ValuationDate ���ȗ����ꂽ�ꍇ�A3�Ԗڋy��4�Ԗڂ̈����͓��t
%            �Ƃ��ĉ��߂���܂��B ���t ValuationDate �́A���Ԃ��v�Z����
%            �ۂ̃[���_�Ƃ��ėp�����܂��B
%
%   EndDates      - �������K�p�����C���^�[�o���̏I�_�ƂȂ閞�������V��
%                   �A�����t�`���Ŏ����X�J���l�A�܂��́ANPOINTS �s1���
%                   �x�N�g���ł��B
%
%   StartDates    - �������K�p�����C���^�[�o���̎n�_�ƂȂ���t���V���A
%                   �����t�`���Ŏ����X�J���l�A�܂��́ANPOINTS �s 1���
%                   �x�N�g���ł��BStartDates �̓I�v�V�����̈����ŁA
%                   �f�t�H���g�l�� ValuationDate �ł��B
%
%   ValuationDate - StartDates �� EndDates �œ��͂��ꂽ�������E�̊ϑ���
%                   (observation date)���V���A�����t�`���Ŏ����X�J���l��
%                   ���BValuationDate �́A�g�p�@2�ł͕K�{�ƂȂ�܂��B
%                   ����A�g�p�@1�ł́AValuationDate �͏ȗ����邩�A
%                   ��s��ɂ���ē��͂��p�X���Ȃ���΂Ȃ�܂���B
%
% �o��:
%   Disc          - EndTime �Ŏ����ꂽ���_�Ŏ󂯎��P�ʃL���b�V���t���[
%                   ���AStartTime �Ŏw�肳�ꂽ���_�ŗL���鉿�l��10�i���\
%                   �L�Ŏ��������t�@�N�^����Ȃ� NPOINTS �s NCURVES ���
%                   ��x�N�g���ł��B
% 
%   StartTimes    - �������K�p�����C���^�[�o���̎n�_�ƂȂ鎞�Ԃ����� 
%                   NPOINTS �s1��̗�x�N�g���ł��B�����āA���̎��Ԃ́A
%                   ���ԒP�ʂő��肳��܂��B
%
%   EndTimes      - �������K�p�����C���^�[�o���̏I�_�ƂȂ鎞�Ԃ����� 
%                   NPOINTS �s1��̗�x�N�g���ł��B�����āA���̎��Ԃ́A
%                   ���ԒP�ʂő��肳��܂��B
%  
% ���ӁF
% Compounding = 365 (��������)�̏ꍇ�A StartTimes �� EndTimes �́A���P��
% �ő��肳��܂��B����ȊO�̏ꍇ�A���̈����́ASIA ���N�^�C���t�@�N�^ 
% Tsemi ����A����  T = Tsemi/2 * F �ɂ���Čv�Z���ꂽ�l���܂ނ��ƂɂȂ�
% �܂��B�����ŁAF �͕����v�Z�̕p�x�������Ă��܂��B���Ƃ��΁A�A��������
% �ꍇ�AF ��1�ɐݒ肳��܂��B
%
% �����C���^�[�o���́A���͂��ꂽ����(�g�p�@ 1)�A�܂��́A���͂��ꂽ���t
% (�g�p�@ 2)�̂����ꂩ�Ɏw��ł��܂��B���� ValuationDate �����͂�����
% ���t���߂��Ăяo������� ValuationDate ���ȗ������ƁA�f�t�H���g��
% ���ԉ��߂��Ăяo����邱�ƂɂȂ�܂��B
%
% ���:
%   1) 6����, 12����, 24�����ɂ����銄�����[���Ȑ�����v�Z���܂��B�L���b
%      �V���t���[�܂ł̎��Ԃ́A1, 2, 4�ŁA�����ł́A�L���b�V���t���[��
%      ���݉��l(����0)���v�Z���܂��B
%
%   Compounding = 2;
%   Rates = [0.05; 0.06; 0.065];
%   EndTimes   = [1; 2; 4];
%   Disc = rate2disc(Compounding, Rates, EndTimes)
%
%   StartTimes = [0; 0; 0];
%   Disc = rate2disc(Compounding, Rates, EndTimes, StartTimes)
% 
%   2)6����, 12����, 24�����ɂ����銄�����[���Ȑ�����v�Z���܂��B����
%     �͈͂̏I�_����t�Ŏw�肵�܂��B
%
%   Compounding = 2;
%   Rates = [0.05; 0.06; 0.065];
%   EndDates = ['10/15/97'; '04/15/98'; '04/15/99'];
%   ValuationDate = '4/15/97'; 
%   Disc = rate2disc(Compounding, Rates, EndDates, [], ValuationDate)
%
%   3)�����_���n�_�Ƃ���1�N�t�H���[�h��������6�����y��12�����̊������v�Z
%     ���܂��B�����v�Z�ł͖���������K�p���܂��B�L���b�V���t���[�܂ł�
%     ���Ԃ́A12�A18�A24�A�t�H���[�h�^�C���́A0�A6�A12�@�ł��B
%
%   Compounding = 12;
%   Rates = [0.05; 0.04; 0.06];
%   EndTimes = [12; 18; 24];
%   StartTimes = [0; 6; 12];
%   Disc = rate2disc(Compounding, Rates, EndTimes, StartTimes)
%
% �Q�l : DISC2RATE, RATETIMES.


%   Author(s): J. Akao 11/03/98
%   Copyright 1995-2002 The MathWorks, Inc. 
