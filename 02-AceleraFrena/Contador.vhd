library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Contador is
 Port   (
            clk         :       in STD_LOGIC;
            reset       :       in STD_LOGIC;
            more       :       in std_logic;
            less    :       in std_logic;
            leds : out integer range 0 to 255
        );
end Contador;


architecture Behavioral of Contador is
signal count :  integer range 0 to 255;
begin
  process(clk,reset) begin
    if reset = '1' then
      count <= 0;
    elsif clk'event and clk = '1' then
      if more = '1' then
        if count /= 255 then
          count <= count + 1;
        end if;
      elsif less = '1' then
        if count /= 0 then
          count <= count - 1;
        end if;
      end if;
    end if;
  end process;

leds <= count;
end Behavioral;
