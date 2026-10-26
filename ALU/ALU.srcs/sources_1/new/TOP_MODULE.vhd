----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/07/2025 03:03:02 AM
-- Design Name: 
-- Module Name: TOP_MODULE - Behavioral
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

entity TOP_MODULE is
  Port (CLK    : in std_logic;
        RESET  : in  std_logic;
        DIGIT_B : in STD_LOGIC_VECTOR (9 downto 0);
        PLUS    : in STD_LOGIC;
        MINUS   : in STD_LOGIC;
        MULTI   : in STD_LOGIC;
        DIVIS   : in STD_LOGIC;
        ENTER   : in STD_LOGIC;
        NR_IN   : in STD_LOGIC;
        ANODE   : out STD_LOGIC_VECTOR (3 DOWNTO 0);
        CATHODE : out STD_LOGIC_VECTOR (7 DOWNTO 0)
   );
end TOP_MODULE;

architecture Behavioral of TOP_MODULE is

 signal NR_IN_PULSE : STD_LOGIC;
 
 signal DIGIT_1   : STD_LOGIC_VECTOR (8 downto 0);
 signal DIGIT_2   : STD_LOGIC_VECTOR (8 downto 0);
 signal DIGIT_3   : STD_LOGIC_VECTOR (8 downto 0);
 signal START     : STD_LOGIC; 
 signal OPERATION : STD_LOGIC_VECTOR (2 downto 0);
 signal RAS       : STD_LOGIC_VECTOR (7 downto 0);
 signal SIGN_RAS  : STD_LOGIC;
 signal RM        : STD_LOGIC_VECTOR (7 downto 0);
 signal SIGN_RM   : STD_LOGIC;
 signal RD        : STD_LOGIC_VECTOR (7 downto 0);
 signal RD_REM    : STD_LOGIC_VECTOR (3 downto 0);
 signal SIGN_RD   : STD_LOGIC;
 signal DIV       : STD_LOGIC;
 signal SIGN_OUT  : STD_LOGIC;
 signal SIGN_1    : STD_LOGIC;
 signal SIGN_2    : STD_LOGIC;
 signal SUB       : STD_LOGIC;
 signal NR_OUT    : STD_LOGIC_VECTOR (7 downto 0);
 signal NR_REM    : STD_LOGIC_VECTOR (3 downto 0); 
 signal RESULT_IN : STD_LOGIC_VECTOR (8 downto 0); 
 
component Edge_Detector 
  Port ( CLK: in std_logic;
         BUTTON_IN: in std_logic;
         PULSE: out std_logic
         );
end component;


component MULTIPLIER
    Port ( CLK        : in STD_LOGIC;
           RESET      : in  std_logic;
           START      : in STD_LOGIC;
           OPERANDS_A : in STD_LOGIC_VECTOR  (8 downto 0);
           OPERANDS_B : in STD_LOGIC_VECTOR  (8 downto 0);
           PRODUCT    : out STD_LOGIC_VECTOR (7 downto 0);
           SIGN       : out STD_LOGIC);
end component;

component ADDER_SUBTRCATOR
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
end component;

component DIVIDER
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
end component;

component DECISION
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
end component;

component ENCODER
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
end component;

component SEGMENT_7
    Port ( CLK          : in STD_LOGIC;
           DIV          : in STD_LOGIC;
           SIGN_1       : in STD_LOGIC;
           SIGN_2       : in STD_LOGIC;
           SIGN_OUT     : in STD_LOGIC;
           DIGIT1       : in STD_LOGIC_VECTOR  (8 DOWNTO 0);
           DIGIT2       : in STD_LOGIC_VECTOR  (8 DOWNTO 0);
           DIGIT3       : in STD_LOGIC_VECTOR  (8 DOWNTO 0);
           NR_REM       : in STD_LOGIC_VECTOR  (3 downto 0);
           ANODE        : out STD_LOGIC_VECTOR (3 DOWNTO 0);
           CATHODE      : out STD_LOGIC_VECTOR (7 DOWNTO 0)
           );
end component;

begin

    EDGE_NR   :  Edge_Detector Port map (CLK => CLK, BUTTON_IN => NR_IN, PULSE => NR_IN_PULSE);
    RESULT_IN <= (SIGN_OUT & NR_OUT); 
    ENC: ENCODER Port map 
         ( CLK     => CLK,
           RESET   => RESET,
           DIGIT_B => DIGIT_B,
           RESULT_IN => RESULT_IN,
           PLUS    => PLUS, 
           MINUS   => MINUS,
           MULTI   => MULTI,
           DIVIS   => DIVIS,
           ENTER   => ENTER,
           NR_IN   => NR_IN_PULSE, 
           DIGIT_1 => DIGIT_1,
           DIGIT_2 => DIGIT_2,
           DIGIT_3 => DIGIT_3,
           SIGN_OUT => START,
           SIGN_1   => SIGN_1,
           SIGN_2   => SIGN_2,
           OPERATION => OPERATION
           );
           
           
    MOD_MULTI: MULTIPLIER Port map 
         ( CLK     => CLK,
           RESET   => RESET,
           START   => START,
           OPERANDS_A => DIGIT_1,
           OPERANDS_B => DIGIT_2,
           PRODUCT    => RM,
           SIGN       => SIGN_RM);

    MOD_ADD: ADDER_SUBTRCATOR Port map(
        CLK    => CLK,
        RESET  => RESET,
        START  => START,
        A      => DIGIT_1(7 DOWNTO 0),
        Sign_A => DIGIT_1(8),
        B      => DIGIT_2(7 DOWNTO 0),
        Sign_B => DIGIT_2(8),
        op     => SUB,
        RAS    => RAS,
        SIGN_R => SIGN_RAS
    );

   MOD_DIV: DIVIDER Port map (
        CLK       => CLK,
        RESET     => RESET,
        START     => START,
        dividend  => DIGIT_1,
        divisor   => DIGIT_2,
        quotient  => RD,
        remainder => RD_REM,
        SIGN      => SIGN_RD
    );
    
    MOD_DIS: DECISION Port map 
         ( CLK       => CLK,
           RESET     => RESET,
           OPERATION => OPERATION,
           RAS       => RAS,
           SIGN_RAS  => SIGN_RAS,
           RM        => RM,
           SIGN_RM   => SIGN_RM,
           RD        => RD,
           R_REM     => RD_REM,
           SIGN_RD   => SIGN_RD,
           SIGN_OUT  => SIGN_OUT,
           NR_OUT    => NR_OUT,
           NR_REM    => NR_REM,
           DIV       => DIV, 
           SUB       => SUB
           );
           
    SEG: SEGMENT_7 Port map 
         ( CLK     => CLK,
           DIV     => DIV,
           SIGN_1  => SIGN_1,
           SIGN_2  => SIGN_2,
           SIGN_OUT => START,
           DIGIT1  => DIGIT_1,
           DIGIT2  => DIGIT_2,
           DIGIT3  => DIGIT_3,
           NR_REM  => NR_REM,
           ANODE   => ANODE,
           CATHODE => CATHODE
           );            

end Behavioral;
