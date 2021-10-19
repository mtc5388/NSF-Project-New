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

%% Interpolate 10 points per center row line
center_points = []
for r = 1:height(center_line);
    points = gcwaypts(center_line(r,1),center_line(r,2),center_line(r,3),center_line(r,4), 10);
    center_points = vertcat(center_points, points);
    
end 
    
%% Create Plot Using Local Euclidean Coordinate System

wgs84 = wgs84Ellipsoid;
alt = 1217; %[ft]
origin = [T(1,3),T(1,4), alt]; % Origin at Southern end of Row B


[xEast,yNorth,zUp] = geodetic2enu(T(:,[1 3]), T(:,[2 4]), alt, origin(1), origin(2), origin(3), wgs84);
[xCenter,yCenter,zUp] = geodetic2enu(center_line(1:18,[1 3]), center_line(1:18,[2 4]), alt, origin(1), origin(2), origin(3), wgs84);
[xCenterPoints,yCenterPoints,zUp] = geodetic2enu(center_points(:,1), center_points(:,2), alt, origin(1), origin(2), origin(3), wgs84);

% Creates points between each row to draw the center path lines when
% plotting
xCenterPath = [xCenter(:,1) xCenter(:,2)];
yCenterPath = [yCenter(:,1) yCenter(:,2)];

plot(xEast,yNorth)
hold on;
plot(xCenter,yCenter)
hold on;
plot(xCenterPath',yCenterPath');
hold on;
plot(xCenterPoints, yCenterPoints, 'o');


%% Determine Closest Center Row Coordinate to Fake Temp Value
% Upload fake GPS location of a critical temperature region
fake_lat = 40.708781;
fake_lon = -77.953667;

% Find closest lat/lon within UGV center line path
[min_dist_lat, lat_idx]  = min(abs(center_points(:,1) - fake_lat));
closest_lat = center_points(lat_idx,1);
[min_dist_lon, lon_idx]  = min(abs(center_points(:,2) - fake_lon));
closest_lon = center_points(lon_idx,2);


%% Cooling Rate Logic




