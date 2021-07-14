function  [ Capital , H ]  =  Strategy_MAcross2( TOHLCV , paramcell , inicash )
%% 部署MAcross做空策略（双均线交叉）





%% 解开参数包
param1 = paramcell{1}; % 进场参数包
param2 = paramcell{2}; % 出场参数包



%% 数据清洗

% deal with NaN and Zero-volume rows for each stock
Inonnan = ~isnan( sum(TOHLCV, 2) ); % non-nan logical index
Inonzerovol = TOHLCV(:,6) ~= 0; % non-zero-volume logical index
Ivalid = Inonnan & Inonzerovol; % valid logical index

% only include valid data points
valdata = TOHLCV(Ivalid,:);



%%  生成交易信号

OHLCV = valdata(:,2:6);
shortsig  =  signal_TS( OHLCV , 4 , param1 );
longsig  =  signal_TS( OHLCV , 3 , param2 );
entrysignal  =  shortsig;
exitsignal  =  longsig;



%% 模拟交易
    
% 模拟交易
OHLC = valdata(:,2:5);
[ H , ~ , Capital ]  =  signaltradeS( OHLC , entrysignal , exitsignal , inicash );

% 补齐数据长度
Capital = fillstock2index( Capital , Ivalid , numel(Ivalid) , inicash , 1 );
h1 = fillstock2index( H(1,:) , Ivalid , numel(Ivalid) , 0 , 1 );
h2 = fillstock2index( H(2,:) , Ivalid , numel(Ivalid) , 0 , 1 );
H = [ h1 ; h2 ];


