library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
entity DECISION is
    Port ( 
           CLK       : in STD_LOGIC;
           RESET     : in STD_LOGIC;
           OPERATION : in STD_LOGIC_VECTOR (2 downto 0);
           RAS       : in STD_LOGIC_VECTOR (7 downto 0);
           SIGN_RAS  : in STD_LOGIC;
           RM        : in STD_LOGIC_VECTOR (7 downto 0);
           SIGN_RM   : in STD_LOGIC;
           RD        : in STD_LOGIC_VECTOR (7 downto 0);
           R_REM     : in STD_LOGIC_VECTOR (3 downto 0);
           SIGN_RD   : in STD_LOGIC;
           SIGN_OUT  : out STD_LOGIC;
           NR_OUT    : out STD_LOGIC_VECTOR (7 downto 0);
           NR_REM    : out STD_LOGIC_VECTOR (3 downto 0);
           DIV       : out STD_LOGIC; 
           SUB       : out STD_LOGIC
           );
end DECISION;

architecture Behavioral of DECISION is

begin
    
    NR_REM <= R_REM; 
     PROCESS (CLK,RESET) begin
        if (RESET = '1') then
                SIGN_OUT <= '0';
                NR_OUT   <= (others => '0');
                DIV      <= '0';
                SUB      <= '0';             
        elsif rising_edge(CLK) then
            if (OPERATION = "001") then
                SIGN_OUT <= SIGN_RAS;
                NR_OUT   <= RAS;
                DIV      <= '0';
                SUB      <= '0';
            elsif (OPERATION = "010") then
                SIGN_OUT <= SIGN_RAS;
                if (SIGN_RAS = '1') then    
                    NR_OUT   <= STD_LOGIC_VECTOR(256 - UNSIGNED(RAS));
                else 
                    NR_OUT   <= RAS;      
                end if;    
                DIV      <= '0';
                SUB      <= '1';
            elsif (OPERATION = "011") then
                SIGN_OUT <= SIGN_RM;
                NR_OUT   <= RM;
                DIV      <= '0';
                SUB      <= '0';
            elsif (OPERATION = "100") then
                SIGN_OUT <= SIGN_RD;
                NR_OUT   <= RD;
                DIV      <= '1';
                SUB      <= '0';            
            end if;
        end if;    
    
    end process;
end Behavioral;
