function  [ bollband , atrband ]  =  volatilityband( OHLC , N )
%% 计算N期价格波动带时间序列 (两种: 布林带; ATR带)
% bollband (2 by T): 第一排：均线；第二排：标准差序列
% atrband (2 by T): 第一排：均线；第二排：atr序列





%%
T = size(OHLC,1);


%% 计算波动带序列

% middle line (moving averages)
MA = calcma( OHLC(:,4) , N );

% bollinger band
bollwidth = nan(1,T);
for i = N:T
    bollwidth(i)  =  std( OHLC(i-N+1:i, 4) );
end
bollband = [ MA ; bollwidth ];

% ATR band
range1  =  OHLC(:,2) - OHLC(:,3);
range2  =  abs(  OHLC( 2:end , 2 ) - OHLC( 1:end-1 , 4 )  );
range3  =  abs(  OHLC( 2:end , 3 ) - OHLC( 1:end-1 , 4 )  );
tr  =  max( [range1(2:end) range2 range3] , [] , 2 ); % true range
tr = [ range1(1) ; tr ];
atr = calcma( tr , N );
atrband = [ MA ; atr ];


