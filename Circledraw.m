function Image1 = Circledraw( x,y,r,color)
th = 0:pi/50:2*pi;
xunit = r*22 * cos(th) + x*22;
yunit = r*22* sin(th) +(38*22+11-y*22);
plot(xunit, yunit,'Color',color, 'LineWidth', 3);

end

