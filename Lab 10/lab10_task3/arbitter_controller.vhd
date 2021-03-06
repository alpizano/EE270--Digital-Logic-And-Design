library ieee;
use ieee.std_logic_1164.all;

entity arbitter_controller is
	port(rst : in	std_logic; 
		  clk : in	std_logic; 
		  R	: in	std_logic_vector(0 to 2); 
		  G	: out std_logic_vector(0 to 2));
end entity;


architecture behavior of arbitter_controller is
	
	type StateType is (IDLE,GNT_DEV0 , GNT_DEV1,GNT_DEV2);
	signal presentState, nextState : StateType;
	
	attribute syn_encoding : string;
	attribute syn_encoding of StateType:
	type is "safe, compact";
	
begin

combo_logic: process (R, presentState) is begin
				 case presentState is
			
				when IDLE=>
					G <= "000";
					if R(0) = '1' then nextState <= GNT_DEV0; 
					elsif R(1) ='1' then nextState <= GNT_DEV1;
					elsif R(2) ='1' then nextState <= GNT_DEV2;					
					else	nextState <= IDLE;
					end if;	
					
				when GNT_DEV0 => 
					G <= "100";
					if R = "000"  then nextState <= IDLE;
					elSif R(0 to 1) ="01" then nextState <= GNT_DEV1;
					elsif R ="001" then nextState <= GNT_DEV2;
					else	nextState <= GNT_DEV0;
					end if;
					
				when GNT_DEV1 =>
					G <= "010";
					if R(1 to 2) = "01" then nextState <= GNT_DEV2;
					elsif R(1 to 2) ="00" then nextState <= IDLE;
					elsif R(1) ='1' then nextState <= GNT_DEV1 ;
					else	nextState <= GNT_DEV1 ;
					end if;	
					
				when GNT_DEV2 =>
					G <= "001";
					if R(2) = '0' then nextState <= IDLE;

					else	nextState <= GNT_DEV2 ;
					end if;
					
				when others=> nextState <= IDLE; G<="000";
				
			end case;
	end process combo_logic;
	

	state_reg: process(clk,rst) is begin 
		if rst = '1' then presentState <= IDLE;
			elsif rising_edge(clk) then presentState <= nextState;
		end if;
	end process state_reg;
	
end architecture behavior;
