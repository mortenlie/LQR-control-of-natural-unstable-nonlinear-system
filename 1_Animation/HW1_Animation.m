for th1 = 0:pi/100:4*pi
    x = [4*th1;-10*th1;12*th1];
    draw_disclink(x);
    pause(0.01);
    clf;
end