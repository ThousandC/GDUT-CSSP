function  [ Capital , H ]  =  Strategy_MAcross2( TOHLCV , paramcell , inicash )
%% ����MAcross���ղ��ԣ�˫���߽��棩





%% �⿪������
param1 = paramcell{1}; % ����������
param2 = paramcell{2}; % ����������



%% ������ϴ

% deal with NaN and Zero-volume rows for each stock
Inonnan = ~isnan( sum(TOHLCV, 2) ); % non-nan logical index
Inonzerovol = TOHLCV(:,6) ~= 0; % non-zero-volume logical index
Ivalid = Inonnan & Inonzerovol; % valid logical index

% only include valid data points
valdata = TOHLCV(Ivalid,:);



%%  ���ɽ����ź�

OHLCV = valdata(:,2:6);
shortsig  =  signal_TS( OHLCV , 4 , param1 );
longsig  =  signal_TS( OHLCV , 3 , param2 );
entrysignal  =  shortsig;
exitsignal  =  longsig;



%% ģ�⽻��
    
% ģ�⽻��
OHLC = valdata(:,2:5);
[ H , ~ , Capital ]  =  signaltradeS( OHLC , entrysignal , exitsignal , inicash );

% �������ݳ���
Capital = fillstock2index( Capital , Ivalid , numel(Ivalid) , inicash , 1 );
h1 = fillstock2index( H(1,:) , Ivalid , numel(Ivalid) , 0 , 1 );
h2 = fillstock2index( H(2,:) , Ivalid , numel(Ivalid) , 0 , 1 );
H = [ h1 ; h2 ];


