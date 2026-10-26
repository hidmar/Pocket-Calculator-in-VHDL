library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
entity SEGMENT_7 is
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
end SEGMENT_7;

architecture Behavioral of SEGMENT_7 is
signal WIREN : UNSIGNED (7 DOWNTO 0);
signal WIRE0 : UNSIGNED (7 DOWNTO 0);
signal WIRE1 : UNSIGNED (7 DOWNTO 0);
signal WIRE2 : UNSIGNED (7 DOWNTO 0);
signal DIGIT_TEMP : STD_LOGIC_VECTOR (7 downto 0);
signal DISPLAY : UNSIGNED (3 DOWNTO 0);

signal counter: unsigned(19 downto 0):= (others=>'0');
signal anode_count: unsigned(1 downto 0):= (others=>'0');

signal SIGN : STD_LOGIC;
begin


    process (SIGN_1, SIGN_2, SIGN_OUT, DIGIT1, DIGIT2, DIGIT3) begin 
        if (SIGN_OUT = '1') then
            DIGIT_TEMP <= DIGIT3(7 downto 0);
            SIGN       <= DIGIT3(8);  
        elsif (SIGN_1 = '1') then
            DIGIT_TEMP <= DIGIT1(7 downto 0);
            SIGN       <= DIGIT1(8);
        elsif (SIGN_2 = '1') then
            DIGIT_TEMP <= DIGIT2(7 downto 0);
            SIGN       <= DIGIT2(8); 
        else
            DIGIT_TEMP <= (others => '0');
            SIGN       <= '0';              
        end if;
    end process;



WIRE2 <= UNSIGNED (DIGIT_TEMP)/ 100;
WIREN <= UNSIGNED (DIGIT_TEMP)rem 100;
WIRE1 <= UNSIGNED (WIREN)/ 10;
WIRE0 <= UNSIGNED (WIREN)rem 10;



    process(CLK) begin
        if rising_edge(CLK) then
            if (counter < 250000) then
                counter <= counter + 1;
            else
                counter <= (others=>'0');
                anode_count <= anode_count + 1;
            end if;
        end if;
    end process;
    
    process (anode_count) begin 
        if (anode_count = "00") then
            ANODE <= "1110"; 
        elsif (anode_count = "01") then
            ANODE <= "1101";
        elsif (anode_count = "10") then
            ANODE <= "1011"; 
        else
            ANODE <= "0111";                
        end if;
    end process;
    
    process (CLK) begin
        if rising_edge(CLK) then
            if (DIV = '1' and SIGN_OUT = '1') then
                if (anode_count = "01") then
                    DISPLAY <= WIRE0(3 DOWNTO 0);
                    CATHODE(7) <= '0'; 
                elsif (anode_count = "10") then
                    DISPLAY <= WIRE1(3 DOWNTO 0);
                    CATHODE(7) <= '1'; 
                elsif (anode_count = "11") then
                    DISPLAY <= WIRE2(3 DOWNTO 0);
                    CATHODE(7) <= '1';  
                else
                    DISPLAY <= UNSIGNED(NR_REM);
                    CATHODE(7) <= '1';                
                end if;
            else
                CATHODE(7) <= '1';
                if (anode_count = "00") then
                    DISPLAY <= WIRE0(3 DOWNTO 0); 
                elsif (anode_count = "01") then
                    DISPLAY <= WIRE1(3 DOWNTO 0); 
                elsif (anode_count = "10") then
                    DISPLAY <= WIRE2(3 DOWNTO 0);  
                else
                    DISPLAY <= SIGN & SIGN & "00";                
                end if;    
            end if;
        end if;    
    end process;
     
    
    
    
    process(CLK) begin
        if rising_edge(CLK) then         
            if (DISPLAY = 0) then
                CATHODE(6 downto 0) <= "1000000";
            elsif (DISPLAY = 1)then  
                CATHODE(6 downto 0) <= "1111001";
            elsif (DISPLAY = 2)then  
                CATHODE(6 downto 0) <= "0100100";
            elsif (DISPLAY = 3)then  
                CATHODE(6 downto 0) <= "0110000";
            elsif (DISPLAY = 4)then  
                CATHODE(6 downto 0) <= "0011001";
            elsif (DISPLAY = 5)then  
                CATHODE(6 downto 0) <= "0010010";
            elsif (DISPLAY = 6)then  
                CATHODE(6 downto 0) <= "0000010";
            elsif (DISPLAY = 7)then  
                CATHODE(6 downto 0) <= "1111000";
            elsif (DISPLAY = 8)then  
                CATHODE(6 downto 0) <= "0000000";
            elsif (DISPLAY = 9)then  
                CATHODE(6 downto 0) <= "0010000";	
            elsif (DISPLAY = 12) then
                CATHODE(6 downto 0) <= "0111111"; 
            else
                CATHODE(6 downto 0) <= "1111111";    
            end if;
        end if;  
    end process; 

end Behavioral;
