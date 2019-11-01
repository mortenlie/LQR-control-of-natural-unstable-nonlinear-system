function [ ] = rect( base,ee,W,color )
th = atan((ee(2)-base(2))/(ee(1)-base(1)));
toCornerR = [-W*sin(th);W*cos(th)];
toCornerL = [W*sin(th);-W*cos(th)];
c1 = base + toCornerR;
c2 = base + toCornerL;
c3 = ee + toCornerL;
c4 = ee + toCornerR;
patch([c1(1);c2(1);c3(1);c4(1)], [c1(2);c2(2);c3(2);c4(2)], color);

end

