function  [ E , Rtn ]  =  Strategy_DT( TOHLCV , paramcell )
%% deploy Dual-Thrust strategy (range method: max(maxH-minC,maxC-minL) )





%% 参数包解包
N = paramcell{1};
K = paramcell{2};
tcrate = paramcell{3};



%% 
OHLC = TOHLCV(:,2:5);
T = size(OHLC, 1);
Rtn1 = zeros(T,1);
Rtn2 = zeros(T,1);
for  i = N+1 : T
    
    % 计算触发价格
    range1 = max( OHLC(i-N:i-1,2) ) - min( OHLC(i-N:i-1,4) );
    range2 = max( OHLC(i-N:i-1,4) ) - min( OHLC(i-N:i-1,3) );
    range = max( range1 , range2 );
    trigprc = OHLC(i,1) + [ K(1)  -K(2) ] * range;
    
    % 回报
    if    OHLC(i,2) >= trigprc(1)
        Rtn1(i) = OHLC(i,4) * ( 1 - tcrate )  -  trigprc(1) * ( 1 + tcrate );
    end
    if    OHLC(i,3) <= trigprc(2)
        Rtn2(i) = trigprc(2) * ( 1 - tcrate )  -  OHLC(i,4) * ( 1 + tcrate );
    end

end
Rtn = Rtn1 + Rtn2;
Equity = cumsum( Rtn ) /  OHLC(1,4)  +  1;
Equity1 = cumsum( Rtn1 ) /  OHLC(1,4)  +  1;
Equity2 = cumsum( Rtn2 ) /  OHLC(1,4)  +  1;
E  =  [ Equity Equity1 Equity2 ];


