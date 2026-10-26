----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/07/2025 02:00:23 AM
-- Design Name: 
-- Module Name: ENCODER - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ENCODER is
    Port ( CLK       : in STD_LOGIC;
           RESET     : in STD_LOGIC;
           DIGIT_B   : in STD_LOGIC_VECTOR (9 downto 0);
           RESULT_IN : in STD_LOGIC_VECTOR (8 downto 0);
           PLUS      : in STD_LOGIC;
           MINUS     : in STD_LOGIC;
           MULTI     : in STD_LOGIC;
           DIVIS     : in STD_LOGIC;
           ENTER     : in STD_LOGIC;
           NR_IN     : in STD_LOGIC;
           DIGIT_1   : out STD_LOGIC_VECTOR (8 downto 0);
           DIGIT_2   : out STD_LOGIC_VECTOR (8 downto 0);
           DIGIT_3   : out STD_LOGIC_VECTOR (8 downto 0);
           SIGN_OUT  : out STD_LOGIC;
           SIGN_1    : out STD_LOGIC;
           SIGN_2    : out STD_LOGIC; 
           OPERATION : out STD_LOGIC_VECTOR (2 downto 0) 
           );
end ENCODER;

architecture Behavioral of ENCODER is

    signal DIGIT_BCD : STD_LOGIC_VECTOR (3 downto 0);
    signal DIGIT1_BCD : STD_LOGIC_VECTOR (11 downto 0);
    signal DIGIT2_BCD : STD_LOGIC_VECTOR (11 downto 0);

    signal DIGIT1_BIN_OUT : STD_LOGIC_VECTOR (7 downto 0);
    signal DIGIT2_BIN_OUT : STD_LOGIC_VECTOR (7 downto 0);

    signal SIGN_TEMP : STD_LOGIC_VECTOR (0 DOWNTO 0);
    signal SIGN1_TEMP : STD_LOGIC_VECTOR (0 DOWNTO 0);
    signal SIGN2_TEMP : STD_LOGIC_VECTOR (0 DOWNTO 0);
    signal OPERATION_TEMP : STD_LOGIC_VECTOR (2 downto 0);
    
    signal HUNDRED_1, TEN_1, UNIT_1 : INTEGER range 0 to 9;
    signal DIGIT1_BIN : INTEGER range 0 to 999;

    signal HUNDRED_2, TEN_2, UNIT_2 : INTEGER range 0 to 9;
    signal DIGIT2_BIN : INTEGER range 0 to 999; 

    type state_type is (IDLE, NUMBER_IN_1, RESULT_1, NUMBER_IN_2, RESULT_2, DISPLAY_RESULT);
    signal current_state, next_state : state_type;

