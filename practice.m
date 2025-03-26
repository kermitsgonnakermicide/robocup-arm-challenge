%%Trial
%gripperTranslation = [-0.42 0.75 0.125]; 
drop_location = [-0.42 0.75 0.15];
pick_location = [-0.42 0.75 0.125];
%gripperTranslation = drop_location; 
%gripperTranslation = pick_location; 
gripperTranslation = [0.23 0.342 0.08]; %[Z = (-ve)left right, Y = front back ; X = height from the table]
%gripperTranslation = [0 0.3 0.5];
gripperRotation = [-pi -pi 0]; %  [Z Y X]radian [ Z=on the side y=further away from the arm X=hieght of the table]

tform = eul2tform(gripperRotation); tform(1:3,4) = gripperTranslation'; % set translation in homogeneous transform
[configSoln, solnInfo] =ik('tool0',tform,ikWeights,initialIKGuess);
trajGoal = packTrajGoal(configSoln,trajGoal); sendGoal(trajAct,trajGoal); 

%camera_image = [0 0.3 0.4]