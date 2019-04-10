library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity error is
Port(
	-- System signals
	clk : in std_logic;
	reset : in std_logic;

	-- I/O
	adc_rd : out std_logic;  -- '0' = READ,  '1' = WAIT
	adc_int : in std_logic;  -- Falling edge means data ready
	adc_db : in std_logic_vector(7 downto 0); -- From adc
	adc_sel : out std_logic_vector(3 downto 0); -- To mux
	leds : out std_logic_vector(7 downto 0);
--  tx : out std_logic;
	ain1  : out std_logic;
	ain2  : out std_logic;
	bin1  : out std_logic;
	bin2  : out std_logic;
	pwmb  : out std_logic;

	pwma  : out std_logic
);
end error;

architecture Behavioural of error is

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

	signal err1 : unsigned(9 downto 0) := (others => '0');
  signal err2 : unsigned(9 downto 0) := (others => '0');

	signal act1 : unsigned(7 downto 0) := (others => '0');
  signal act2 : unsigned(7 downto 0) := (others => '0');

	component adc
  port (
    clk     : in  std_logic;
    reset   : in  std_logic;
    adc_rd  : out std_logic;
    adc_int : in  std_logic;
    adc_db  : in  std_logic_vector(7 downto 0);
    adc_sel : out std_logic_vector(3 downto 0);
    qtr00   : out std_logic_vector(7 downto 0);
    qtr01   : out std_logic_vector(7 downto 0);
    qtr02   : out std_logic_vector(7 downto 0);
    qtr03   : out std_logic_vector(7 downto 0);
    qtr04   : out std_logic_vector(7 downto 0);
    qtr05   : out std_logic_vector(7 downto 0);
    qtr06   : out std_logic_vector(7 downto 0);
    qtr07   : out std_logic_vector(7 downto 0);
    qtr08   : out std_logic_vector(7 downto 0);
    qtr09   : out std_logic_vector(7 downto 0);
    qtr10   : out std_logic_vector(7 downto 0);
    qtr11   : out std_logic_vector(7 downto 0);
    qtr12   : out std_logic_vector(7 downto 0);
    qtr13   : out std_logic_vector(7 downto 0);
    qtr14   : out std_logic_vector(7 downto 0);
    qtr15   : out std_logic_vector(7 downto 0)
  );
  end component adc;
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


	signal base  : std_logic_vector(7 downto 0) := x"10";
	signal ctrlA  : unsigned(7 downto 0);
	signal ctrlB  : unsigned(7 downto 0);


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

  process (clk,reset) begin
    if reset = '1' then

    elsif clk'event and clk='1' then
        err1 <= unsigned("00" & qtr02) + unsigned("00" & qtr03) + unsigned("00" & qtr04) + unsigned("00" & qtr05) + unsigned("00" & qtr06);
				err2 <= unsigned("00" & qtr08) + unsigned("00" & qtr09) + unsigned("00" & qtr10) + unsigned("00" & qtr11) + unsigned("00" & qtr12);

			--	act1 <=  base+err1(9 downto 2);
			--	act2 <=  base+err2(9 downto 2);

			--	ctrlA <= '0' & act1(7 downto 1);
			--	ctrlB <= '0' & act2(7 downto 1);
		end if;
  end process;

leds <= std_logic_vector(err1(9 downto 2) - err2(9 downto 2));

--leds(0) <= '1' when err1 > err2 else
--						'0';
ctrlA <= x"30" when err1 < err2 else x"10";
ctrlB <= x"30" when err1 > err2 else x"10";

end Behavioural;
