function [p_block_pri,p_block_sec,throughput,p_drop_pri,p_drop_sec]=MT(c1,c2,a1,a2,d1,d2)
%%
%% 解线性方程组 
%c1=3;c2=3;
%a1=0.2;a2=0.1;d1=0.4;d2=0.3;

syms p_block_pri p_block_sec throughput p_drop_pri p_drop_sec 
n=0;
for i=0:c1+c2
    for j=0:c1+c2
        if i+j<=6
            n=n+1;
            b(i+1,j+1)=n;
        end
    end
end

for p=1:n
    for q=1:n
        mt(p,q)=0;
    end
end

%以下构建系数矩阵
for i=0:c1+c2
    for j=0:c1+c2
        if (i+j<=6)
            row = b(i+1,j+1);
            if (i==0) && (j==0)
                mt(row,b(i+1,j+1)) = -(a1+a2);
                mt(row,b(i+1,j+2)) = d2;
                mt(row,b(i+2,j+1)) = d1;            
            elseif (i==0) && (j>=1) && (j<=5)
                mt(row,b(i+1,j+1)) = -(a1+a2+j*d2);
                mt(row,b(i+1,j)) = a2;
                mt(row,b(i+1,j+2)) = (j+1)*d2;
                mt(row,b(i+2,j+1)) = d1;
            elseif (i==0) && (j==6)
                mt(row,b(i+1,j+1)) = -(j*d2+a1);
                mt(row,b(i+1,j)) = a2;
            elseif (i>=1) && (i<=5) && (j==0)
                mt(row,b(i+1,j+1)) = -(i*d1+a2+a1);
                mt(row,b(i,j+1)) = a1;
                mt(row,b(i+1,j+2)) = d2;
                mt(row,b(i+2,j+1)) = (i+1)*d1;
            elseif (i>=1) && (i<=4) && (j>=1) && (i+j<=5)
                mt(row,b(i+1,j+1)) = -(i*d1+a2+a1+j*d2);
                mt(row,b(i,j+1)) = a1;
                mt(row,b(i+1,j+2)) = (j+1)*d2;
                mt(row,b(i+2,j+1)) = (i+1)*d1;
                mt(row,b(i+1,j)) = a2;
            elseif (i>=1) && (i<=2) && (i+j==6)
                mt(row,b(i+1,j+1)) = -(i*d1+a1+j*d2);
                mt(row,b(i,j+1)) = a1;
                mt(row,b(i,j+2)) = a1;
                mt(row,b(i+1,j)) = a2;
            elseif (i==3) && (j==3)
                mt(row,b(i+1,j+1)) = -(i*d1+j*d2);
                mt(row,b(i,j+1)) = a1;
                mt(row,b(i,j+2)) = a1;
                mt(row,b(i+1,j)) = a2;
                mt(row,b(i+2,j)) = a2;
            elseif (i>=4) && (i<=5) && (i+j==6)
                mt(row,b(i+1,j+1)) = -(i*d1+a2+j*d2);
                mt(row,b(i,j+1)) = a1;
                mt(row,b(i+2,j)) = a2;
                mt(row,b(i+1,j)) = a2;
            elseif (i==6) && (j==0)
                mt(row,b(i+1,j+1)) = -(i*d1+a2);
                mt(row,b(i,j+1)) = a1;
            end
   
        end
    end
end
%mt
% for i=1:n;
%     mt(n,i)=1;
% end
%%最后一行为全1；
% for i=1:(n-1);
%     p(i)=0;
% end
% p(n)=1;

%%第一行为全1；
for i=1:n
    mt(1,i)=1;
end

%mt

for i=2:n
    p(i)=0;
end
p(1)=1;

p=p';
%p=[0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1]';
P=mt\p;
p_block_pri = P(b(7,1))+P(b(6,2))+P(b(5,3))+P(b(4,4));
p_block_sec = P(b(4,4))+P(b(3,5))+P(b(2,6))+P(b(1,7));

Nin_pri = a1*(1-p_block_pri);
Ndrop_pri = a2*(P(b(7,1))+P(b(6,2))+P(b(5,3)));
p_drop_pri = Ndrop_pri / Nin_pri;

Nin_sec = a2*(1-p_block_sec);
Ndrop_sec = a1*(P(b(1,7))+P(b(2,6))+P(b(3,5)));
p_drop_sec = Ndrop_sec / Nin_sec;

throughput = a2*(1-p_drop_sec)*(1-p_block_sec)+a1*(1-p_drop_pri)*(1-p_block_pri);




