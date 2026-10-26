----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/06/2025 07:28:48 PM
-- Design Name: 
-- Module Name: DIVIDER - Behavioral
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

entity DIVIDER is
    Port (
        CLK       : in  std_logic;
        RESET     : in  std_logic;
        START     : in  std_logic;
        dividend  : in  STD_LOGIC_VECTOR(8 downto 0);
        divisor   : in  STD_LOGIC_VECTOR(8 downto 0);
        quotient  : out STD_LOGIC_VECTOR(7 downto 0);
        remainder : out STD_LOGIC_VECTOR(3 downto 0);
        SIGN      : out STD_LOGIC
    );
end DIVIDER;

architecture Behavioral of DIVIDER is
    signal temp_dividend : unsigned(7 downto 0);
    signal temp_divisor  : unsigned(7 downto 0);
    signal temp_quotient : unsigned(7 downto 0);
    signal state         : std_logic := '0';
    signal sign_cal      : std_logic;
begin
    
    process(CLK)
    begin
        if rising_edge(CLK) then
            if (RESET = '1') then
                quotient  <= (others => '0');
                remainder <= (others => '0');
                sign_cal  <= '0';
                state     <= '0';
                temp_dividend  <= (others => '0');
                temp_divisor   <= (others => '0'); 
                temp_quotient  <= (others => '0');
                SIGN           <= '0';
            elsif START = '1' and state = '0' then
                temp_dividend <= unsigned(dividend(7 downto 0));
                temp_divisor  <= unsigned(divisor(7 downto 0));
                temp_quotient <= (others => '0');
                state <= '1';
                sign_cal <= dividend(8) XOR divisor(8); 
            elsif state = '1' then
                if temp_dividend >= temp_divisor then
                    temp_dividend <= temp_dividend - temp_divisor;
                    temp_quotient <= temp_quotient + 1;
                else
                    quotient  <= STD_LOGIC_VECTOR(temp_quotient);
                    remainder <= STD_LOGIC_VECTOR(temp_dividend(3 downto 0));
                    SIGN      <= sign_cal; 
                    state <= '0';
                end if;
            end if;
        end if;
    end process;
end Behavioral;