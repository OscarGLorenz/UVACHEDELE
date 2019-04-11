library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity adcbt is
  port (
    clk     : in  std_logic;
    reset   : in  std_logic;
    tx      : out std_logic;
    adc_rd  : out std_logic;
    adc_int : in  std_logic;
    leds : out std_logic_vector(7 downto 0);
    adc_db  : in  std_logic_vector(7 downto 0);
    adc_sel : out std_logic_vector(3 downto 0)
  );
end entity;

architecture Behavioral of adcbt is
  component sendhex
  port (
    clk     : in  std_logic;
    reset   : in  std_logic;
    qtr00 : in std_logic_vector(7 downto 0);
  	qtr01 : in std_logic_vector(7 downto 0);
  	qtr02 : in std_logic_vector(7 downto 0);
  	qtr03 : in std_logic_vector(7 downto 0);
  	qtr04 : in std_logic_vector(7 downto 0);
  	qtr05 : in std_logic_vector(7 downto 0);
  	qtr06 : in std_logic_vector(7 downto 0);
  	qtr07 : in std_logic_vector(7 downto 0);
  	qtr08 : in std_logic_vector(7 downto 0);
  	qtr09 : in std_logic_vector(7 downto 0);
  	qtr10 : in std_logic_vector(7 downto 0);
  	qtr11 : in std_logic_vector(7 downto 0);
  	qtr12 : in std_logic_vector(7 downto 0);
  	qtr13 : in std_logic_vector(7 downto 0);
  	qtr14 : in std_logic_vector(7 downto 0);
  	qtr15 : in std_logic_vector(7 downto 0);
    tx      : out std_logic
  );
  end component sendhex;
  component adc
  port (
    clk     : in  std_logic;
    reset   : in  std_logic;
    adc_rd  : out std_logic;
    adc_int : in  std_logic;
    adc_db  : in  std_logic_vector(7 downto 0);
    adc_sel : out std_logic_vector(3 downto 0);
    qtr00 : out std_logic_vector(7 downto 0);
  	qtr01 : out std_logic_vector(7 downto 0);
  	qtr02 : out std_logic_vector(7 downto 0);
  	qtr03 : out std_logic_vector(7 downto 0);
  	qtr04 : out std_logic_vector(7 downto 0);
  	qtr05 : out std_logic_vector(7 downto 0);
  	qtr06 : out std_logic_vector(7 downto 0);
  	qtr07 : out std_logic_vector(7 downto 0);
  	qtr08 : out std_logic_vector(7 downto 0);
  	qtr09 : out std_logic_vector(7 downto 0);
  	qtr10 : out std_logic_vector(7 downto 0);
  	qtr11 : out std_logic_vector(7 downto 0);
  	qtr12 : out std_logic_vector(7 downto 0);
  	qtr13 : out std_logic_vector(7 downto 0);
  	qtr14 : out std_logic_vector(7 downto 0);
  	qtr15 : out std_logic_vector(7 downto 0)
  );
  end component adc;

  signal qtr00   : std_logic_vector(7 downto 0);
  signal qtr01   : std_logic_vector(7 downto 0);
  signal qtr02   : std_logic_vector(7 downto 0);
  signal qtr03   : std_logic_vector(7 downto 0);
  signal qtr04   : std_logic_vector(7 downto 0);
  signal qtr05   : std_logic_vector(7 downto 0);
  signal qtr06   : std_logic_vector(7 downto 0);
  signal qtr07   : std_logic_vector(7 downto 0);
  signal qtr08   : std_logic_vector(7 downto 0);
  signal qtr09   : std_logic_vector(7 downto 0);
  signal qtr10   : std_logic_vector(7 downto 0);
  signal qtr11   : std_logic_vector(7 downto 0);
  signal qtr12   : std_logic_vector(7 downto 0);
  signal qtr13   : std_logic_vector(7 downto 0);
  signal qtr14   : std_logic_vector(7 downto 0);
  signal qtr15   : std_logic_vector(7 downto 0);

begin

  adcInstance : adc
  port map (
    clk     => clk,
    reset   => reset,
    adc_rd  => adc_rd,
    adc_int => adc_int,
    adc_db  => adc_db,
    adc_sel => adc_sel,
    qtr00   => qtr00,
    qtr01   => qtr01,
    qtr02   => qtr02,
    qtr03   => qtr03,
    qtr04   => qtr04,
    qtr05   => qtr05,
    qtr06   => qtr06,
    qtr07   => qtr07,
    qtr08   => qtr08,
    qtr09   => qtr09,
    qtr10   => qtr10,
    qtr11   => qtr11,
    qtr12   => qtr12,
    qtr13   => qtr13,
    qtr14   => qtr14,
    qtr15   => qtr15
  );

  sendhexInstance : sendhex
  port map (
    clk   => clk,
    reset => reset,
    qtr00 => qtr00,
    qtr01 => qtr01,
    qtr02 => qtr02,
    qtr03 => qtr03,
    qtr04 => qtr04,
    qtr05 => qtr05,
    qtr06 => qtr06,
    qtr07 => qtr07,
    qtr08 => qtr08,
    qtr09 => qtr09,
    qtr10 => qtr10,
    qtr11 => qtr11,
    qtr12 => qtr12,
    qtr13 => qtr13,
    qtr14 => qtr14,
    qtr15 => qtr15,
    tx => tx
  );

  leds <= qtr09;

end Behavioral;
