library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uart is
	Port(
	clk : in std_logic;
	reset : in std_logic;
	tx  : out std_logic;
	send : in std_logic;
	busy : out std_logic;

	data : in std_logic_vector(7 downto 0)
	);
end uart;

architecture Behavioural of uart is

	type state_t is (S_START, S_DATA, S_STOP, S_WAIT);
	signal state : state_t := S_WAIT;

	signal bit_n : integer range 0 to 7 := 0;

	constant baudCount : integer := 1250-1;
	signal counter : integer range 0 to baudCount;

	signal clk_slow : std_logic;

	begin

		-- Frec div 9600baud
		process(clk,reset) begin
			if reset = '1' then
				counter <= 0;
			elsif clk'event and clk='1' then
				if counter = baudCount then
					counter <= 0;
					clk_slow <= '1';
				else
					counter <= counter + 1;
					clk_slow <= '0';
				end if;

			end if;
		end process;

		-- fsm
		process(clk,reset) begin
			if reset = '1' then
				bit_n <= 0;
				state <= S_WAIT;
				busy <= '0';
			elsif clk'event and clk='1' then
				case state is
					when S_WAIT =>
						tx <= '1';
						if send = '1' then
							state <= S_START;
							busy <= '1';
						end if;

					when S_START =>
						if clk_slow = '1' then
							tx <= '0';
							state <= S_DATA;
						end if;

					when S_DATA =>
						if clk_slow = '1' then
							if bit_n = 7 then
								bit_n <= 0;
								state <= S_STOP;
							else
								bit_n <= bit_n + 1;
							end if;

							tx <= data(bit_n);
						end if;

					when S_STOP =>
						if clk_slow = '1' then
							tx <= '1';
							state <= S_WAIT;
							busy <= '0';
						end if;

					end case;
			end if;
		end process;


	end Behavioural;
