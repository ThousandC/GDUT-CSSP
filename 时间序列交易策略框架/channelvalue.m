function  [ sv , rs ]  =  channelvalue( OHLC , N , hl_c )
%% obtain channel value time series (stochastic values and rank scores)
% hl_c: select channel value type (1(HL) or 2(C))
% sv (T by 1 vector): N-period stochastic values
% rs (T by 1 vector): N-period rank scores



%%
% flag indicating c or hl
if  hl_c == 1
    flag = [2 3];
elseif  hl_c == 2
    flag = [4 4];
end



%%
T = size(OHLC,1);
sv = nan(T,1);
rs = nan(T,1);
for i = N : T
    highmark = max(  OHLC( i-N+1:i , flag(1) )  );
    lowmark = min(  OHLC( i-N+1:i , flag(2) )  );
    sv(i)  =  ( OHLC(i,4) - lowmark )  /  (highmark-lowmark);
    rs(i)  =  sum(  OHLC(i,4) >= OHLC( i-N+1:i-1 , 4 )  )  /  (N-1);
end

