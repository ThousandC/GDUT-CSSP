function  [ E , Rtn ]  =  Strategy_ORB3( TOHLCV , paramcell )
%% deploy range-break strategy (range method: H-L, open-centered)





%% ���������
N = paramcell{1};
K = paramcell{2};
tcrate = paramcell{3};



%% 
OHLC = TOHLCV(:,2:5);
T = size(OHLC, 1);
Rtn1 = zeros(T,1);
Rtn2 = zeros(T,1);
for  i = N+1 : T
    
    % ���㴥���۸�
    range = OHLC(i-N:i-1,2) - OHLC(i-N:i-1,3);
    trigprc = OHLC(i,1) + [ K(1)  -K(2) ] * mean(range);
    
    % �ر�
    if   OHLC(i,2) >= trigprc(1)
        Rtn1(i) = OHLC(i,4) * ( 1 - tcrate )  -  trigprc(1) * ( 1 + tcrate );
    end
    if   OHLC(i,3) <= trigprc(2)
        Rtn2(i) = trigprc(2) * ( 1 - tcrate )  -  OHLC(i,4) * ( 1 + tcrate );
    end

end
Rtn = Rtn1 + Rtn2;
Equity = cumsum( Rtn ) /  OHLC(1,4)  +  1;
Equity1 = cumsum( Rtn1 ) /  OHLC(1,4)  +  1;
Equity2 = cumsum( Rtn2 ) /  OHLC(1,4)  +  1;
E  =  [ Equity Equity1 Equity2 ];


