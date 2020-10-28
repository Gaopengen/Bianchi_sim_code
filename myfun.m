function output=myfun(input)

p=input(1);
tau=input(2);

global Wmin;
global m;
global n;

sum=0;

for i=0:1:m-1;
    sum=(2*p)^m+sum;
end

output(1)=1-(1-tau)^(n-1)-p;
output(2)=(2) / (1+Wmin+p*Wmin*sum) - tau;