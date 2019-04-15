library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pwm is
  port(
    clk : in std_logic;
    reset : in std_logic;
    ctrlA : in unsigned (7 downto 0);
    ctrlB : in unsigned (7 downto 0);
    max : in unsigned (7 downto 0);
    ain1 : out std_logic;
    ain2 : out std_logic;
    bin1 : out std_logic;
    bin2 : out std_logic;
    pwmb : out std_logic;
    pwma : out std_logic
  );
end pwm;

architecture uvachedele of pwm is
signal counter : unsigned(2 downto 0) := (others => '0');
signal ramp : unsigned(7 downto 0) := (others => '0');
signal capadoA : unsigned (7 downto 0);
signal capadoB : unsigned (7 downto 0);

begin
process (clk,reset) begin
  if reset = '1' then
    counter <= (others => '0');
  elsif clk'event and clk='1' then
    if (counter = 5) then
      counter <= (others => '0');
    else
      counter <= counter + 1;
    end if;
  end if;
end process;

process (clk,reset) begin
  if reset = '1' then
    ramp <= (others => '0');
  elsif clk'event and clk='1' then
    if (counter = 5) then
      if (ramp = 254) then
        ramp <= (others => '0');
      else
        ramp <= ramp + 1;
      end if;
    end if;
  end if;
end process;

capadoA <= ctrlA when ctrlA < max else max;
capadoB <= ctrlB when ctrlB < max else max;

pwma <= '1' when ramp < capadoA else '0';
pwmb <= '1' when ramp < capadoB else '0';

ain1 <= '0'; ain2 <= '1';
bin1 <= '1'; bin2 <= '0';

end uvachedele;
