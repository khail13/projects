%Element Parameters
a=1.7;
c=1.27;
m1=320;
m2=320;
m3=2500;
j3=6000;
k1 = 500000;
k2 = 500000;
k3=200000;
k4=200000;
b1 = 15000;
b2 = 15000;

%State-Space Matrices, obtained analytically
A=[0 0 0 0 1 0 0 0;
   0 0 0 0 0 1 0 0;
   0 0 0 0 0 0 1 0;
   0 0 0 0 0 0 0 1;
 -(k1+k3)/m1 0 k1/m1 -k1*a/m1 -b1/m1 0 b1/m1 -b1*a/m1;
 0 -(k2+k4)/m2 k2/m2 k2*c/m2 0 -b2/m2 b2/m2 b2*c/m2;
 k1/m3 k2/m3 -(k1+k2)/m3 (k1*a-k2*c)/m3 b1/m3 b2/m3 -(b1+b2)/m3 (b1*a-b2*c)/m3;
 -k1*a/j3 k2*c/j3 (k1*a-k2*c)/j3 -(k1*a^2+k2*c^2)/j3 -b1*a/j3 b2*c/j3 (b1*a-b2*c)/j3 -(b1*a^2+b2*c^2)/j3];

B=[0 0 0 0;
 0 0 0 0;
 0 0 0 0;
 0 0 0 0;
 -1/m1 0 k3/m1 0;
 0 -1/m2 0 k4/m2;
 1/m3 1/m3 0 0;
 -a/m3 c/m3 0 0];

C=[0 0 0 0 0 0 0 0];

D=[0 0 0 0;];

A = [[A, [0 0 0 0 0 0 0 0]', [0 0 0 0 0 0 0 0]', [0 0 0 0 0 0 0 0]', [0 0 0 0 0 0 0 0]']; 
      [0 0 0 0 -1 0 1 0 0 0 0 0]; [0 0 0 0 0 -1 1 0 0 0 0 0];[-1 0 1 0 0 0 0 0 0 0 0 0]; [0 -1 1 0 0 0 0 0 0 0 0 0]];
B = [B; [0 0 0 0]; [0 0 0 0]; [0 0 0 0]; [0 0 0 0]];
C = [C 1 0 0 0];

sys = ss(A,B,C,D); %Open Loop System

%PID Coefficient Matrix
K = zeros(2, 12); 
K(1,11) = 1e2; %int(y3-y1)
K(2,12) = 1e2; %int(y3-y2)
K(1,9) = 3e2;  %y3-y1
K(2,10) = 3e2; %y3-y2
K(1,5) = 1e4;  %y1'
K(2,6) = 1e4; %y2'
K(1:2,3) = 3.5e2; %y3'

sys_cl = ss(A-B(:,1:2)*K,B,C,D); %Closed Loop System

t = 0:0.01:20;

w1 = 0.1*heaviside(t-1); %Front Wheel Road Input
w2 = 0.1*heaviside(t-1.2); %Rear Wheel Road Input

%Input Matrix
w = zeros(4, length(t));
w(3,:) = w1;
w(4,:) = w2;

%Simulate Both Systems
out = lsim(sys, w, t);
out_cl = lsim(sys_cl, w, t);

%Plots
subplot(2,1,1)
plot(t,out)
title('Open-Loop Response to a 0.1-m Step')
axis([0 20 -0.1 0.1])
xlabel("Time (s)")
ylabel("Linear Displacement (m)")

subplot(2,1,2)
plot(t,out_cl)
title('Closed-Loop Response to a 0.1-m Step')
axis([0 20 -0.1 0.1])
xlabel("Time (s)")
ylabel("Linear Displacement (m)")
