name = 'err4';
svgname = strcat(name,'.svg');
w = 30;
h = 15;
ft_size = 12;

plotHandle1 = findobj(gca, 'type', 'line');


x=get(plotHandle1,'Xdata');
y=get(plotHandle1,'Ydata');

figure

for i = 1:6
xi = x(i);
xi = cell2mat(xi);
yi = y(i);
yi = cell2mat(yi);

line_fewer_markers(xi,yi, 10, 'o');
end

plotHandle = findobj(gca, 'type', 'line');
%legend
set(plotHandle(1), 'Color', [1,0.6,0.4], 'Marker', '*');
set(plotHandle(4), 'Color', [0.243,0.471,0.643], 'Marker', 'd');
set(plotHandle(7), 'Color', [0.651,0.216,0.651], 'Marker', 's');
set(plotHandle(10), 'Color', [0.565,0.89,0.298], 'Marker', 'x');
set(plotHandle(13), 'Color', [0,0,0], 'Marker', '+');
set(plotHandle(16), 'Color', [0.894,0.298,0.478], 'Marker', 'o');

%markers
set(plotHandle(17), 'Color', [1,0.6,0.4], 'Marker', 'o');
set(plotHandle(14), 'Color', [0.243,0.471,0.643], 'Marker', '+');
set(plotHandle(11), 'Color', [0.651,0.216,0.651], 'Marker', 'x');
set(plotHandle(8), 'Color', [0.565,0.89,0.298], 'Marker', 's');
set(plotHandle(5), 'Color', [0,0,0], 'Marker', 'd');
set(plotHandle(2), 'Color', [0.894,0.298,0.478], 'Marker', '*');

%lines
set(plotHandle(18), 'Color', [1,0.6,0.4]);
set(plotHandle(15), 'Color', [0.243,0.471,0.643]);
set(plotHandle(12), 'Color', [0.651,0.216,0.651]);
set(plotHandle(9), 'Color', [0.565,0.89,0.298]);
set(plotHandle(6), 'Color', [0,0,0]);
set(plotHandle(3), 'Color', [0.894,0.298,0.478]);


legend_names = [{'MEKF Euler'}, {'MEKF Choi'}, {'MEKF Mobius'}, {'GAME Euler'}, {'GAME modified Choi'}, {'GAME modified Mobius'}];

xlabel('Time (seconds)', 'FontSize', ft_size);
ylabel('Rolling integral of error angle (radians)', 'FontSize', ft_size);
legend(legend_names, 'Location', 'northeast');

set(gca, 'FontSize', ft_size);

set(gcf, 'Paperposition', [0 0 w h]);
set(gcf, 'PaperSize', [w h]);
saveas(gcf, name, 'pdf');
plot2svg(svgname);


