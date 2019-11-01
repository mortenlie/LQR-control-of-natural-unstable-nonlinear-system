function [] = circle( xpos,ypos,r,th,color )
t = linspace(0, 2*pi);
x = xpos + r*cos(t+th);
y = ypos + r*sin(t+th);
figure(1)
patch(x, y, color)

end

