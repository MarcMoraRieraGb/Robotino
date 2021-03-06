%% Code explanation
% First we will need to construct objects that we will be requiring in our
% program. In this program, we will require objects of |Com|, |OmniDrive|,
% |Camera| and |Bumper|. This is done as follows.

ComId = Com_construct;
CameraId = Camera_construct;
BumperId = Bumper_construct;
MotorId0  = Motor_construct( 0 );
MotorId1  = Motor_construct( 1 );
MotorId2  = Motor_construct( 2 );
DistanceSensorId0 = DistanceSensor_construct(0);
OdometryId = Odometry_construct;
%%
% Upon successful contruction of the objects, an Id is returned for each
% object. This Id is used later when communicating with Robotino. Now we
% need to set the address of Robotino and then connect to it. This is done
% as follows.
%%
% *Note the IP address and port number might be different*

Com_setAddress(ComId, '192.168.1.203');
Com_connect(ComId);

%%
% 
% Once we are connected to Robotino, we need to bind each of the object we
% created to Robotino using the ComId. This can be done as follows.
%

Camera_setComId(CameraId, ComId);
Bumper_setComId(BumperId, ComId);
Motor_setComId( MotorId0, ComId );
Motor_setComId( MotorId1, ComId );
Motor_setComId( MotorId2, ComId );
DistanceSensor_setComId( DistanceSensorId0, ComId )
Odometry_setComId( OdometryId, ComId )

%%
 
evalin('base', 'clear NomMatriuImatge');
 
 while (exist ('NomMatriuImatge')~=1)
 if ~(Camera_setStreaming(CameraId, 1) == 1)
        disp('Camera_setStreaming failed.');
 end
   if (Camera_grab(CameraId) == 1)
        NomMatriuImatge = Camera_getImage( CameraId );
   end
 end
 
while (Bumper_value(BumperId) == 0)
end

while (Bumper_value(BumperId) == 1)
end
state=1;
Vy=0.1;
while (DistanceSensor_voltage(DistanceSensorId0)<1.261)
    t1 = tic;

        if (Camera_grab(CameraId) == 1)
            NomMatriuImatge = Camera_getImage( CameraId );
        end
   
    
    
if (state==1 && ~isnan(d2))   
     state=2;
     Odometry_set(OdometryId, 0, 0, 0);
     
elseif (state ==2 && isnan(d2))
     state=3;
     Odometry_set(OdometryId, 0, 0, 0);
     
elseif (state==3 && y>=(d2_backup*sign(d2_backup))-200)
    state=4;
    Odometry_set(OdometryId, 0, 0, 0);

     Odometry_set(OdometryId, 0, 0, 0);
end
      
    if (state == 2)    
    d2_backup=d2;
    end


if (state==1 || state == 2)
    [d1, d2, theta] = CalcVariable(NomMatriuImatge);
    clc
    disp([d1,theta,state])
    
    gamma=(2/(400^2))*(d1*cosd(theta)-sqrt(400^2-d1^2)*sind(theta));

    w=Vy*gamma*1000;

    W1=w*(1/(3*0.5818*0.001));
    W0=W1-Vy*(1/(2*0.1511*0.001));
    W2=W1+Vy*(1/(2*0.1511*0.001));

    if (W1>600)
        W1=600;
    end
    if (W1<-600)
        W1=-600;
    end

    if (W0>600)
        W0=600;
    end
    if (W0<-600)
        W0=-600;
    end

    if (W2>600)
        W2=600;
    end
    if (W2<-600)
        W2=-600;
    end

    VM1 = Motor_setSetPointSpeed( MotorId0, (W0+sign(W0)*26.74)/0.9624);
    VM2 = Motor_setSetPointSpeed( MotorId1, (W1+sign(W1)*26.74)/0.9624);
    VM3 = Motor_setSetPointSpeed( MotorId2, (W2+sign(W2)*26.74)/0.9624);

    pause(0.25-toc(t1))
end

    
if (state==3) 

    [d1, d2, theta] = CalcVariable(NomMatriuImatge);
    clc
    disp([d1,theta,state])

    gamma=(2/(400^2))*(d1*cosd(theta)-sqrt(400^2-d1^2)*sind(theta));

    w=Vy*gamma*1000;

    W1=w*(1/(3*0.5818*0.001));
    W0=W1-Vy*(1/(2*0.1511*0.001));
    W2=W1+Vy*(1/(2*0.1511*0.001));

    if (W1>600)
        W1=600;
    end
    if (W1<-600)
        W1=-600;
    end

    if (W0>600)
        W0=600;
    end
    if (W0<-600)
        W0=-600;
    end

    if (W2>600)
        W2=600;
    end
    if (W2<-600)
        W2=-600;
    end

    VM1 = Motor_setSetPointSpeed( MotorId0, (W0+sign(W0)*26.74)/0.9624);
    VM2 = Motor_setSetPointSpeed( MotorId1, (W1+sign(W1)*26.74)/0.9624);
    VM3 = Motor_setSetPointSpeed( MotorId2, (W2+sign(W2)*26.74)/0.9624);


    pause(0.25-toc(t1))
    
    [y, x, AngleGirat]=Odometry_get(OdometryId);   
end

if (state==4)
    clc
    disp([d1,theta,state])
    VM1 = Motor_setSetPointSpeed( MotorId0, (-10*26.74)/0.9624);
    VM2 = Motor_setSetPointSpeed( MotorId1, (-10*26.74)/0.9624);
    VM3 = Motor_setSetPointSpeed( MotorId2, (-10*26.74)/0.9624);
    t2=tic
    while (toc(t2)<3)
    end
    state=1;
    Motor_setSetPointSpeed( MotorId0, 0 );
    Motor_setSetPointSpeed( MotorId1, 0 );
    Motor_setSetPointSpeed( MotorId2, 0 );
    Odometry_set(OdometryId, 0, 0, 0);

end

end
Motor_setSetPointSpeed( MotorId0, 0 );
Motor_setSetPointSpeed( MotorId1, 0 );
Motor_setSetPointSpeed( MotorId2, 0 );

     
%%
% 
% We will need to disconnect from Robotino as follows.
%
Com_disconnect(ComId);

%%
% 
% It is also recommended to destroy all objects that we created for our
% example. This can be done as follows.
%
Motor_destroy( MotorId0);
Motor_destroy( MotorId1);
Motor_destroy( MotorId2);
DistanceSensor_destroy( DistanceSensorId0 )
Camera_destroy(CameraId);
Bumper_destroy(BumperId);
Com_destroy(ComId);
Odometry_destroy(OdometryId);



