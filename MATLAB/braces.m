% braces.m - overshoot lat-lon waypoints in orchard to handle bracing posts
% HJSIII. 21.09.08

clear

% constants
d2r = pi / 180.0;

% 1 deg lat = 364813 feet, 1 deg lon = cos(lat)*d2f_lat, MATLAB spherical Earth model
d2f_lat = 364813.0;  % units [ft/deg lat]

% overshoot at end of rows to handle bracing posts
offset = 15;  % units [ft]

% row I
latI_n = 40.709051;
lonI_n = -77.953758;
latI_s = 40.7085297;
lonI_s = -77.9533794;

% row II
latII_n = 40.7090677;
lonII_n = -77.9537295;
latII_s = 40.708546;
lonII_s = -77.9533462;

% centerline between row I and row II
lat1 = ( latI_s + latII_s ) / 2;  % first waypoint at south end
lon1 = ( lonI_s + lonII_s ) / 2;

lat2 = ( latI_n + latII_n ) / 2;  % second waypoint at north end
lon2 = ( lonI_n + lonII_n ) / 2;

% path - x East, y North (delta lat and lon, find path length)
del_lat = lat2 - lat1;
del_lon = lon2 - lon1;

d2f_lon = cos( lat1*d2r ) * d2f_lat;  % units [ft/deg lon]
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

d2 = distance + offset;   % units [ft]
dx2 = d2 * cos( theta );
dy2 = d2 * sin( theta );

% waypoints with overshoot - convert ft to deg relative to first waypoint
lat1_new = lat1 + dy1/d2f_lat;  % units [deg lat]
lon1_new = lon1 + dx1/d2f_lon;  % units [deg lon]

lat2_new = lat1 + dy2/d2f_lat;
lon2_new = lon1 + dx2/d2f_lon;

% bottom - braces