library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tesb is
end tesb;

architecture tb of tesb is

  component AceleraFrena
  port (
    clk   : in  STD_LOGIC;
    reset : in  STD_LOGIC;
    sw1   : in  std_logic;
    sw2   : in  std_logic;
    bin1  : out std_logic;
    bin2  : out std_logic;
    pwmb  : out std_logic
      );
  end component AceleraFrena;

  signal clk   : STD_LOGIC;
  signal reset : STD_LOGIC;
  signal sw1   : std_logic;
  signal sw2   : std_logic;
  signal bin1  : std_logic;
  signal bin2  : std_logic;
  signal pwmb  : std_logic;
  signal leds  :integer range 0 to 255;

  constant it : time := 8 ns;
begin
  AceleraFrena_i : AceleraFrena
  port map (
    clk   => clk,
    reset => reset,
    sw1   => sw1,
    sw2   => sw2,
    bin1  => bin1,
    bin2  => bin2,
    pwmb  => pwmb
  );


  process begin
    reset <= '1';
    wait for it;
    reset <= '0';
    wait;
  end process;

  process begin
    clk <= '1';
    wait for it;
    clk <= '0';
    wait for it;
  end process;

  process begin

    sw1 <= '1';
    wait for 100*it;
    sw1 <= '0';
    wait for 100*it;


  end process;



end tb;
