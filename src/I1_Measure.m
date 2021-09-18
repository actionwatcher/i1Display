function out = I1_Measure(mode)

if ~exist('mode') || isempty(mode)
    mode = 0; % XYZ
end
eNoError = 0; %                               /* no error */

if calllib('EyeOne','I1_TriggerMeasurement') ~= eNoError
    warning('Failed to trigger the device');
    out = -11;
    return;
end;

switch mode
    case 0 % XYZ
        XYZ = ones(3,1, 'single');
        pXYZ = libpointer('singlePtr', XYZ);


        if calllib('EyeOne','I1_GetTriStimulus', pXYZ, 0) ~= eNoError
            warning('Failed to trigger the device');
            XYZ(1) = -11;
            return;
        end;

        out = double(pXYZ.value);
    case 1 %spectrum
        Val = ones(36,1, 'single');
        pVal = libpointer('singlePtr', Val);


        if calllib('EyeOne','I1_GetSpectrum', pVal, 0) ~= eNoError
            warning('Failed to trigger the device');
            out = -11;
            return;
        end;
        out = double(pVal.value);
    otherwise
        error('Unknown measurement mode');
end

