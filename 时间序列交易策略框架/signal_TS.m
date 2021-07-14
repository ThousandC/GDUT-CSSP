function  tradesig  =  signal_TS( OHLCV , signaltype , param )
%% 生成不同类型的交易信号
% 输出参数：tradesig ( T by 1 ): 交易信号序列





%% 不同类型的信号
switch  signaltype
    
    case 1 % 信号1: N期高点被突破
        
        N = param(1);
        hl_c = param(2);
        OHLC = OHLCV(:,1:4);
        [ ~ , nhigh ]  =  HighMark( OHLC , N , hl_c );
        tradesig = nhigh;
        
    case 2 % 信号2: N期低点被突破
        
        N = param(1);
        hl_c = param(2);
        OHLC = OHLCV(:,1:4);
        [ ~ , nlow ]  =  LowMark( OHLC , N , hl_c );
        tradesig = nlow;
        
    case 3 % 信号3: 双均线金叉
        
        MA  =  calcma( OHLCV(:,4) , param );
        tradesig = MA(1,:)>MA(2,:);
        
    case 4 % 信号4: 双均线死叉
        
        MA  =  calcma( OHLCV(:,4) , param );
        tradesig = MA(1,:)<MA(2,:);
        
    case 5 % 信号5: 价格向上穿越波动带边界
        
        N = param(1);
        x = param(2);
        b_a = param(3);
        OHLC = OHLCV(:,1:4);
        [ bollband , atrband ]  =  volatilityband( OHLC , N );
        if  b_a == 1
            B = [ 1  x ] * bollband;
        elseif  b_a == 2
            B = [ 1  x ] * atrband;
        end
        T = numel(B);
        tradesig = zeros(T,1);
        for i = 2 : T
            if OHLC(i-1,4)<=B(i-1) && OHLC(i,4)>B(i)
                tradesig(i) = 1;
            end
        end

    case 6 % 信号6: 价格向下穿越波动带边界
        
        N = param(1);
        x = param(2);
        b_a = param(3);
        OHLC = OHLCV(:,1:4);
        [ bollband , atrband ]  =  volatilityband( OHLC , N );
        if  b_a == 1
            B = [ 1  x ] * bollband;
        elseif  b_a == 2
            B = [ 1  x ] * atrband;
        end
        T = numel(B);
        tradesig = zeros(T,1);
        for i = 2 : T
            if OHLC(i-1,4)>=B(i-1) && OHLC(i,4)<B(i)
                tradesig(i) = 1;
            end
        end
        
    case 7 % 信号7: 价格向上穿越通道水平线
        
        N = param(1);
        x = param(2);
        s_r = param(3);
        hl_c = param(4);
        nx = param(5);
        OHLC = OHLCV(:,1:4);
        [ sv , rs ]  =  channelvalue( OHLC , N , hl_c );
        if  s_r == 1
            chnvalue = calcma(sv,nx);
        elseif  s_r == 2
            chnvalue = calcma(rs,nx);
        end
        
        T = numel(chnvalue);
        tradesig = zeros(T,1);
        for i = 2 : T
            if chnvalue(i-1)<=x && chnvalue(i)>x
                tradesig(i) = 1;
            end
        end
        
    case 8 % 信号8: 价格向下穿越通道水平线
        
        N = param(1);
        x = param(2);
        s_r = param(3);
        hl_c = param(4);
        nx = param(5);
        OHLC = OHLCV(:,1:4);
        [ sv , rs ]  =  channelvalue( OHLC , N , hl_c );
        if  s_r == 1
            chnvalue = calcma(sv,nx);
        elseif  s_r == 2
            chnvalue = calcma(rs,nx);
        end
        
        T = numel(chnvalue);
        tradesig = zeros(T,1);
        for i = 2 : T
            if chnvalue(i-1)>=x && chnvalue(i)<x
                tradesig(i) = 1;
            end
        end
        
    case 9 % 信号9: 放量
        
        VMA  =  calcma( OHLCV(:,5) , param );
        tradesig  =  VMA(1,:) > VMA(2,:)*1.2;
        
    case 10 % 信号10: 缩量
        
        VMA  =  calcma( OHLCV(:,5) , param );
        tradesig  =  VMA(1,:) < VMA(2,:)/1.2;
        
        
    case 11
        
        
    case 12
        
        
        
    otherwise
        
        msgbox( '信号类型序号输错! ' )
        
end


