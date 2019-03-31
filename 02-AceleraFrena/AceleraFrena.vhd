library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity AceleraFrena is
        Port   (
        clk   : in STD_LOGIC;
        reset : in STD_LOGIC;
        sw1   : in std_logic;
        sw2   : in std_logic;
        bin1 : out std_logic;
        bin2 : out std_logic;
        pwmb : out std_logic;
        leds : out integer range 0 to 255
               );
end AceleraFrena;

architecture Behavioural of AceleraFrena is

  signal more     : std_logic;
  signal less     : std_logic;

  constant upTo : integer := 5;
  signal count : integer range 0 to upTo;

  signal ramp : integer range 0 to 255;
  signal value :  integer range 0 to 255;

component Antirebotes
port (
  clk      : in  STD_LOGIC;
  reset    : in  STD_LOGIC;
  boton    : in  std_logic;
  filtrado : out std_logic
);
end component Antirebotes;

component Contador
port (
  clk   : in  STD_LOGIC;
  reset : in  STD_LOGIC;
  more  : in  std_logic;
  less  : in  std_logic;
  leds : out integer range 0 to 255
);
end component Contador;


begin

Add : Antirebotes
port map (
  clk      => clk,
  reset    => reset,
  boton    => sw1,
  filtrado => more
);

Sub : Antirebotes
port map (
  clk      => clk,
  reset    => reset,
  boton    => sw2,
  filtrado => less
);

Contadori : Contador
port map (
 clk   => clk,
  reset => reset,
  more  => more,
  less  => less,
  leds  => value
);

process (clk, reset) begin
  if reset = '1' then
    ramp <= 0;
  elsif clk'event and clk = '1' then
      if ramp = 255 then
        ramp <= 0;
      else
        ramp <= ramp + 1;
      end if;
  end if;
end process;

pwmb <= '1' when ramp < value else '0';
bin1 <= '0';
bin2 <= '1';

value <= leds;

end Behavioural;
