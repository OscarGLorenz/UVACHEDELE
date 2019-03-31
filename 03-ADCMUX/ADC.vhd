library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity adc is
Port(
	clk : in std_logic;
	reset : in std_logic;

	adc_rd : out std_logic;  -- '0' = LEER,  '1' = WAIT
	adc_int : in std_logic;  -- Flanco de bajada => lectura lista

	adc_db : in std_logic_vector(7 downto 0); -- Del ADC
	adc_sel : out std_logic_vector(3 downto 0); -- Del mux

	leds : out std_logic_vector(7 downto 0) -- Del ADC
);
end adc;

architecture Behavioural of adc is
	type state_t is (S_START, S_NOP, S_READ, S_WAIT);
	signal state : state_t := S_START;
	signal counter : integer range 0 to 6 := 0;
	signal mux : unsigned(15 downto 0);
	signal index : integer range 0 to 127 ;
	signal data : std_logic_vector(127 downto 0) ;-- Data
begin
	process(clk,reset) begin
		if reset = '1' then
			counter <= 0;
			state <= S_START;
			adc_rd <= '1';
			mux <= (others => '0');
			index <= 0;
		elsif clk'event and clk='1' then

			-- Comenzar lectura, esperar a que termine
			if state = S_START then
				adc_rd <= '0';
				if adc_int = '0' then
					state <= S_NOP;
				end if;

			-- Lectura terminada, esperar un ciclo de reloj
			elsif state = S_NOP then
				state <= S_READ;

			-- Leer datos
			elsif state <= S_READ then
				data(index+7 downto index) <= adc_db;
				state <= S_WAIT;

			-- Terminar lectura esperar 500ns para volver a empezar
			elsif state = S_WAIT then
				adc_rd <= '1';
				counter <= counter + 1;
				if counter = 6 then
					state <= S_START;
					counter <= 0;
					if mux = 15 then
						mux <= (others => '0');
						index <= 0;
					else
						mux <= mux + 1;
						index <= index + 8;
					end if;
				end if;
			end if;

		end if;
	end process;

adc_sel <= std_logic_vector(mux);
leds <= data(7 downto 0);

end Behavioural;
