% Initial code codifying equation (39) of Michalczyk

% structure definitions
possible_end_conditions = {'open','closed','closed_ground'};

% Spring geometry variables
% degrees
gamma = 10;

end_condition = possible_end_conditions{1};

% inner diameter, m
Di = 0.05;

% wire diameter, m
dw = 0.001;
D  = Di + dw;

