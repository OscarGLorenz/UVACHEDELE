library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sendhex is
  Port(
  -- System signals
  clk : in std_logic;
  reset : in std_logic;

  -- Data from ADC
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

  -- I/O
  tx : out std_logic
  );
end sendhex;


architecture Behavioural of sendhex is
  component uart
  port (
  clk   : in  std_logic;
  reset : in  std_logic;
  tx    : out std_logic;
  send  : in  std_logic;
  busy : out std_logic;
  nextByte  : in  std_logic_vector(7 downto 0)
  );
end component uart;

-- Interconnect signals
signal send  : std_logic;
signal nextByte  : std_logic_vector(7 downto 0);
signal busy : std_logic;

-- Constants for line feed and space
constant LF : std_logic_vector(7 downto 0) := x"0A";
constant SP : std_logic_vector(7 downto 0) := x"20";

-- FSM States
type state_t is (S_WAIT, S_BYTE1, S_WAIT1, S_BYTE2, S_WAIT2, S_LF);
signal state : state_t := S_WAIT;

-- Index to see all 16 sensors
signal index : unsigned(3 downto 0) := (others => '0');

-- Aux buffer to store data
signal aux : std_logic_vector(7 downto 0);

  begin
    uartMod : uart
    port map (
    clk   => clk,
    reset => reset,
    tx    => tx,
    send  => send,
    busy => busy,
    nextByte  => nextByte
    );

    process (clk, reset) begin
      if reset = '1' then
        state <= S_BYTE1;
        index <= (others => '0');
      elsif clk'event and clk='1' then
        case state is

          -- Wait until UART is not busy
          when S_WAIT =>
          send <= '0';
          if busy='0' then
            state <= S_BYTE1;
          end if;

          -- Send first hex digit when not busy
          when S_BYTE1 =>
          if busy='0' then
            -- ASCII conversion
            case aux(7 downto 4) is
              when x"0" => nextByte <= x"30";
              when x"1" => nextByte <= x"31";
              when x"2" => nextByte <= x"32";
              when x"3" => nextByte <= x"33";
              when x"4" => nextByte <= x"34";
              when x"5" => nextByte <= x"35";
              when x"6" => nextByte <= x"36";
              when x"7" => nextByte <= x"37";
              when x"8" => nextByte <= x"38";
              when x"9" => nextByte <= x"39";
              when x"A" => nextByte <= x"41";
              when x"B" => nextByte <= x"42";
              when x"C" => nextByte <= x"43";
              when x"D" => nextByte <= x"44";
              when x"E" => nextByte <= x"45";
              when x"F" => nextByte <= x"46";
              when others => nextByte <= x"00";
            end case;
            send <= '1';
            state <= S_WAIT1;
          else
            send <= '0';
          end if;

          -- Wait until not busy
          when S_WAIT1 =>
            if busy='0' then
              state <= S_BYTE2;
            end if;

          -- Send second hex digit when not busy
          when S_BYTE2 =>
          if busy='0' then
            case aux(3 downto 0) is
              when x"0" => nextByte <= x"30";
              when x"1" => nextByte <= x"31";
              when x"2" => nextByte <= x"32";
              when x"3" => nextByte <= x"33";
              when x"4" => nextByte <= x"34";
              when x"5" => nextByte <= x"35";
              when x"6" => nextByte <= x"36";
              when x"7" => nextByte <= x"37";
              when x"8" => nextByte <= x"38";
              when x"9" => nextByte <= x"39";
              when x"A" => nextByte <= x"41";
              when x"B" => nextByte <= x"42";
              when x"C" => nextByte <= x"43";
              when x"D" => nextByte <= x"44";
              when x"E" => nextByte <= x"45";
              when x"F" => nextByte <= x"46";
              when others => nextByte <= x"00";
            end case;
            send <= '1';
            state <= S_WAIT2;
          else
            send <= '0';
          end if;

          -- Wait until not busy
          when S_WAIT2 =>
            if busy='0' then
              state <= S_LF;
            end if;

          -- Send a space or a line feed at end of line
          when S_LF =>
          if busy='0' then
            if (index = 15) then
              nextByte <= LF;
              index <= (others => '0');
            else
              nextByte <= SP;
              index <= index + 1;
            end if;
            send <= '1';
            state <= S_WAIT;
          else
            send <= '0';
          end if;

        end case;

      end if;
    end process;

    -- Demultiplexer to access data
    with index select aux <=
    					qtr00 when x"0",
    					qtr01 when x"1",
    					qtr02 when x"2",
    					qtr03 when x"3",
    					qtr04 when x"4",
    					qtr05 when x"5",
    					qtr06 when x"6",
    					qtr07 when x"7",
    					qtr08 when x"8",
    					qtr09 when x"9",
    					qtr10 when x"A",
    					qtr11 when x"B",
    					qtr12 when x"C",
    					qtr13 when x"D",
    					qtr14 when x"E",
    					qtr15 when x"F",
    					x"00" when others;
  end Behavioural;
