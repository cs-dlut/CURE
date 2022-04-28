function [pi,coop]=MCpayoff(n,generation,r,c,deltaT,eps);
%计算mem-1和cure进行PGG博弈的各自收益和合作率

%% define all strategy
Str=zeros(2^(2*n),2*n);ns=2^(2*n);
for k=1:ns
    Str(k,:)=sscanf(dec2bin(k-1,2*n), '%1d' )';
end % 将ns个策略转换成二进制，即从0（0000 0000）到255（1111 1111）
%% Setting up the random number generator
C=clock;
rng(C(5)*60+C(6));
%% submain
pi=zeros(ns,2);coop=zeros(ns,2);%存储CURE和MEMM进行PGG博弈各自的收益和合作率,第一列是CURE,第二列是MEM
Str=(1-eps)*Str+eps*(1-Str);
for i=1:ns %遍历mem策略
    for k=1:n-1 %group中策略mem的数量（mem）
        PI_round=zeros(generation,n);CO_round=zeros(generation,n);act=zeros(generation,n); Dt=zeros(1,n);
       
        act(1:2,1:k)=randi([0,1],2,k);act(1:2,k+1:n)=1;nc1=sum(act(1,:));
        for x=1:n
        PI_round(1,x)=r*nc1*c/n-act(1,x)*c;
        CO_round(1,x)=act(1,x);
        end
        for t = 2:generation
            nct=sum(act(t,:));%本轮的合作者数
            for y=1:n %本轮每个个体的收益
                PI_round(t,y)=PI_round(t-1,y)*(t-1)/t+(nct*r*c/n-act(t,y)*c)/t;
                CO_round(t,y)=CO_round(t-1,y)*(t-1)/t+act(t,y)/t;
                
                Dt(1,y)=Dt(1,y)+act(t,y)-(nct-act(t,y))/(n-1);%更新每个玩家视角下，对手与自己的背叛差
                if y<=k
                    if (act(t,y)==1 && rand(1)<Str(i,n-nct+1) || act(t,y)==0 && rand(1)<Str(i,2*n-nct))%mem-1
                        act(t+1,y)=1;
                    else
                        act(t+1,y)=0;
                    end
                else
                    if Dt(1,y)>deltaT && rand(1)<1-eps || Dt(1,y)<=deltaT && rand(1)<eps %cure
                        act(t+1,y)=0;%0=D;1=C
                    else
                        act(t+1,y)=1;
                    end
                end
            end
        end
       pi(i,2)=pi(i,2)*(k-1)/k+PI_round(generation,1)/k;
         pi(i,1)= pi(i,1)*(k-1)/k+PI_round(generation,end)/k;
        coop(i,2)=coop(i,2)*(k-1)/k+CO_round(generation,1)/k;
        coop(i,1)=coop(i,1)*(k-1)/k+CO_round(generation,end)/k;
    end
end
end
