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
	tx : out std_logic;
	ain1  : out std_logic;
	ain2  : out std_logic;
	bin1  : out std_logic;
	bin2  : out std_logic;
	pwmb  : out std_logic;

	pwma  : out std_logic
	);
end error;

architecture Behavioural of error is
	-- modiifica
	constant putensia : unsigned(7 downto 0) := x"20";
	constant putensiaMaxima : unsigned(7 downto 0) := x"40";
	constant Kp : std_logic_vector(7 downto 0) := x"30";
	-- modiifica

	signal l0   : unsigned(7 downto 0);
	signal l1   : unsigned(7 downto 0);
	signal l2   : unsigned(7 downto 0);
	signal l3   : unsigned(7 downto 0);
	signal l4   : unsigned(7 downto 0);
	signal l5   : unsigned(7 downto 0);
	signal l6   : unsigned(7 downto 0);
	signal l7   : unsigned(7 downto 0);
	signal l8   : unsigned(7 downto 0);
	signal l9   : unsigned(7 downto 0);

	signal err1 : unsigned(9 downto 0) := (others => '0');
	signal err2 : unsigned(9 downto 0) := (others => '0');
	signal err  : signed(10 downto 0)  := (others => '0');

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

signal ctrlA  : unsigned(7 downto 0)  := (others => '0');
signal ctrlB  : unsigned(7 downto 0)  := (others => '0');
component pwm
port (
clk   : in  std_logic;
reset : in  std_logic;
ctrlA : in  unsigned (7 downto 0);
ctrlB : in  unsigned (7 downto 0);
max 	: in 	unsigned (7 downto 0);
ain1  : out std_logic;
ain2  : out std_logic;
bin1  : out std_logic;
bin2  : out std_logic;
pwmb  : out std_logic;
pwma  : out std_logic
);
end component pwm;
component sendhex
port (
clk   : in  std_logic;
reset : in  std_logic;
err   : in  signed(10 downto 0);
tx    : out std_logic
);
end component sendhex;

signal number     : signed(10 downto 0);
signal outrut     : signed(10 downto 0);
component fixed
port (
number     : in  signed(10 downto 0);
multiplier : in  std_logic_vector(7 downto 0);
outrut     : out signed(10 downto 0)
);
end component fixed;

begin
	leds <= Kp;

	process (clk,reset) begin
		if reset = '1' then
			err1 <= (others => '0');
			err2 <= (others => '0');
			err <= (others => '0');
		elsif clk'event and clk='1' then
			l0 <= unsigned(qtr02);
			l1 <= unsigned("0" & qtr03(7 downto 1)) + unsigned("00" & qtr03(7 downto 2)) + unsigned("000" & qtr03(7 downto 3));
			l2 <= unsigned("0" & qtr04(7 downto 1)) + unsigned("00" & qtr04(7 downto 2));
			l3 <= unsigned("0" & qtr05(7 downto 1));
			l4 <= unsigned("00" & qtr06(7 downto 2)) + unsigned("000" & qtr06(7 downto 3));
			l5 <= unsigned("00" & qtr08(7 downto 2)) + unsigned("000" & qtr08(7 downto 3));
			l6 <= unsigned("0" & qtr09(7 downto 1));
			l7 <= unsigned("0" & qtr10(7 downto 1)) + unsigned("00" & qtr10(7 downto 2));
			l8 <= unsigned("0" & qtr11(7 downto 1)) + unsigned("00" & qtr11(7 downto 2)) + unsigned("000" & qtr11(7 downto 3));
			l9 <= unsigned(qtr12);


			err1 <= ("00" & l0) + ("00" & l1) + ("00" & l2) + ("00" & l3) + ("00" & l4);
			err2 <= ("00" & l5) + ("00" & l6) + ("00" & l7) + ("00" & l8) + ("00" & l9);
			err <= signed('0' & err1) - signed('0' & err2);

			if outrut > 0 then
				ctrlB <= putensia + outrut;
				ctrlA <= putensia;
			else
				ctrlA <= putensia + (not (outrut-1));
				ctrlB <= putensia;
			end if;

		end if;
	end process;

	FixedEntity : fixed
	port map (
	number     => err,
	multiplier => Kp,
	outrut     => outrut
	);

	sendhexInstance : sendhex
	port map (
	clk   => clk,
	reset => reset,
	err   => outrut,
	tx    => tx
	);

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
	max		=> putensiaMaxima,
	ain1  => ain1,
	ain2  => ain2,
	bin1  => bin1,
	bin2  => bin2,
	pwmb  => pwmb,
	pwma  => pwma
	);

end Behavioural;
