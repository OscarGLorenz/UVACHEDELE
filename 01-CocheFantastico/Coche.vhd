library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Coche is
  Port(
    clk : in std_logic;
    reset : in std_logic;
    leds : out std_logic_vector(7 downto 0)
  );
end Coche;

architecture Behavioural of Coche is

  signal state : std_logic_vector(7 downto 0);
  constant maxCount : integer := 857143;
  signal counter : integer range 0 to maxCount;

  signal nextLed : std_logic ;

  signal dir  : std_logic ;
begin

  process(clk, reset) begin
    if reset = '1' then
      counter <= 0;
      nextLed <= '0';
    elsif clk'event and clk = '1' then
      if counter = maxCount then
        counter <= 0;
        nextLed <= '1';
      else
        counter <= counter + 1;
        nextLed <= '0';
      end if;
    end if;
  end process;

  process (clk,reset) begin
  -- Registro desplazamiento (limpio)

      if reset = '1' then
          state <= "00000001";
          dir <= '0';
      elsif clk'event and clk = '1' then
        if nextLed = '1' then
      --PARRIBA--
           if    state >= "00000001" and state < "10000000" and dir = '0' then
                 state <= state((7-1) downto 0) & '0';                                                                                        -- reg = reg << 1
           elsif state  = "10000000" and dir = '0' then
                 state <= '0' & state(7 downto 1);                                                                                            -- reg = reg >> 1
                 dir <= '1';
       --PABAJO--
           elsif state  > "00000001" and state <= "10000000"  and dir = '1' then
                 state <= '0' & state(7 downto 1);                                                                                            -- reg = reg << 1
           elsif state  = "00000001" and dir = '1' then
                 state <= state((7-1) downto 0) & '0';                                                                                        -- reg = reg >> 1
                 dir <= '0';
            end if;
          end if;
       end if;
  end process;

  leds <= state;


end Behavioural;
