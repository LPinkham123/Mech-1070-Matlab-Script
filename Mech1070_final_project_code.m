close all

% s = CNC_Emulator;
% set(s, 'EnableTrace');

s = serial('COM7')
set(s,'BaudRate',115200)

fopen(s);

 

pause(2);

% Cube center coordinates
cube_coords = [
    1.545, -0.22;     % Top Row - Third
    -1.545, -0.22;      % Top Row - Second
    -4.635, -0.22;      % Top Row - Right most
    %-4.635, -0.75;     % Top Row - Left most
    -4.635, -3.48;       % Middle Row - Right
    -4.635, -6.73;       % Bottom Row - Right
];


% Cube destination coordinates
dest_coords = [
    -2.0, -3.0; % Line 1
    -1.0, -3.0; % Line 2
    0.0, -3.0;  % Line 3
    2, -3;      % Stack 1
    2, -3;      % Stack 2
];

fprintf(s,'G17 G20 G90 G94 G54');

% Loop through each cube coordinate and write to emulator
for i = 1:size(cube_coords, 1)
    % Path for first four cubes on base plate
    if(i <= 4)
        fprintf(s, 'G1 z-1.5 f10'); % Up to miss cubes 
        pause(6);
        fprintf(s, ['G1 x', num2str(cube_coords(i, 2)), ' y', num2str(cube_coords(i, 1)), ' f10']); % Goes to cube
        pause(6);
        fprintf(s, 'G1 z-0 f10'); % Drops to cube for pick up
        pause(); % Pauses until Keypress -- Servo Lift
        fprintf(s, 'G1 z-1.5 f10'); % Lifts to move cube
        pause(6);
        fprintf(s, ['G1 x', num2str(dest_coords(i, 2)), ' y', num2str(dest_coords(i, 1)), ' f10']); % Goes to cube destination
        pause(6);
        fprintf(s, 'G1 z-0 f10'); % Drops to cube
        pause(); % Pauses until Keypress -- Servo Dropf
    end 

    % Path for stacked cube 
    if(i == 5)
        fprintf(s, 'G1 z-1.5 f10'); % Up to miss cubes
        pause(6);
        fprintf(s, ['G1 x', num2str(cube_coords(i, 2)), ' y', num2str(cube_coords(i, 1)), ' f10']); % Goes to last cube
        pause(6); 
        fprintf(s, 'G1 z-0.5 f10'); % Drops to last cube for pick up
        pause(); % Pauses until Keypress -- Servo Lift
        fprintf(s, 'G1 z-2.5 f10'); % Lifts to move cube
        pause(6);
        fprintf(s, ['G1 x', num2str(dest_coords(i, 2)), ' y', num2str(dest_coords(i, 1)), ' f10']); % Goes to last cube destination
        pause(6);
        fprintf(s, 'G1 z-1 f10'); % Down to drop stacked cube
        pause(); % Pauses until Keypress -- Servo Drop
    end


    pause(6);
end

fprintf(s, 'G1 z-3.0 f10');
pause(6);
fprintf(s, 'G1 x0.0, y0.0 f10');
pause(6);

fclose(s);