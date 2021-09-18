function bRes = I1_Init()
%EyeOne defs

COLOR_SPACE_KEY = 'ColorSpaceDescription.Type';
COLOR_SPACE_CIEXYZ = 'CIEXYZ';
I1_VERSION                         ='Version';
I1_SERIAL_NUMBER                   ='SerialNumber';
I1_IS_CONNECTED                    ='Connection';
I1_IS_KEY_PRESSED                  ='IsKeyPressed';
I1_IS_RECOGNITION_ENABLED          ='Recognition';
I1_LAST_CALIBRATION_TIME           ='LastCalibrationTime';
I1_CALIBRATION_COUNT               ='LastCalibrationCounter';
I1_LAST_ERROR                      ='LastError';
I1_EXTENDED_ERROR_INFORMATION      ='ExtendedErrorInformation';
I1_NUMBER_OF_AVAILABLE_SAMPLES     ='AvailableSamples';
I1_AVAILABLE_MEASUREMENT_MODES     ='AvailableMeasurementModes';
I1_IS_BEEP_ENABLED                 ='Beep';
I1_LAST_AUTO_DENSITY_FILTER        ='LastAutoDensityFilter';
    
I1_PHYSICAL_FILTER                 ='PhysicalFilter'; %/*read only*/
I1_UNDEFINED_FILTER                ='0';    
I1_NO_FILTER                       ='1';
I1_UV_FILTER                       ='2';
I1_SCREEN_TYPE                     ='ScreenType';    %/*mandatory for i1-display*/
I1_LCD_SCREEN                      ='LCD';
I1_CRT_SCREEN                      ='CRT';

I1_PATCH_INTENSITY                 ='PatchIntensity'; %/*used with i1-display*/
I1_BLEAK                           ='Bleak';
I1_BRIGHT                          ='Bright';
I1_AUTO                            ='Auto';
    
I1_YES                             ='yes';
I1_NO                              ='no';

I1_DEVICE_TYPE                     ='DeviceType';
I1_EYEONE                          ='EyeOne';
I1_DISPLAY                         ='EyeOneDisplay';

I1_MEASUREMENT_MODE                ='MeasurementMode';
I1_SINGLE_EMISSION                 ='SingleEmission';
I1_SINGLE_REFLECTANCE              ='SingleReflectance';
I1_SINGLE_AMBIENT_LIGHT            ='SingleAmbientLight';
I1_SCANNING_REFLECTANCE            ='ScanningReflectance';
I1_SCANNING_AMBIENT_LIGHT          ='ScanningAmbientLight';

I1_RESET                           ='Reset'; %/*reset command parameters: I1_ALL, DeviceTypes, MeasurementModes*/
I1_ALL                             ='All';


eNoError = 0; %                               /* no error */
  eDeviceNotReady = 1; %                        /* device not ready	*/
  eDeviceNotConnected = 2; %                    /* device not connected	*/
  eDeviceNotCalibrated = 3; %                   /* device not calibrated */
  eKeyNotPressed = 4; %                         /* if no button	has been pressed */
  eNoSubstrateWhite = 5; %                      /* no substrate	white reference	set */
  eWrongMeasureMode = 6; %                      /* wrong measurement mode */
  eStripRecognitionFailed = 7; %                /* if the measurement mode is set to scanning and recognition is enabled */
  eNoDataAvailable = 8; %                       /* measurement not triggered, index out	of range (scanning) */
  eException = 9; %                             /* internal exception, use GetDeviceInfo(I1_LAST_ERROR)	for more details */
  eInvalidArgument = 10; %                       /* if a	passed method argument is invalid (i.e. NULL) */
  eUnknownError = 11; %                          /* unknown error occurred */
  eWrongDeviceType = 12; %                        /* operation not supported by this device type */



%
bRes = 1;

if libisloaded('EyeOne')
    unloadlibrary('EyeOne');
end;
loadlibrary([getenv('I1Dir') '\lib\EyeOne.dll'], [getenv('I1Dir') '\include\EyeOne.h']);
if ~libisloaded('EyeOne')
    error('Failed to load EyeOne library');
end

if calllib('EyeOne','I1_IsConnected') ~= eNoError
    disp('Can not find the device');
    bRes = 0;
    return;
end

if calllib('EyeOne', 'I1_SetOption', I1_MEASUREMENT_MODE, I1_SINGLE_EMISSION) ~= eNoError
    warning('Can not set measurement type');
    bRes = 0;
    return;
end;

if calllib('EyeOne', 'I1_SetOption', COLOR_SPACE_KEY, COLOR_SPACE_CIEXYZ) ~= eNoError
    warning('Can not set measurement type');
    bRes = 0;
    return;
end;

if eNoError ~= calllib('EyeOne', 'I1_SetOption', I1_SCREEN_TYPE, I1_LCD_SCREEN)
    warning('Can not set display type');
    bRes = 0;
    return;
end;
    
disp('Place the device on calibration platform and press enter');
pause
if calllib('EyeOne','I1_Calibrate') ~= eNoError
    warning('Calibration failed');
    bRes = 0;
    return;
end;

% if calllib('EyeOne', 'I1_SetOption', I1_MEASUREMENT_MODE, I1_SINGLE_EMISSION) ~= eNoError
%     warning('Can not set measurement type');
%     bRes = 0;
%     return;
% end;
% 
% if calllib('EyeOne', 'I1_SetOption', COLOR_SPACE_KEY, COLOR_SPACE_CIEXYZ) ~= eNoError
%     warning('Can not set measurement type');
%     bRes = 0;
%     return;
% end;

