function [] = draw_disclink(x)
%Define constants
r = 1;
r_ee = 2/3;
L1 = 2;
L2 = 1;
W = 0.05;

%Disc
base1 = [0;0];
ee1 = base1 + [r_ee*cos(x(1));r_ee*sin(x(1))];

%Rod 1
base2 = ee1;
ee2 = base2 + [L1*cos(x(1)+x(2));L1*sin(x(1)+x(2))];

%Rod 2
base3 = ee2;
ee3 = base3 + [L2*cos(x(1)+x(2)+x(3));L2*sin(x(1)+x(2)+x(3))];

%Draw disc with rods
circle(base1(1),base1(2),r,x(1),'b');
rect(base2,ee2,W,'r');
rect(base3,ee3,W,'r');
circle(base1(1),base1(2),0.05,0,'k');
circle(ee1(1),ee1(2),0.1,0,'y');
circle(ee2(1),ee2(2),0.1,0,'y');
xlim([-r_ee-L1-L2, r_ee+L1+L2]);
ylim([-r_ee-L1-L2, r_ee+L1+L2]);
end

