---libarries
library ieee; 
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity WateringSystem is
Port( 
      RESET: in std_logic; ---input
      Clk  : in std_logic; ---input
      L, T : in std_logic; ---inputs
      M    : in std_logic_vector(2 downto 0);  ---input(have 3 bits)
      STATE: out std_logic_vector(1 downto 0); ---output(have 2 bits, for example 00)
      SEG  : out std_logic_vector(6 downto 0); ---output(have 7 bits)
      light, temperature: out std_logic;       ---output
      moisture: out std_logic_vector(2 downto 0); ---output(have 3 bits)
      OUTPUT: out std_logic ---output
);
end entity WateringSystem;


architecture behavioral of WateringSystem is
 signal current_state, next_state: std_logic_vector(1 downto 0):= "11"; ---signal decleration

  begin
    REG: process(CLK, RESET)
     begin
      if RESET = '1' then
       STATE <= "11";
       current_state <= "11";
      elsif CLK'event and CLK = '1' then 
        current_state <= next_state;
        STATE <= next_state;
        light <= L;
        temperature <= T;
        moisture <= M;
      end if;
    end process REG;

  Process2: process(current_state)
   begin
   if current_state = "00" or current_state = "11" then
     SEG <= "1000000";--- -
   else
     SEG <= "1110110";---H
   end if;
  end process Process2;


  Process3: process(current_state)
    begin
    if current_state = "01" then
     OUTPUT <= '1';
    else
     OUTPUT <= '0';
    end if;
  end process Process3;
 
   
   process4: process(L, T, M, current_state)
    begin
    case current_state is
     When "11" | "00" =>
       if T = '0' and L = '0' then
          if M(2) = '1' then
            next_state <= "00";
          else
            next_state <= "01";
          end if;
       else
          if M(2) = '0' and M(1) = '0' then
             next_state <= "01";
          else
             next_state <= "00";
          end if;
       end if;
     
     When "01"=>
       if T = '0' and L = '0' then
          case M is 
            When "111" =>
              next_state <= "00";
            When others =>
              next_state <= "01";
          end case;
       else
         if M(2) = '1' or (M(1) = '1' and M(0) = '1') then
               next_state <= "00";
          else
               next_state <= "01";
          end if;
       end if;

    When others =>
       next_state <= "00";

    end case;
  end process process4;
       
      

end architecture behavioral; 
   
