library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb is
end tb;


architecture test of tb is
  component pwm
  port (
    clk   : in  std_logic;
    reset : in  std_logic;
    ctrlA : in  unsigned (7 downto 0);
    ctrlB : in  unsigned (7 downto 0);
    ain1  : out std_logic;
    ain2  : out std_logic;
    bin1  : out std_logic;
    bin2  : out std_logic;
    pwmb  : out std_logic;
    pwma  : out std_logic
  );
  end component pwm;

  signal clk   : std_logic;
  signal reset : std_logic;
  signal ctrlA : unsigned (7 downto 0);
  signal ctrlB : unsigned (7 downto 0);
  signal ain1  : std_logic;
  signal ain2  : std_logic;
  signal bin1  : std_logic;
  signal bin2  : std_logic;
  signal pwmb  : std_logic;
  signal pwma  : std_logic;

  constant it : time := 83.3 ns;
begin
  process begin
    clk<='1'; wait for it/2;
    clk<='0'; wait for it/2;
  end process;
  process begin
    reset<='0'; wait for 5*it;
    reset<='1'; wait for 20*it;
    reset<='0'; wait;
  end process;

  driver : pwm
  port map (
    clk   => clk,
    reset => reset,
    ctrlA => ctrlA,
    ctrlB => ctrlB,
    ain1  => ain1,
    ain2  => ain2,
    bin1  => bin1,
    bin2  => bin2,
    pwmb  => pwmb,
    pwma  => pwma
  );
ctrlA <= x"80";
ctrlB <= x"20";

end test;
