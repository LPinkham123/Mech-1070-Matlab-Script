close all
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                         %
% CNC_testEmulator.m                                                      % 
%                                                                         %
% Just a test driver for the CNC emulator                                 %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% s = serial('COM3')
s = CNC_Emulator;
set(s, 'EnableTrace');
fopen(s);

pause(2);

% Cube center coordinates
cube_coords = [
    -1.545, -0.75;     % Top Row - Third
    1.545, -0.75;      % Top Row - Second
    4.635, -0.75;      % Top Row - Right most
    %-4.635, -0.75;     % Top Row - Left most
    4.635, -3.5;       % Middle Row - Right
    4.635, -6.75;       % Bottom Row - Right
];

% Cube destination coordinates
dest_coords = [
    -2.0, -3.0;
    -1.0, -3.0;
    0.0, -3.0;
    2, -3; 
    2, -3;
];

fprintf(s,'G17 G20 G90 G94 G54');

% Loop through each cube coordinate and write to emulator
for i = 1:size(cube_coords, 1)
    % Path for first four cubes on base plate
    if(i <= 4)
        fprintf(s, 'G1 z1.5 f100'); % Up to miss cubes 
        pause(1);
        fprintf(s, ['G1 x', num2str(cube_coords(i, 2)), ' y', num2str(cube_coords(i, 1)), ' f100']); % Goes to cube
        pause(1);
        fprintf(s, 'G1 z0 f100'); % Drops to cube for pick up
        pause(1); % Pauses until Keypress -- Servo Lift
        fprintf(s, 'G1 z1.5 f100'); % Lifts to move cube
        pause(1);
        fprintf(s, ['G1 x', num2str(dest_coords(i, 2)), ' y', num2str(dest_coords(i, 1)), ' f100']); % Goes to cube destination
        pause(1);
        fprintf(s, 'G1 z0 f100'); % Drops to cube
        pause(1); % Pauses until Keypress -- Servo Dropf
    end 

    % Path for stacked cube 
    if(i == 5)
        fprintf(s, 'G1 z1.5 f100'); % Up to miss cubes
        pause(1);
        fprintf(s, ['G1 x', num2str(cube_coords(i, 2)), ' y', num2str(cube_coords(i, 1)), ' f100']); % Goes to last cube
        pause(1); 
        fprintf(s, 'G1 z0.5 f100'); % Drops to last cube for pick up
        pause(1); % Pauses until Keypress -- Servo Lift
        fprintf(s, 'G1 z2.5 f100'); % Lifts to move cube
        pause(1);
        fprintf(s, ['G1 x', num2str(dest_coords(i, 2)), ' y', num2str(dest_coords(i, 1)), ' f100']); % Goes to last cube destination
        pause(1);
        fprintf(s, 'G1 z1 f100'); % Down to drop stacked cube
        pause(1); % Pauses until Keypress -- Servo Drop
    end

    pause(1);
end

fprintf(s, 'G1 z3.0 f100');
pause(1);
fprintf(s, 'G1 x0.0, y0.0 f100');
pause(1);

fclose(s);