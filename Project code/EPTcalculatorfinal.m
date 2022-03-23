bpFinal=2*[0.8058 0.7322 0.3469 0.6069 -0.3441 0.5729 0.8030 0.2257 -0.0181 0 0 0 0 0.9888 1.1886 0.3673 0.5982 0.2853 0.3388 0.1422 0.2781 0.0430 -0.0221 -0.0748 -0.8167 -0.1902 -0.4846 -0.7461];

loadDemand=[3.811 4.132 3.962 3.981 3.868 3.83 3.811 3.736 3.66 3.585 3.509 3.434 3.321 3.264 3.189 3.151 3.208 3.226 3.189 3.208 3.302 3.491 3.736 3.868 3.811 3.792 3.906 4.255];

OP_demand=bpFinal+loadDemand;

grid_price=[2.946 2.865 2.842 3.039 3.34 3.595 3.629 3.398 3.015 2.714 2.517 2.448 2.008 1.718 1.683 1.718 1.683 1.637 1.614 1.625 1.625 1.614 1.637 1.822 2.286 2.842 3.27 3.525];

ept=zeros(1,28);
soc=zeros(1,28);

for a=1:28 
                if(a==1)
                    soc(a)=0.4+((OP_demand(a))/54);
                else
                    soc(a)=soc(a-1)+((OP_demand(a))/54);
                end
end

for i=1:28
    if(bpFinal(i)>0)
        if(i==1)
        ept(i)=(3*0.4*54 + bpFinal(i)*grid_price(i))/(0.4*54+bpFinal(i));
        else
        ept(i)=(ept(i-1)*soc(i-1)*54 + bpFinal(i)*grid_price(i))/(soc(i)*54+bpFinal(i));
        end
    else
        ept(i)=ept(i-1);
    end
end

%%reference check
%ref=zeros(1,28);
%r=zeros(1,28);
%for i=1:28
%    if(grid_price(i)>EPT(i))
%       r=0; 
%    else
%       r=1;
%    end
%end

x = 0:0.5:13.5;
y1 = [3 2.97 2.95 2.96 3.006 3.07 3.13 3.16 3.16 3.16 3.16 3.16 3.16 3.16 3.16 3.16 3.16 3.16 3.16 3.16 3.16 3.16 3.16 3.16 3.16 3.16 3.16 3.16];
plot(x,y1)
title('PEV Energy Price Tag Comaprison')

hold on

plot(x,ept)

xlabel('Time');
ylabel('PEV EPT');
legend('Without Optimization', 'With Optimization');
grid on;


hold off

