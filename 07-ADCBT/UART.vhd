library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uart is
	Port(
	-- System signals
	clk : in std_logic;
	reset : in std_logic;

	-- I/O
	tx  : out std_logic;											 -- Trasmmit UART

	-- Interface
	send : in std_logic; 											 -- Send byte
	busy : out std_logic; 										 -- Sending in process
	nextByte : in std_logic_vector(7 downto 0) -- Next byte to send
	);
end uart;

architecture Behavioural of uart is

	-- FSM States
	type state_t is (S_START, S_DATA, S_STOP, S_WAIT);
	signal state : state_t := S_WAIT;

	-- Actual bit of message
	signal bit_n : integer range 0 to 7 := 0;

	-- Clock div, to baudrate. 1250 = 12000000/9600
	constant baudCount : integer := 1250-1;
	signal counter : integer range 0 to baudCount;

	-- One clock duration pulse with 9600 baudrate
	signal clk_slow : std_logic := '0';

  -- Save byte to send. To avoid changes.
	signal bufferedByte : std_logic_vector(7 downto 0);

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

		-- FSM
		process(clk,reset) begin
			if reset = '1' then
				bit_n <= 0;
				state <= S_WAIT;
				busy <= '0';
			elsif clk'event and clk='1' then
				case state is

					-- Wait state, tx high, wait to send.
					-- Then jump to start, save byte and be busy.
					when S_WAIT =>
					tx <= '1';
					if send = '1' then
						bufferedByte <= nextByte;
						state <= S_START;
						busy <= '1';
					end if;

					-- Start trasmission bit, tx low. Then jump to data.
					when S_START =>
					if clk_slow = '1' then
						tx <= '0';
						state <= S_DATA;
					end if;

					-- Trasmmit data. 8 bits have to be trasmmited. Then jump to stop.
					when S_DATA =>
					if clk_slow = '1' then
						if bit_n = 7 then
							bit_n <=  0;
							state <= S_STOP;
						else
							bit_n <= bit_n + 1;
						end if;
						tx <= bufferedByte(bit_n);
					end if;

					-- Stop bit, tx high. Not busy anymore and jump to wait.
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
