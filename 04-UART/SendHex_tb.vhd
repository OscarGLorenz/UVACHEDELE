library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb is
end tb;

architecture testbench of tb is
  component sendhex
  port (
    clk   : in  std_logic;
    reset : in  std_logic;
    tx    : out std_logic
  );
  end component sendhex;
  signal clk   : std_logic;
  signal reset : std_logic;
  signal tx    : std_logic;

  constant it : time := 8.3 ns;
begin
  sendhexi : sendhex
  port map (
    clk   => clk,
    reset => reset,
    tx    => tx
  );

  process begin
    clk<='1'; wait for it/2;
    clk<='0'; wait for it/2;
  end process;

  process begin
    reset<='0'; wait for 5*it;
    reset<='1'; wait for 200*it;
    reset<='0'; wait;
  end process;

end testbench;
