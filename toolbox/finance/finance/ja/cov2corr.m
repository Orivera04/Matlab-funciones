% COV2CORR   �����U��W���΍��y�ё��֌W���ɕϊ�
%
% N�̃����_���v���Z�X�̃{���e�B���e�B�Ɗe�v���Z�X�Ԃ̑��֓x�����v�Z
% ���܂��B
%
%      [ExpSigma, ExpCorrC] = cov2corr(ExpCovariance)
%
% ����:
%   ExpCovariance: N�sN��̋����U�s��(COV�A�܂��́AEWSTATS ����Z�o)
%
% �o��:
%   ExpSigma     : �e�v���Z�X�̕W���΍����܂�1�sN��̃x�N�g��
%
%   ExpCorrC     : ���֌W����N�sN��̍s��BExpCorrC �̓��͂�1(���S��
%                  ����)����-1(���S�ɋt����)�܂ł͈̔͂ƂȂ�܂��B
%                  (i,j) �̓��͗v�f��0�̏ꍇ�Ai�Ԗڂ�j�Ԗڂ̃v���Z�X��
%                  ���֊֌W�ɂȂ����ƂɂȂ�܂��B
% 
%        ExpSigma(i)= sqrt( ExpCovariance(i,i));
%        ExpCorrC(i,j)= ExpCovariance(i,j)/( ExpSigma(i)*ExpSigma(j));
% 
% �Q�l : EWSTATS, COV, CORRCOEF, STD, CORR2COV.


%    Author J. Akao 11/17/97
%    Copyright 1995-2002 The MathWorks, Inc.  
