function [  ] = draw_3linked_rod( x )
%Draws a three linked robot with angles th1, th2 and th3
%th1 is absolute angle, while th2 and th3 are relative angles


L1 = 1;
L2 = 1;
L3 = 1;
W = 0.05;

%Rod 1
base1 = [0;0]; %Base of rod
ee1 = base1 + [L1*cos(x(1));L2*sin(x(1))]; %End effector 1

%Rod 2
base2 = [ee1(1);ee1(2)];
ee2 = ee1 + [L2*cos(x(1)+x(2)); L2*sin(x(1)+x(2))];

%Rod 3
base3 = [ee2(1);ee2(2)];
ee3 = ee2 + [L3*cos(x(1)+x(2)+x(3)); L3*sin(x(1)+x(2)+x(3))];

%Draw the inverted pendulum
rect(base1,ee1,W,'r');
rect(base2,ee2,4/5*W,'k');
rect(base3,ee3,3/5*W,'b');
circle(ee1(1),ee1(2),2*W,0,'y');
circle(ee2(1),ee2(2),W,0,'y');
xlim([-L1-L2-L3, L1+L2+L3]);
ylim([-L1-L2-L3, L1+L2+L3]);
end

