library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity MULTIPLIER is
    Port ( CLK        : in STD_LOGIC;
           RESET      : in STD_LOGIC;
           START      : in STD_LOGIC;
           OPERANDS_A : in STD_LOGIC_VECTOR  (8 downto 0);
           OPERANDS_B : in STD_LOGIC_VECTOR  (8 downto 0);
           PRODUCT    : out STD_LOGIC_VECTOR (7 downto 0);
           SIGN       : out STD_LOGIC);
end MULTIPLIER;

architecture Behavioral of MULTIPLIER is
    signal value_a : unsigned  (7  downto 0);
    signal value_b : unsigned  (7  downto 0);
    signal result  : unsigned  (14 downto 0);
    signal result_f : unsigned (14 downto 0);
    signal counter : unsigned  (7 downto 0); 
    signal sign_cal : std_logic;
    signal state    : std_logic := '0';
begin

    PROCESS (CLK,RESET) begin
        if (RESET = '1') then
            value_a  <= (others => '0');
            value_b  <= (others => '0');
            counter  <= (others => '0');
            result   <= (others => '0');
            result_f <= (others => '0');
            sign_cal <= '0';
            state    <= '0'; 
        elsif rising_edge(CLK) then
            PRODUCT <= STD_LOGIC_VECTOR(result_f(7 downto 0)); 
            SIGN    <= sign_cal;  
                
            if (START = '1' and state = '0') then
                value_a  <= unsigned(OPERANDS_A(7 downto 0));
                value_b  <= unsigned(OPERANDS_B(7 downto 0));
                counter  <= (others => '0');
                result   <= (others => '0');
                sign_cal <= (OPERANDS_A(8) xor OPERANDS_B(8));
                state    <= '1';      
            elsif (counter < value_b(3 downto 1)) then
                counter <= counter + 1;
                result  <= result +  (value_a(7 downto 0) & '0');    
                state   <= '1';
            else 
                state   <= '0';
                counter <= counter;
                if (value_b(0) = '1') then
                    result_f <= result + value_a;
                else 
                    result_f <= result;    
                end if;   
            end if;
        end if; 
    end process;

end Behavioral;
