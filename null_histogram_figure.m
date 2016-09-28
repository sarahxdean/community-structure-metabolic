function null_histogram_figure(null_values, test_value, x_axis_label, title_label)
height = length(null_values) / 5;
histfit(null_values,[],'normal')
disp(test_value)
xh = [test_value test_value]; yh = [0 height];
hold on; plot(xh,yh,'LineWidth',2)
xlabel(x_axis_label)
title(title_label)
hold off

