with Ada.Text_IO; use Ada.Text_IO;
with Wind; use Wind;

package Plane with SPARK_Mode is

   type Engine is (On, Off);
   type Doors is (Open, Closed, Locked);
   type Fuel is range 0..100;
   type Light is (GREEN, AMBER, FLASHING);
   type Condition is (TakingOff, Flying, Landing, Idle, Crashed);
   type Speed is range 0..800;
   type Altitude is range 0..1000;
   type LandingGear is (Deployed, Retract);



   Type Plane is record
      CockpitDoors : Doors;
      ExternalDoors : Doors;
      Ignition : Engine;
      Tank : Fuel := 100;
      FuelLight : Light;
      AltiLight : Light;
      SpeedLight : Light;
      Status : Condition;
      Velocity : Speed := 800;
      Height : Altitude := 1000;
      Wheels : LandingGear;

   end record;

   Jet : Plane := (CockpitDoors => Open, ExternalDoors => Open, Ignition => Off, Tank => 100, Status => Idle,
                   FuelLight => GREEN,AltiLight => GREEN,SpeedLight => GREEN, Height => 0, Velocity =>0, Wheels => Deployed);

   Eolo : Weather := (Flow);


   procedure TakingOff with
     Global =>(In_Out => Jet, Proof_In => Eolo),
     Pre => Jet.Status = Idle and Jet.CockpitDoors = Locked and Jet.ExternalDoors = Locked and Jet.Tank > 25 and Jet.Ignition = On and Eolo.strgt < UnsafeTreshold,
     Post => Jet.Status = TakingOff;

   procedure Flying with
     Global =>(In_Out => Jet),
     Pre => Jet.Status = TakingOff and Jet.Velocity >= 300 and Jet.Height >= 500,
     Post => Jet.Status = Flying;


   procedure LowFuel with
     Global => (In_Out => (Jet,File_System)),
     Pre => Jet.Status = Flying and Jet.Tank < 30,
     Post => Jet.FuelLight = FLASHING;

   procedure SpeedLimits with
     Global => (In_Out => (Jet, File_System)),
     Pre => Jet.Status = Flying and Jet.Velocity < 200 and Jet.Velocity > 800,
     Post => Jet.SpeedLight = FLASHING;

   procedure AltitudeLimits with
     Global => (In_Out => (Jet, File_System)),
     Pre => Jet.Status = Flying and Jet.Height < 300 and Jet.Height > 1000,
     Post => Jet.AltiLight = FLASHING;

   procedure LandingProcedure with
     Global => (In_Out => Jet),
     Pre => Jet.Status = Landing and Jet.Height = 100 and Jet.Velocity = 200,
     Post => Jet.Wheels = Deployed;

   procedure Towed with
     Global => (In_Out => (Jet, File_System)),
     Pre => Jet.Status = Landing and Jet.Height = 0 and Jet.Velocity = 0,
     Post => Jet.Ignition = Off;

   procedure IncreasingSpeed with
     Global => (In_Out => (Jet, File_System)),
     Pre => Jet.Status = TakingOff and Jet.Velocity >=0 and Jet.Velocity < 200,
     Post => Jet.Velocity = Jet.Velocity'Old + 10;

   procedure IncreasingAltitude with
     Global => (In_Out => (Jet, File_System)),
     Pre => Jet.Status = TakingOff and Jet.Height >= 0 and Jet.Height < 300,
     Post => Jet.Height = Jet.Height'Old + 20;

   procedure DecreasingSpeed with
     Global => (In_Out => (Jet, File_System)),
     Pre => Jet.Status = Flying and Jet.Velocity <= 800 and Jet.Velocity > 200,
     Post => Jet.Velocity = Jet.Velocity'Old - 10;

   procedure DecreasingAltitude with
     Global => (In_Out => (Jet, File_System)),
     Pre => Jet.Status = Flying and Jet.Height <= 1000 and Jet.Height > 300,
     Post => Jet.Height = Jet.Height'Old - 20;


   procedure BurningFuel with
     Global => (In_Out => Jet),
     Pre => Jet.Status = Flying and Jet.Tank >= 10,
     Post => Jet.Tank = Jet.Tank'Old - 10;

   procedure UpwindBF with
     Global => (In_Out => Jet),
     Pre => Jet.Status = Flying and Jet.Tank >= 20,
     Post => Jet.Tank = Jet.Tank'Old - 20;

end Plane;
