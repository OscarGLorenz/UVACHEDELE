library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb is
end tb;

architecture TEST of tb is
  component adcbt
  port (
  clk     : in  std_logic;
  reset   : in  std_logic;
  tx      : out std_logic;
  adc_rd  : out std_logic;
  adc_int : in  std_logic;
  adc_db  : in  std_logic_vector(7 downto 0);
  adc_sel : out std_logic_vector(3 downto 0)
  );
end component adcbt;

signal clk     : std_logic;
signal reset   : std_logic;
signal tx      : std_logic;
signal adc_rd  : std_logic;
signal adc_int : std_logic;
signal adc_db  : std_logic_vector(7 downto 0);
signal adc_sel : std_logic_vector(3 downto 0);

constant it : time := 83.3 ns;
begin

  -- clk
  process begin
    clk<='1'; wait for it/2;
    clk<='0'; wait for it/2;
  end process;

  -- Reset
  process begin
    reset<='0'; wait for 5*it;
    reset<='1'; wait for 20*it;
    reset<='0'; wait;
  end process;

  -- Simulate adc behaviour
  process(clk) begin
    if clk'event and clk='1' then
      if adc_rd = '0' then
        adc_int <= '0';
      else
        adc_int <= '1';
      end if;
    end if;
  end process;

  -- Example data from adc
  adc_db <= adc_sel & x"0";

  adcbtInstance : adcbt
  port map (
  clk     => clk,
  reset   => reset,
  tx      => tx,
  adc_rd  => adc_rd,
  adc_int => adc_int,
  adc_db  => adc_db,
  adc_sel => adc_sel
  );



end TEST;
