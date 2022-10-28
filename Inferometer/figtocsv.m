fig = openfig('vacumtohelium1.fig');
axObjs = fig.Children;
dataObjs = axObjs.Children;
x = dataObjs(1).XData;
y = dataObjs(1).YData;

writematrix(x,'vacumtohelium1.csv');
writematrix(y,'vacumtohelium1.csv','WriteMode','append');