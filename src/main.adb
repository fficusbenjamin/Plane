with Plane; use Plane;
with Wind; use Wind;
with Ada.Text_IO; use Ada.Text_IO;

procedure Main is
   Str: String (1..2);
   Last: Natural;

   task Boarding;
   task Starting;
   task Ongoing;
   task Arriving;
   task WarningSystem;


   task body Boarding is
   begin
      Put_Line("Plane Status is: " &Jet.Status'Image);
      Put_Line("The Engine is: "&Jet.Ignition'Image);
      Put_Line("Cockpit Doors are: "&Jet.CockpitDoors'Image);
      Put_Line("External Doors are: "&Jet.ExternalDoors'Image);
      Put_Line("The Fuel Tank is: "&Jet.Tank'Image);
      loop
         if (Jet.Status = Idle)then
            Get_Line(Str,Last);
            case Str(1) is
               when '1' => Jet.ExternalDoors := Locked;
                  Put_Line("External Doors have been closed and locked "&Jet.ExternalDoors'Image);
               when '2' => Jet.CockpitDoors := Locked;
                  Put_Line("Cockpit Doors have been closed and locked "&Jet.CockpitDoors'Image);
               when '3' => jet.Ignition := On;
                  Put_Line("Engine Started");
               when 's' => Put_Line("Plane Status is: " &Jet.Status'Image);
                  Put_Line("The Engine is: "&Jet.Ignition'Image);
                  Put_Line("Cockpit Doors are: "&Jet.CockpitDoors'Image);
                  Put_Line("External Doors are: "&Jet.ExternalDoors'Image);
                  Put_Line("The Fule Tank is: "&Jet.Tank'Image);
               when others => abort Starting; abort Ongoing; abort Arriving; exit;
            end case;
            if (Jet.CockpitDoors = Locked and Jet.ExternalDoors = Locked and Jet.Ignition = On and Jet.Tank >= 25 and Eolo.strgt < UnsafeTreshold)then
               Put_Line("Plane ready to take off");
               TakingOff;
            end if;
            if (Jet.CockpitDoors = Locked and Jet.ExternalDoors = Locked and Jet.Ignition = On and Jet.Tank < 25)then
               Put_Line("Plane not ready to take off, Low Fuel");
            end if;
            if (Jet.CockpitDoors = Locked and Jet.ExternalDoors = Locked and Jet.Ignition = On and Jet.Tank >= 25 and Eolo.strgt >= UnsafeTreshold)then
               Put_Line("Plane not ready to take off, Wind too strong!");
            end if;
         end if;
      end loop;
      delay 0.5;
   end Boarding;

   task body Starting is
   begin
      loop
         if (Jet.Status = TakingOff)then
            IncreasingSpeed;
            IncreasingAltitude;
            delay 0.5;
            if(Jet.Velocity >= 200 and Jet.Height >= 300)then
               Flying;
            end if;
         end if;
      end loop;
   end Starting;

   task body Ongoing is
   begin
      loop
         if (Jet.Status = Flying and Jet.Tank > 0) then
            Put_Line("FLYING YAYYYY");
            Get_Line(Str, Last);
            case Str(1) is
               when 'u' => IncreasingAltitude;
               when 'd' => DecreasingAltitude;
               when 'f' => IncreasingSpeed;
               when 'b' => DecreasingSpeed;
               when 'l' => Jet.Status := Landing;
               when others => abort Starting; abort Boarding; abort Arriving; exit;
            end case;
            SpeedLimits;
            AltitudeLimits;

         end if;


      end loop;
   end Ongoing;

   task body WarningSystem is
   begin
      loop
         if(Jet.Status = Flying and Jet.Tank /= 0) then
            BurningFuel;
            Put_Line("Fuel Left is: "&Jet.Tank'Image);
            LowFuel;
            delay 10.0;
         end if;
         if(Jet.Status = Flying and Jet.Tank = 0)then
            Put_Line("Empty Fuel Tank! Crashing!");
            DecreasingAltitude;
            DecreasingSpeed;
            delay 0.5;
            if(Jet.Status = Flying and Jet.Tank = 0 and Jet.Height = 0 and Jet.Velocity = 0 and Jet.FuelLight = FLASHING)then
               Put_Line("The plane has crashed");
               abort Starting; abort Boarding; abort Arriving; abort Ongoing; exit;
            end if;
         end if;

      end loop;
   end WarningSystem;

   task body Arriving is
   begin
      loop
         if (Jet.Status = Landing) then
            DecreasingSpeed;
            DecreasingAltitude;
            LandingProcedure;
            Put_Line("Landing!");
            if(Jet.Wheels = Deployed and Jet.Height = 0 and Jet.Velocity = 0) then
               Towed;
            end if;
         end if;
         delay 0.5;
      end loop;
   end Arriving;


begin
   null;
end Main;


