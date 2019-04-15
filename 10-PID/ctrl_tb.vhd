library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb is
end tb;

architecture TEST of tb is
  component error
  port (
    clk     : in  std_logic;
    reset   : in  std_logic;
    adc_rd  : out std_logic;
    adc_int : in  std_logic;
    adc_db  : in  std_logic_vector(7 downto 0);
    adc_sel : out std_logic_vector(3 downto 0);
    leds    : out std_logic_vector(7 downto 0);
    ain1    : out std_logic;
    ain2    : out std_logic;
    bin1    : out std_logic;
    bin2    : out std_logic;
    pwmb    : out std_logic;
    pwma    : out std_logic
  );
  end component error;


  signal clk     : std_logic;
  signal reset   : std_logic;
  signal adc_rd  : std_logic;
  signal adc_int : std_logic;
  signal adc_db  : std_logic_vector(7 downto 0);
  signal adc_sel : std_logic_vector(3 downto 0);
  signal leds    : std_logic_vector(7 downto 0);
  signal ain1    : std_logic;
  signal ain2    : std_logic;
  signal bin1    : std_logic;
  signal bin2    : std_logic;
  signal pwmb    : std_logic;
  signal pwma    : std_logic;
  signal actual_mux : std_logic_vector(3 downto 0);

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

  with adc_sel select actual_mux <=
  					x"0" when x"7",
  					x"1" when x"6",
  					x"2" when x"5",
  					x"3" when x"4",
  					x"4" when x"3",
  					x"5" when x"2",
  					x"6" when x"1",
  					x"7" when x"0",
  					x"8" when x"D",
  					x"9" when x"C",
  					x"A" when x"B",
  					x"B" when x"A",
  					x"C" when x"9",
  					x"D" when x"8",
  					x"E" when x"F",
  					x"F" when x"E",
  					x"0" when others;

with actual_mux select adc_db <=
            x"00" when x"0",  -- LL0
            x"00" when x"1",  -- LL1
            x"00" when x"2",  -- L0
            x"FF" when x"3",  -- L1
            x"00" when x"4",  -- L2
            x"00" when x"5",  -- L3
            x"00" when x"6",  -- L4
            x"00" when x"7",  -- LF0
            x"00" when x"8",  -- L5
            x"00" when x"9",  -- L6
            x"00" when x"A",  -- L7
            x"00" when x"B",  -- L8
            x"FF" when x"C",  -- L9
            x"00" when x"D",  -- LR0
            x"00" when x"E",  -- LR1
            x"00" when x"F",  -- LB0
            x"00" when others;


  nucelar : error
  port map (
    clk     => clk,
    reset   => reset,
    adc_rd  => adc_rd,
    adc_int => adc_int,
    adc_db  => adc_db,
    adc_sel => adc_sel,
    leds    => leds,
    ain1    => ain1,
    ain2    => ain2,
    bin1    => bin1,
    bin2    => bin2,
    pwmb    => pwmb,
    pwma    => pwma
  );



end TEST;
