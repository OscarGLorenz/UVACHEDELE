library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity adc is
Port(
	-- System signals
	clk : in std_logic;
	reset : in std_logic;

	-- I/O
	adc_rd : out std_logic;  -- '0' = READ,  '1' = WAIT
	adc_int : in std_logic;  -- Falling edge means data ready
	adc_db : in std_logic_vector(7 downto 0); -- From adc
	adc_sel : out std_logic_vector(3 downto 0); -- To mux

	-- ADC data from each sensor
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
end adc;

architecture Behavioural of adc is
	-- FSM states
	type state_t is (S_START, S_NOP, S_READ, S_WAIT);
	signal state : state_t := S_WAIT;

	-- Counter for delay between readings
	signal counter : unsigned(2 downto 0) := (others => '0');

	-- Mux
	signal mux : unsigned(3 downto 0) := (others => '0');

	-- Mux with corrected order
	signal actual_mux : std_logic_vector(3 downto 0);

begin
	process(clk,reset) begin
		if reset = '1' then
			counter <= (others => '0');
			state <= S_WAIT;
			adc_rd <= '1';
			mux <= (others => '0');
		elsif clk'event and clk='1' then

			-- Start reading, wait until reading is done
			if state = S_START then
				adc_rd <= '0';
				if adc_int = '0' then
					state <= S_NOP;
				end if;

			-- Data ready, wait a clock cycle
			elsif state = S_NOP then
				state <= S_READ;

			-- Read data and store with corrected order
			elsif state <= S_READ then
				state <= S_WAIT;
				case actual_mux is
					when x"0" => qtr00 <= adc_db;
					when x"1" => qtr01 <= adc_db;
					when x"2" => qtr02 <= adc_db;
					when x"3" => qtr03 <= adc_db;
					when x"4" => qtr04 <= adc_db;
					when x"5" => qtr05 <= adc_db;
					when x"6" => qtr06 <= adc_db;
					when x"7" => qtr07 <= adc_db;
					when x"8" => qtr08 <= adc_db;
					when x"9" => qtr09 <= adc_db;
					when x"A" => qtr10 <= adc_db;
					when x"B" => qtr11 <= adc_db;
					when x"C" => qtr12 <= adc_db;
					when x"D" => qtr13 <= adc_db;
					when x"E" => qtr14 <= adc_db;
					when x"F" => qtr15 <= adc_db;
					when others => qtr00 <= (others => '0');
				end case;

			-- Wait until next reading, as ADC datasheet says
			elsif state = S_WAIT then
				adc_rd <= '1';
				if counter = 7 then
					mux <= mux + 1; -- Change mux
					state <= S_START;
					counter <= (others => '0');
				else
					counter <= counter + 1;
				end if;
			end if;

		end if;
	end process;

-- Decodifier for correcting mux
with mux select actual_mux <=
					x"0" when x"8", -- :D
					x"1" when x"7", -- :D
					x"2" when x"6", -- :D
					x"3" when x"5", -- :D
					x"4" when x"4", -- :D
					x"5" when x"3", -- :D
					x"6" when x"2", -- :D
					x"7" when x"1", -- :D
					x"8" when x"E", -- :D
					x"9" when x"D", -- :D
					x"A" when x"C", -- :D
					x"B" when x"B", -- :D
					x"C" when x"A", -- :D
					x"D" when x"9", -- :D
					x"E" when x"0", -- :D
					x"F" when x"F", -- :D
					x"0" when others;

adc_sel <= std_logic_vector(mux);

end Behavioural;
