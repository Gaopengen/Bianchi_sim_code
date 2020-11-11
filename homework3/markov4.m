clear all
%三个信道，到达率λ1，服务率μ1
c1=3;c2=3;
d1=0.4;d2=0.3;
i=1;
j=1;
block_pri=[];
block_sec=[];
thrghput=[];
drop_sec=[];
drop_pri=[];
 for a1=0.0001:0.1:5
     for a2=0.0001:0.1:5
         [p_block_pri,p_block_sec,throughput,p_drop_pri,p_drop_sec]=MT4(c1,c2,a1,a2,d1,d2);
         block_pri(i,j)=p_block_pri;
         block_sec(i,j)=p_block_sec;
         thrghput(i,j)=throughput;
         drop_sec(i,j)=p_drop_sec;
         drop_pri(i,j)=p_drop_pri;
         j=j+1;
     end
end
a1=0000000.0001:0.1:000005;
a2=0000000.0001:0.1:000005;
[A1,A2]=meshgrid(a1,a2);

figure(1)
mesh( A1,A2,reshape(thrghput,size(A1)));
grid on;
hold on;
xlabel('Arrival Rate of 系统1 Users');
ylabel('Arrival Rate of 系统2 Users');
zlabel('Throughput of Users');

figure(2)
mesh( A1,A2,reshape(block_pri,size(A1)));
grid on;
hold on;
xlabel('Arrival Rate of  系统1 Users');
ylabel('Arrival Rate of  系统2 Users');
zlabel('Blocking Probability of 系统1 Users');

figure(3)
mesh( A1,A2,reshape(block_sec,size(A1)));
grid on;
hold on;
xlabel('Arrival Rate of 系统1 Users');
ylabel('Arrival Rate of 系统2 Users');
zlabel('Blocking Probability of 系统2 Users');

figure(4)
mesh( A1,A2,reshape(drop_pri,size(A1)));
grid on;
hold on;
xlabel('Arrival Rate of 系统1 Users');
ylabel('Arrival Rate of 系统2 Users');
zlabel('Drop Probability of 系统1 Users');

figure(5)
mesh( A1,A2,reshape(drop_sec,size(A1)));
grid on;
hold on;
xlabel('Arrival Rate of 系统1 Users');
ylabel('Arrival Rate of 系统2 Users');
zlabel('Drop Probability of 系统2 Users');
