%% Example of using ICT class to interface with KUKA iiwa

% First start the "ICTServer" on the smartPad
% Then run the following script in Matlab

% Note you have 60 seconds to connect to ICTServer after starting the
% application on the smartPad.


% Copyright: Mohammad SAFEEA, 02-Oct-2019

close all;clear;clc;
warning('off')
%% Create the robot object
ip='172.31.1.147'; % The IP of the controller
arg1=ICT.LBR7R800; % choose the robot iiwa7R800 or iiwa14R820
arg2=ICT.Medien_Flansch_elektrisch; % choose the type of flange
Tef_flange=eye(4); % Transform matrix of EEF with respect to flange.
Tef_flange(1,4)=0; % X-coordinate of TCP (meter)
Tef_flange(2,4)=0; % Y-coordinate of TCP (meter)
Tef_flange(3,4)=300/1000; % Z-coordinate of TCP (meter)
toolData=[8,0,0,0.05]; % mass of tool is 1 kg, COMx=0 (m), COMy=0 (m),COMz=0.05 (m)
iiwa=ICT(ip,arg1,arg2,Tef_flange,toolData); % create the object

%% Start a connection with the server
flag=iiwa.net_establishConnection();
if flag==0
    return;
end

sendMotorCommand('RESET ERROR');
sendMotorCommand('MOTOR CLOSE');
sendMotorCommand('PROCESS BEGIN');
disp('------------')
disp('Make sure no objects are around the robot, for the robot will move')
input('Press enter to continue\n')
disp('------------')  
%% move to initial position
jPos_init={0,pi*20/180,0,-pi*80/180,0,pi*75/180,0}; % initial confuguration
relVel=0.4; % relative velocity
pause(1);
iiwa.movePTPJointSpace(jPos_init, relVel); % point to point motion in joint space
jPos_init={0,pi*25/180,0,-pi*95/180,0,pi*79/180,pi*90/180}; % REACH
relVel=0.4; % relative velocity
iiwa.movePTPJointSpace(jPos_init, relVel); % point to point motion in joint space
Posr=iiwa.getEEFPos();
disp(Posr);
jPos_init={pi*0.06/180,pi*43.31/180,0,-pi*84.01/180,0,pi*70.94/180,pi*90/180}; % APPROACH
relVel=0.25; % relative velocity
iiwa.movePTPJointSpace(jPos_init, relVel); % point to point motion in joint space
Posa=iiwa.getEEFPos();
disp(Posa);
sendMotorCommand('MOTOR OPEN');
pause(1);
aVel=50;
Pos=iiwa.getEEFPos();
disp(Pos);
Pos{1}=Pos{1}+100;
disp(Pos);
iiwa.movePTPLineEEF(Pos, aVel);
sendMotorCommand('MOTOR CLOSE');
sendMotorCommand('BAND CUTTING');
Vel=20;
Pos{1}=Pos{1}+65;
iiwa.movePTPLineEEF(Pos, Vel);
sendMotorCommand('MOTOR FORWARD');
i = 1;
while i < 5
disp('Before Update: Posr{2} = ');
disp(Posr{2});
Posr{2} = Posr{2} + 15;
disp('After Update: Posr{2} = ');
disp(Posr{2});
iiwa.movePTPLineEEF(Posr, aVel);
pause(1);
disp('Before Update: Posa{2} = ');
disp(Posa{2});
Posa{2} = Posa{2} + 15;
disp('After Update: Posa{2} = ');
disp(Posa{2});
iiwa.movePTPLineEEF(Posa, aVel);
pause(1);
sendMotorCommand('MOTOR OPEN');
pause(1);
Pos=iiwa.getEEFPos();
disp(Pos);
Pos{1}=Pos{1}+100;
disp(Pos);
iiwa.movePTPLineEEF(Pos, aVel);
sendMotorCommand('MOTOR CLOSE');
sendMotorCommand('BAND CUTTING');
Vel=20;
Pos{1}=Pos{1}+65;
iiwa.movePTPLineEEF(Pos, Vel);
sendMotorCommand('MOTOR FORWARD');
i = i+1;
end
jPos_init={0,pi*30/180,0,-pi*65/180,0,pi*80/180,pi*90/180}; % initial confuguration
relVel=0.15; % relative velocity
iiwa.movePTPJointSpace(jPos_init, relVel); % point to point motion in joint space
%% turn off the server
iiwa.net_turnOffServer(  );



