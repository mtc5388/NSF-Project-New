%{
Maxfield Canto, mtc5388
7/2/21
Description: MATLAB script to import and interpret the GPS data for Block
A1. Block A1 consists of 19 rows of apple trees. This script performs a 
transform of plot row locations from geographic coordinates to regional 
coordinates.
%}

%% GPS Data Structure Definition for Block A1
    %{
        GPS data is from "GPS_data.xlsx"
    %}

A1.name = 'Block A1';
A1.columnsyntax = {'N lat', 'N lon', 'S lat', 'S lon'};
A1.B = [40.7089043	-77.9541298	40.708362	-77.9537402];
A1.C = [40.7089112	-77.9540956	40.7083846	-77.9537174];
A1.D = [40.7089249	-77.9540587	40.7084049	-77.9536815];
A1.EE = [40.7089653	-77.9539678	40.7084377	-77.9535823];
A1.F = [40.708976	-77.9539357	40.708454	-77.9535558];
A1.FF = [40.7089905	-77.9539051	40.7084621	-77.9535253];
A1.G = [40.7090014	-77.953879	40.7084776	-77.9534981];
A1.GG = [40.7090116	-77.9538565	40.708489	-77.9534706];
A1.H = [40.7090256	-77.9538253	40.7085015	-77.9534418];
A1.HH = [40.70904	-77.9537925	40.708517	-77.9534106];
A1.I = [40.709051	-77.953758	40.7085297	-77.9533794];
A1.II = [40.7090677	-77.9537295	40.708546	-77.9533462];
A1.J = [40.7090858	-77.9536886	40.708564	-77.9533053];
A1.K = [40.7091013	-77.9536483	40.7085795	-77.9532641];
A1.L = [40.7091127	-77.953601	40.708593	-77.9532249];
A1.LL = [40.7091303	-77.9535645	40.7086059	-77.953187];
A1.M = [40.7091303	-77.9535645	40.708623	-77.9531518];
A1.N = [40.7091646	-77.9534917	40.7086377	-77.9531089];
A1.O = [40.7091793	-77.9534498	40.7086497	-77.9530693];


disp(A1) % Display the block A1 structure




%% Determine Location of UAS in Block A1
%{
    This section compares the received GPS location of the UAS from
    simulink to the A1 block structure coordinates to determine what row
    the vehicle is currently above.
%}