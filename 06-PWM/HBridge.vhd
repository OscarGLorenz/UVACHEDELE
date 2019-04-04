library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity HBridge is
  port(
  clk   : in  std_logic;
  reset : in  std_logic;
  ain1  : out std_logic;
  ain2  : out std_logic;
  bin1  : out std_logic;
  bin2  : out std_logic;
  pwmb  : out std_logic;
  pwma  : out std_logic
  );
end HBridge;

architecture Behavioural of HBridge is
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

begin
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

end Behavioural;
