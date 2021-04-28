package wind with SPARK_Mode is

   type Strenght is range 0..100;
   type Direction is (Up, Down);
   
   UnsafeTreshold : constant Strenght := 80;
   
   type Weather is record
      
      strgt : Strenght;
      dir : Direction;
      
   end record;
   
   function Flow return Weather;
      
     
      

end wind;
