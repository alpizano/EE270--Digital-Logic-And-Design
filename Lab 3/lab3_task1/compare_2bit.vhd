library ieee; 
use ieee.std_logic_1164.all;    
use ieee.numeric_std.all;

entity compare_2bit is

         port( x : in  std_logic_vector(1  downto 0);
               y : in  std_logic_vector(1 downto 0);
               L : out std_logic;
					G : out std_logic;
					E : out std_logic);
					
          end entity compare_2bit; 

 architecture dataflow of compare_2bit is
 
 signal less : std_logic_vector(3 downto 0);
 signal great : std_logic_vector(3 downto 0);
 --signal inter1 : std_logic;
-- signal inter2: std_logic;

begin    
         -- L <= inter1;
			--G <= inter2;
			
        --dataflow (SCSA) LESS mux0
		  
			less(0) <=  '0';
		   less(1) <= not x(1) AND not x(0);
         less(2) <= not x(1);
         less(3) <= not x(1) OR not x(0);
			
		-- dataflow (SCSA) GREAT mux1
			
			great(0) <= '0';
			great(1) <= not y(1) AND not y(0);
			great(2) <= not y(1);
			great(3) <= not y(1) OR not y(0);
	
		  -- behavioral (CCSA) mux0
		  L <=	less(1) when (y = "01") else
				less(2) when (y = "10") else
				less(3) when (y = "11") else
				less(0);

		  -- behavioral (CSSA) mux1
		  
			with x select
			G <= great(1) when "01",
					great(2) when "10",
					great(3) when "11",
					great(0) when "00",
					'-' when others;
					
					--dataflow (SCSA) EQ
			
			E <= not L and not G;
			
end architecture dataflow;