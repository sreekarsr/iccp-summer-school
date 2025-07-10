classdef AptMotorZ825B < handle
	properties (Constant)
		MOTOR_PROGID = 'MGMOTOR.MGMotorCtrl.1',
		CHAN1_ID = 0,
% 		ROT_MOVE_POS = 1,
% 		ROT_MOVE_NEG = 2,
% 		ROT_MOVE_SHORT = 3,
	end
    
	properties (SetAccess = private)
		fig,
		ctrl,
		rotMove,
		maxAcc, 
		maxVel,
	end
    
	methods
		function obj = AptMotorZ825B(hwSerial, rotMove, maxAcc, maxVel)
			if (nargin < 2),
				rotMove = AptMotorZ825B.ROT_MOVE_SHORT; 
			end;
			if (nargin < 3),
				maxAcc = 5;	% APT default: 50;
			end;
			if (nargin < 4),
				maxVel = 10;	% APT default: 25;
			end;
			obj.fig = figure();

			% Create the active x control for the MOTOR control
			obj.ctrl = actxcontrol(AptMotorZ825B.MOTOR_PROGID,...
								[20 20 600 400], obj.fig);

			% Sets the hardware serial number
			obj.ctrl.HWSerialNum = hwSerial;
			obj.ctrl.StartCtrl();    
			drawnow(); 
% 			obj.ctrl.SetRotStageModes(rotMove, 2);
			obj.rotMove = rotMove;
			obj.ctrl.SetVelParams(AptMotorZ825B.CHAN1_ID,...
								0, maxAcc, maxVel);
			obj.maxAcc = maxAcc;
			obj.maxVel = maxVel;
		end
		
		function [] = home(obj)
			obj.ctrl.MoveHome(AptMotorZ825B.CHAN1_ID, true);
		end
        
		function [] = goto(obj, angleInDegrees)
			obj.ctrl.MoveAbsoluteRot(AptMotorZ825B.CHAN1_ID,...
									mod(angleInDegrees,360), 0,...
									obj.rotMove, true);
		end

		function [] = rotate(obj, angleInDegrees)
			obj.ctrl.MoveRelativeEx(AptMotorZ825B.CHAN1_ID,...
									angleInDegrees, 0, true);
        end

        function [] = kbrotate(obj, step)
              fprintf('Control stage using the keys A (+angle) and D (-angle). Step size : %f deg, Use m and n to increase or decrease step size.',step);
            while(1)
                ch = char(getkey);
                switch lower(ch)
                    case  'a'
                        obj.goto(obj.getpos - step);
                    case 'd'
                        obj.goto(obj.getpos + step);
                    case 'm'
                        if step *10> 20
                            disp('cannot increase step size over 20');
                        else
                            step = step * 10;
                            fprintf('Step size : %g deg\n',step);
                        end
                    case 'n'
                        step = step / 10;                            
                        fprintf('Step size : %g deg',step);
                    otherwise
                        break
                end
            end
        end
        
		function pos = getpos(obj)
			pos = mod(obj.ctrl.GetAbsMovePos_AbsPos(AptMotorZ825B.CHAN1_ID),360);
		end
		
		function [] = setrotparams(obj, rotMove)
% 			obj.ctrl.SetRotStageModes(rotMove, 2);
			obj.rotMove = rotMove;
		end
		
		function [] = setvelparams(obj, maxAcc, maxVel)
			obj.ctrl.SetVelParams(AptMotorZ825B.CHAN1_ID,...
									0, maxAcc, maxVel);
			obj.maxAcc = maxAcc;
			obj.maxVel = maxVel;
		end
		
		function [] = delete(obj)
			obj.ctrl.StopCtrl();
			obj.ctrl.delete();
			close(obj.fig);
		end
	end
end