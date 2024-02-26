%三边测量的定位算法
%dA,dB,dC为A,B,C到未知节点(假定坐标[x,y]未知)的模拟测量距离
function [P] = Triangle5(A,B,C,m,n)
    %A,B,C为三个选定的信标节点,节点坐标已知
 %定义未知坐标m,n为符号变量
    dA=sqrt((m-A(1))^2+(n-A(2))^2);
    dB=sqrt((m-B(1))^2+(n-B(2))^2);
    dC=sqrt((m-C(1))^2+(n-C(2))^2);
   syms x y;
    %距离方程,以信标节点为圆心,信标节点到未知节点的测量距离为半径作三个圆
    f1 = (A(1)-x)^2+(A(2)-y)^2-dA^2;
    f2 = (B(1)-x)^2+(B(2)-y)^2-dB^2;
    f3 = (C(1)-x)^2+(C(2)-y)^2-dC^2;
    
    %任两个方程联立,求任两圆交点
    s1 = solve(f1,f2); %求A,B两圆的交点
    s2 = solve(f2,f3); %求B,C两圆的交点
    s3 = solve(f1,f3); %求A,C两圆的交点
    
    %将结果(符号变量)转换为双精度数值
    x1 = double(s1.x);
    y1 = double(s1.y);
    x2 = double(s2.x);
    y2 = double(s2.y);
    x3 = double(s3.x);
    y3 = double(s3.y);
    
    %选择内侧的三个交点
    %两圆相交于两点,距第三个圆心近的为选定交点Pab,Pbc,Pac
    d1(1) = sqrt(((m-x1(1))^2+(n-y1(1))^2));
    d1(2) = sqrt(((m-x1(2))^2+(n-y1(2))^2));
    if d1(1) <= d1(2)
        Pad(1) = x1(1);
        Pad(2) = y1(1);
    else
        Pad(1) = x1(2);
        Pad(2) = y1(2);
    end
    d2(1) = sqrt(((m-x2(1))^2+(n-y2(1))^2));
    d2(2) = sqrt(((m-x2(2))^2+(n-y2(2))^2));
    if d2(1) <= d2(2)
        Pbd(1) = x2(1);
        Pbd(2) = y2(1);
    else
        Pbd(1) = x2(2);
        Pbd(2) = y2(2);
    end
    d3(1) = sqrt(((m-x3(1))^2+(n-y3(1))^2));
    d3(2) = sqrt(((m-x3(2))^2+(n-y3(2))^2));
    if d3(1) <= d3(2)
        Pcd(1) = x3(1);
        Pcd(2) = y3(1);
    else
        Pcd(1) = x3(2);
        Pcd(2) = y3(2);
    end
    
    %Pab
    %Pbc
    %Pac
     
    %求三个圆内侧三个交点Pab,Pbc,Pac的质心,即为未知节点P,完成定位
    P(1) = (Pad(1)+Pbd(1)+Pcd(1))/3;
    P(2) = (Pad(2)+Pbd(2)+Pcd(2))/3;

%         reader_x=reader_x(reader_x~=reader_x(k(i,:)));%找出最大距离的点，并去除
   
end