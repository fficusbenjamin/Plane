with Ada.Text_IO; use Ada.Text_IO;

package body Plane with SPARK_Mode is


   procedure TakingOff is
   begin
      if(Jet.Status = Idle and Jet.CockpitDoors = Locked and Jet.ExternalDoors = Locked and Jet.Tank >= 25 and Jet.Ignition = On) then
         Jet.Status := TakingOff;
      end if;
   end TakingOff;


   procedure Flying is
   begin
      if(Jet.Status = TakingOff and Jet.Velocity >= 200 and Jet.Height >= 300) then
         Jet.Status := Flying;
      end if;
   end Flying;



   procedure LowFuel is
   begin
      if(Jet.Status = Flying and Jet.Tank < 30) then
         Jet.FuelLight := FLASHING;
         Put_Line("LOW FUEL, LAND!"&Jet.FuelLight'Image);

      end if;
   end LowFuel;

   procedure SpeedLimits is
   begin

      if (Jet.Status = Flying and Jet.Velocity < 200) then
         Jet.SpeedLight := FLASHING;
         Put_Line("Flying to Slow!"&Jet.Velocity'Image& " "&Jet.SpeedLight'Image);
      end if;
      if (Jet.Status = Flying and Jet.Velocity > 800) then
         Jet.SpeedLight := FLASHING;
         Put_Line("Flying to Fast!"&Jet.Velocity'Image& " "&Jet.SpeedLight'Image);
      end if;

   end SpeedLimits;

   procedure AltitudeLimits is
   begin


      if(Jet.Status = Flying and Jet.Height < 300) then
         Jet.AltiLight := FLASHING;
         Put_Line("Flying to Low!"&Jet.Height'Image& " "&Jet.AltiLight'Image);
      end if;
      if(Jet.Status = Flying and Jet.Height > 1000) then
         Jet.AltiLight := FLASHING;
         Put_Line("Flying to High!"&Jet.Height'Image& " "&Jet.AltiLight'Image);
      end if;

   end AltitudeLimits;

   procedure LandingProcedure is
   begin
      if (Jet.Status = Landing and Jet.Height = 100 and Jet.Velocity = 200) then
         Jet.Wheels := Deployed;
      end if;
   end LandingProcedure;

   procedure Towed is
   begin
      if(Jet.Status = Landing and Jet.Height = 0 and Jet.Velocity = 0) then
         Jet.Ignition := Off;
         Put_Line("The plane is being towed, the engine is: "&Jet.Ignition'Image);
      end if;
   end Towed;

   procedure IncreasingSpeed is
   begin
      Jet.Velocity := Jet.Velocity + 10;
      Put_Line("Jet Speed is: "&Jet.Velocity'Image);

   end IncreasingSpeed;

   procedure IncreasingAltitude is
   begin
      Jet.Height := Jet.Height + 20;
      Put_Line("Jet Height is: "&Jet.Height'Image);
      if( Jet.Height > 25 and Jet.Wheels = Deployed)then
         Jet.Wheels := Retract;
         Put_Line("Landing Gear Retracted");

      end if;

   end IncreasingAltitude;

   procedure DecreasingSpeed is
   begin
      Jet.Velocity := Jet.Velocity - 10;
      Put_Line("Jet Speed is: "&Jet.Velocity'Image);
   end DecreasingSpeed;

   procedure DecreasingAltitude is
   begin
      Jet.Height := Jet.Height - 20;
      Put_Line("Jet Height is: "&Jet.Height'Image);
      if( Jet.Height < 25 and Jet.Wheels = Retract)then
         Jet.Wheels := Deployed;
         Put_Line("Landing Gear Deployed");

      end if;
   end DecreasingAltitude;


   procedure BurningFuel is
   begin
      if(Jet.Status = Flying and Jet.Tank >= 10)then
         Jet.Tank := Jet.Tank -10;
      end if;

   end BurningFuel;


end Plane;
