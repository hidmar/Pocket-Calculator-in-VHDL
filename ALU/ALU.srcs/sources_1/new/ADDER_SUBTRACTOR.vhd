----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/07/2025 01:53:34 AM
-- Design Name: 
-- Module Name: ADDER_SUBTRACTOR - Behavioral
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

entity ADDER_SUBTRCATOR is
    Port (
        CLK    : in  STD_LOGIC;
        RESET  : in  STD_LOGIC;
        START  : in  STD_LOGIC;
        A      : in  STD_LOGIC_VECTOR (7 downto 0);
        Sign_A : in  STD_LOGIC;
        B      : in  STD_LOGIC_VECTOR (7 downto 0);
        Sign_B : in  STD_LOGIC;
        op     : in  STD_LOGIC;  -- '0' = Add, '1' = Subtract
        RAS    : out STD_LOGIC_VECTOR (7 downto 0);
        SIGN_R : out STD_LOGIC
    );
end ADDER_SUBTRCATOR;

architecture Behavioral of ADDER_SUBTRCATOR is
    signal signed_A, signed_B, signed_result : signed(8 downto 0);
begin

    process(A, B, op, Sign_A, Sign_B, signed_A, signed_B, signed_result)
    begin
        signed_A <= signed(Sign_A & A);
        signed_B <= signed(Sign_B & B);

        if op = '0' then
            signed_result <= signed_A + signed_B;
        else
            signed_result <= signed_A - signed_B;
        end if;

    end process;

    process(CLK, RESET)
    begin
        if RESET = '1' then
            RAS <= (others => '0');
            SIGN_R <= '0';
        elsif rising_edge(CLK) then
            if (START = '1') then
                RAS    <= std_logic_vector(signed_result(7 downto 0));
                SIGN_R <= std_logic(signed_result(8));     
            end if;    
        end if;
    end process;

end Behavioral;