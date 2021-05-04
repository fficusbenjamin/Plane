package body wind with SPARK_Mode is
   
   function Flow return Weather is
      result: Weather := (strgt => 70, dir => Up);
   begin
      return result;
      end Flow;  

end wind;
