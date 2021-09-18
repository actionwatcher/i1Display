function bRes = I1_Calibrate()

%EyeOne defs


eNoError = 0; %                               /* no error */


%
bRes = 1;

disp('Place the device on calibration platform and press enter');
pause
if calllib('EyeOne','I1_Calibrate') ~= eNoError
    warning('Calibration failed');
    bRes = 0;
    return;
end;

