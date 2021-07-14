function  tradesig  =  signal_TS( OHLCV , signaltype , param )
%% ���ɲ�ͬ���͵Ľ����ź�
% ���������tradesig ( T by 1 ): �����ź�����





%% ��ͬ���͵��ź�
switch  signaltype
    
    case 1 % �ź�1: N�ڸߵ㱻ͻ��
        
        N = param(1);
        hl_c = param(2);
        OHLC = OHLCV(:,1:4);
        [ ~ , nhigh ]  =  HighMark( OHLC , N , hl_c );
        tradesig = nhigh;
        
    case 2 % �ź�2: N�ڵ͵㱻ͻ��
        
        N = param(1);
        hl_c = param(2);
        OHLC = OHLCV(:,1:4);
        [ ~ , nlow ]  =  LowMark( OHLC , N , hl_c );
        tradesig = nlow;
        
    case 3 % �ź�3: ˫���߽��
        
        MA  =  calcma( OHLCV(:,4) , param );
        tradesig = MA(1,:)>MA(2,:);
        
    case 4 % �ź�4: ˫��������
        
        MA  =  calcma( OHLCV(:,4) , param );
        tradesig = MA(1,:)<MA(2,:);
        
    case 5 % �ź�5: �۸����ϴ�Խ�������߽�
        
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

    case 6 % �ź�6: �۸����´�Խ�������߽�
        
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
        
    case 7 % �ź�7: �۸����ϴ�Խͨ��ˮƽ��
        
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
        
    case 8 % �ź�8: �۸����´�Խͨ��ˮƽ��
        
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
        
    case 9 % �ź�9: ����
        
        VMA  =  calcma( OHLCV(:,5) , param );
        tradesig  =  VMA(1,:) > VMA(2,:)*1.2;
        
    case 10 % �ź�10: ����
        
        VMA  =  calcma( OHLCV(:,5) , param );
        tradesig  =  VMA(1,:) < VMA(2,:)/1.2;
        
        
    case 11
        
        
    case 12
        
        
        
    otherwise
        
        msgbox( '�ź�����������! ' )
        
end


