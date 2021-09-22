%{
Maxfield Canto, mtc5388
7/2/21
Description: MATLAB script to import and interpret the GPS data for Block
A1. Block A1 consists of 19 rows of apple trees. This script performs a 
transform of plot row locations from geographic coordinates to regional 
coordinates.
%}

%% Load GPS Data from Excel Document

T = table2array(readtable('200305 rows.xlsx', 'Range', 'C33:F51'));


%% GPS Data Structure Definition for Block A1
    %{
        GPS data is from "GPS_data.xlsx"
    %}
% Row B
B.lat_N = 40.7089043;
B.lon_N = -77.9541298;
B.lat_S = 40.708362;
B.lon_S = -77.9537402;
% Row C
C.lat_N = 40.7089112;
C.lon_N = -77.9540956;
C.lat_S = 40.7083846;
C.lon_S = -77.9537174;
% Row D
D.lat_N = 40.7089249;
D.lon_N = -77.9540587;
D.lat_S = 40.7084049;
D.lon_S = -77.9536815;
% Row EE
EE.lat_N = 40.7089653;
EE.lon_N = -77.9539678;
EE.lat_S = 40.7084377;
EE.lon_S = -77.9535823;
% Row F
F.lat_N = 40.708976;
F.lon_N = -77.9539357;
F.lat_S = 40.708454;
F.lon_S = -77.9535558;
% Row FF
FF.lat_N = 40.7089905;
FF.lon_N = -77.9539051;
FF.lat_S = 40.7084621;
EE.lon_S = -77.9535253;
% Row G
G.lat_N = 40.7090014;
G.lon_N = -77.953879;
G.lat_S = 40.7084776;
G.lon_S = -77.9534981;
% Row GG
GG.lat_N = 40.7090116;
GG.lon_N = -77.9538565;
GG.lat_S = 40.708489;
GG.lon_S = -77.9534706;
% Row H
H.lat_N = 40.7090256;
H.lon_N = -77.9538253;
H.lat_S = 40.7085015;
H.lon_S = -77.9534418;
% Row HH
HH.lat_N = 40.70904;
HH.lon_N = -77.9537925;
HH.lat_S = 40.708517;
HH.lon_S = -77.9534106;
% Row I			
I.lat_N = 40.709051;
I.lon_N = -77.953758;
I.lat_S = 40.7085297;
I.lon_S = -77.9533794;
% Row II
II.lat_N = 40.7090677;
II.lon_N = -77.9537295;
II.lat_S = 40.708546;
II.lon_S = -77.9533462;
% Row J
J.lat_N = 40.7090858;
J.lon_N = -77.9536886;
J.lat_S = 40.708564;
J.lon_S = -77.9533053;
% Row K
K.lat_N = 40.7091013;
K.lon_N = -77.9536483;
K.lat_S = 40.7085795;
K.lon_S = -77.9532641;
% Row L 
L.lat_N = 40.7091127;			
L.lon_N = -77.953601;
L.lat_S = 40.708593;
L.lon_S = -77.9532249;
% Row LL
LL.lat_N = 40.7091303;			
LL.lon_N = -77.9535645;
LL.lat_S = 40.7086059;
LL.lon_S = -77.953187;
% Row M
M.lat_N = 40.7091303;			
M.lon_N = -77.9535645;
M.lat_S = 40.708623;
M.lon_S = -77.9531518;
% Row N
N.lat_N = 40.7091646;			
N.lon_N = -77.9534917;
N.lat_S = 40.7086377;
N.lon_S = -77.9531089;
% Row O
O.lat_N = 40.7091793;			
O.lon_N = -77.9534498;
O.lat_S = 40.7086497;
O.lon_S = -77.9530693;



%% Row Center Line

center_line = zeros(18,4);
% constants
d2r = pi / 180.0;
% 1 deg lat = 364813 feet, 1 deg lon = cos(lat)*d2f_lat, MATLAB spherical Earth model
d2f_lat = 364813.0;  % units [ft/deg lat]
% overshoot at end of rows to handle bracing posts
offset = 15;  % units [ft]

a = 0;
for i = 1:height(T)-1
    a = a + 1;

    % Centerline between rows
    % South end waypoint
    latS = ( T(i,3) + T(i+1,3) )/ 2;
    lonS = ( T(i,4) + T(i+1,4) )/ 2;
    % North end waypoint
    latN = ( T(i,1) + T(i+1,1) )/ 2;
    lonN = ( T(i,2) + T(i+1,2) )/ 2;
    
    % path - x East, y North (delta lat and lon, find path length)
    del_lat = latN - latS;
    del_lon = lonN - lonS;

    d2f_lon = cos( latS*d2r ) * d2f_lat;  % units [ft/deg lon]
    del_x = del_lon * d2f_lon;            % units [ft]
    del_y = del_lat * d2f_lat;
    
    distance = sqrt( del_x*del_x + del_y*del_y );  % units [ft]       
    theta = atan2( del_y, del_x );                 % units [rad] - positive CCW from East - -pi<theta<=pi
    theta_deg = theta / d2r;                       % units [deg]
    heading = mod( (90 - theta_deg + 360), 360 );  % units [deg} - postivie CW from North
    
    % path in feet relative to first waypoint
    d1 = -offset;             % units [ft]
    dx1 = d1 * cos( theta );
    dy1 = d1 * sin( theta );

    d2 = offset;   % units [ft]
    dx2 = d2 * cos( theta );
    dy2 = d2 * sin( theta );

    % waypoints with overshoot - convert ft to deg relative to first waypoint
    center_line(i,3) = latS + dy1/d2f_lat;  % units [deg lat]
    center_line(i,4) = lonS + dx1/d2f_lon;  % units [deg lon]

    center_line(i,1) = latN + dy2/d2f_lat;
    center_line(i,2) = lonN + dx2/d2f_lon;
    
    
end

    
%% Determine Row location of Fake GPS Point

wgs84 = wgs84Ellipsoid;
alt = 1217; %[ft]
origin = [T(1,3),T(1,4), alt]; % Origin at Southern end of Row B


[xEast,yNorth,zUp] = geodetic2enu(T(:,[1 3]), T(:,[2 4]), alt, origin(1), origin(2), origin(3), wgs84);
[xCenter,yCenter,zUp] = geodetic2enu(center_line(1:18,[1 3]), center_line(1:18,[2 4]), alt, origin(1), origin(2), origin(3), wgs84);

% Creates points between each row to draw the center path lines when
% plotting
xCenterPath = [xCenter(:,1) xCenter(:,2)];
yCenterPath = [yCenter(:,1) yCenter(:,2)];

plot(xEast,yNorth)
hold on;
plot(xCenter,yCenter)
hold on;
plot(xCenterPath',yCenterPath');


    

%{
fake_lat = 40.708781;
fake_lon = -77.953667;

[val,idx] = min(abs(center_line
%}

%% Determine Location of UAS in Block A1
%{
    This section compares the received GPS location of the UAS from
    simulink to the A1 block structure coordinates to determine what row
    the vehicle is currently above.
%}