begin

    process(CLK, RESET)
    begin
        if RESET = '1' then
            DIGIT_BCD <= "0000";
        elsif rising_edge(CLK) then
            if DIGIT_B(0) = '1' then
                DIGIT_BCD <= "0000";
            elsif DIGIT_B(1) = '1' then
                DIGIT_BCD <= "0001";
            elsif DIGIT_B(2) = '1' then
                DIGIT_BCD <= "0010";  
            elsif DIGIT_B(3) = '1' then
                DIGIT_BCD <= "0011";  
            elsif DIGIT_B(4) = '1' then
                DIGIT_BCD <= "0100";  
            elsif DIGIT_B(5) = '1' then
                DIGIT_BCD <= "0101";      
            elsif DIGIT_B(6) = '1' then
                DIGIT_BCD <= "0110"; 
            elsif DIGIT_B(7) = '1' then
                DIGIT_BCD <= "0111"; 
            elsif DIGIT_B(8) = '1' then
                DIGIT_BCD <= "1000"; 
            elsif DIGIT_B(9) = '1' then
                DIGIT_BCD <= "1001"; 
            else 
                DIGIT_BCD <= "0000";                                           
            end if; 
        end if;
    end process;


    -- State register
    process(CLK, RESET)
    begin
        if RESET = '1' then
            current_state <= IDLE;
        elsif rising_edge(CLK) then
            current_state <= next_state;
        end if;
    end process;

    -- Next state logic
    process(current_state, NR_IN, ENTER, OPERATION_TEMP)
    begin
        case current_state is
            when IDLE =>
                if ENTER = '1' then
                    next_state <= NUMBER_IN_1;
                else
                    next_state <= IDLE;
                end if;

            when NUMBER_IN_1 =>
                if NR_IN = '1' then 
                    next_state <= RESULT_1;
                else    
                    next_state <= NUMBER_IN_1;
                end if;
            when RESULT_1 =>
                if OPERATION_TEMP = "000" then 
                    next_state <= NUMBER_IN_1;
                else
                    next_state <= NUMBER_IN_2;
                end if;

            when NUMBER_IN_2 =>
                if NR_IN = '1' then 
                    next_state <= RESULT_2;
                else    
                    next_state <= NUMBER_IN_2;
                end if;
            when RESULT_2 =>
                if ENTER =  '0' then 
                    next_state <= NUMBER_IN_2;
                else
                    next_state <= DISPLAY_RESULT;
                end if;

            when DISPLAY_RESULT =>
                if OPERATION_TEMP = "000" then 
                    next_state <= NUMBER_IN_1;
                else
                    next_state <= NUMBER_IN_2;
                end if;    

            when others =>
                next_state <= IDLE;
        end case;
    end process;

    process(CLK, RESET)
    begin
        if RESET = '1' then
            DIGIT1_BCD <= (others => '0');
        elsif rising_edge(CLK) then
            if (current_state = NUMBER_IN_1 and NR_IN = '1') then
                DIGIT1_BCD <= DIGIT1_BCD(7 downto 0) & DIGIT_BCD(3 downto 0);
            elsif (current_state = DISPLAY_RESULT) then
                DIGIT1_BCD <= (others => '0');          
            end if;
        end if;
    end process;

    process(CLK, RESET)
    begin
        if RESET = '1' then
            DIGIT2_BCD <= (others => '0');
        elsif rising_edge(CLK) then
            if (current_state = NUMBER_IN_2 and NR_IN = '1') then
                DIGIT2_BCD <= DIGIT2_BCD(7 downto 0) & DIGIT_BCD(3 downto 0);
            elsif (current_state = DISPLAY_RESULT) then
                DIGIT2_BCD <= (others => '0');          
            end if;
        end if;
    end process;

    process(DIGIT1_BCD, HUNDRED_1, TEN_1, UNIT_1, DIGIT1_BIN)
    begin
        HUNDRED_1 <= to_integer(unsigned(DIGIT1_BCD(11 downto 8)));
        TEN_1     <= to_integer(unsigned(DIGIT1_BCD(7 downto 4)));
        UNIT_1    <= to_integer(unsigned(DIGIT1_BCD(3 downto 0)));

        DIGIT1_BIN <= HUNDRED_1 * 100 + TEN_1 * 10 + UNIT_1;
        DIGIT1_BIN_OUT <= std_logic_vector(to_unsigned(DIGIT1_BIN, 8));
    end process;              

    process(DIGIT2_BCD, HUNDRED_2, TEN_2, UNIT_2, DIGIT2_BIN)
    begin
        HUNDRED_2 <= to_integer(unsigned(DIGIT2_BCD(11 downto 8)));
        TEN_2     <= to_integer(unsigned(DIGIT2_BCD(7 downto 4)));
        UNIT_2    <= to_integer(unsigned(DIGIT2_BCD(3 downto 0)));

        DIGIT2_BIN <= HUNDRED_2 * 100 + TEN_2 * 10 + UNIT_2;
        DIGIT2_BIN_OUT <= std_logic_vector(to_unsigned(DIGIT2_BIN, 8));
    end process;

    process(CLK, RESET)
    begin
        if RESET = '1' then
            DIGIT_1 <= (others => '0');
        elsif rising_edge(CLK) then
            if (current_state = RESULT_1) then
                DIGIT_1 <= '0' & DIGIT1_BIN_OUT;
            elsif (current_state = DISPLAY_RESULT and OPERATION_TEMP = "0000") then
                DIGIT_1 <= (others => '0');
            elsif (current_state = NUMBER_IN_2 and NR_IN = '1' and SIGN_TEMP = "1") then
                DIGIT_1 <= RESULT_IN;             
            end if;
        end if;
    end process;  

    process(CLK, RESET)
    begin
        if RESET = '1' then
            DIGIT_2 <= (others => '0');
        elsif rising_edge(CLK) then
            if (current_state = RESULT_2) then
                DIGIT_2 <= '0' & DIGIT2_BIN_OUT;
            elsif (current_state = NUMBER_IN_2 and NR_IN = '1' and SIGN_TEMP = "1") then
                DIGIT_2 <= (others => '0');
            end if;    
        end if;
    end process;         


    process(CLK, RESET)
    begin
        if RESET = '1' then
            DIGIT_3 <= (others => '0');
        elsif rising_edge(CLK) then
            DIGIT_3 <= RESULT_IN; 
        end if;
    end process; 

    SIGN_OUT <= SIGN_TEMP(0);
    process(CLK, RESET)
    begin
        if RESET = '1' then
            SIGN_TEMP <= "0";
        elsif rising_edge(CLK) then
            if (current_state = DISPLAY_RESULT) then
                SIGN_TEMP <= "1";
            elsif (current_state = RESULT_1 OR current_state = RESULT_2 or current_state = IDLE) then
                SIGN_TEMP <= "0";
            end if;    
        end if;
    end process;

    SIGN_1 <= SIGN1_TEMP(0); 
    process(CLK, RESET)
    begin
        if RESET = '1' then
            SIGN1_TEMP <= "0";
        elsif rising_edge(CLK) then
            if (current_state = RESULT_1) then
                SIGN1_TEMP <= "1";
            elsif (current_state = DISPLAY_RESULT OR current_state = RESULT_2 or current_state = IDLE) then
                SIGN1_TEMP <= "0";
            end if;    
        end if;
    end process;

    SIGN_2 <= SIGN2_TEMP(0);
    process(CLK, RESET)
    begin
        if RESET = '1' then
            SIGN2_TEMP <= "0";
        elsif rising_edge(CLK) then
            if (current_state = RESULT_2) then
                SIGN2_TEMP <= "1";
            elsif (current_state = DISPLAY_RESULT OR current_state = RESULT_1 or current_state = IDLE) then
                SIGN2_TEMP <= "0";
            end if;    
        end if;
    end process;        

    OPERATION <= OPERATION_TEMP;
    process(CLK, RESET)
    begin
        if RESET = '1' then
            OPERATION_TEMP <= (others => '0');
        elsif rising_edge(CLK) then
            if (current_state /= IDLE) then
                if (PLUS = '1') then 
                    OPERATION_TEMP <= "001";
                elsif (MINUS = '1') then 
                    OPERATION_TEMP <= "010";
                elsif (MULTI = '1') then 
                    OPERATION_TEMP <= "011";
                elsif (DIVIS = '1') then 
                    OPERATION_TEMP <= "100";
                else
                    OPERATION_TEMP <= "000";            
                end if;
            else
                OPERATION_TEMP <= "000";            
            end if;
        end if;
    end process;    
    
end Behavioral;
