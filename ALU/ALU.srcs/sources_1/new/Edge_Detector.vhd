library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library xil_defaultlib;
use xil_defaultlib.all;
entity Edge_Detector is
  Port ( CLK: in std_logic;
         BUTTON_IN: in std_logic;
         PULSE: out std_logic
         );
end Edge_Detector;

architecture Behavioral of Edge_Detector is
signal counter: unsigned(28 downto 0):= (others=>'0');
signal D0,D1,D2: std_logic;

begin
PULSE <= D1 XOR D2;


process(CLK)
begin
if rising_edge(CLK) then
   if (counter < 50000000) then
    --if (counter < 10) then
    counter <= counter + 1;
    D0 <= D0;
   else
    counter <= (others=>'0');
    D0 <= BUTTON_IN;
   end if;
 end if;
end process; 

process(CLK) begin
    if rising_edge(CLK) then
        D1 <= D0;
        D2 <= D1;
    end if;
end process;

end Behavioral;
