library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sendhex is
  Port(
  clk : in std_logic;
  reset : in std_logic;
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
  data  : in  std_logic_vector(7 downto 0)
  );
end component uart;

signal send  : std_logic;
signal data  : std_logic_vector(7 downto 0);
signal busy : std_logic;

signal hexData  : std_logic_vector(7 downto 0) := x"8A";
constant LF : std_logic_vector(7 downto 0) := x"0A";

type state_t is (S_WAIT, S_BYTE1, S_WAIT1, S_BYTE2, S_WAIT2, S_LF);
signal state : state_t := S_WAIT;




  begin
    uartMod : uart
    port map (
    clk   => clk,
    reset => reset,
    tx    => tx,
    send  => send,
    busy => busy,
    data  => data
    );

    process (clk, reset) begin
      if reset = '1' then
        state <= S_BYTE1;
      elsif clk'event and clk='1' then
        case state is
          when S_WAIT =>
          send <= '0';

          when S_BYTE1 =>
          if busy='0' then
            case hexData(7 downto 4) is
              when x"0" => data <= x"30";
              when x"1" => data <= x"31";
              when x"2" => data <= x"32";
              when x"3" => data <= x"33";
              when x"4" => data <= x"34";
              when x"5" => data <= x"35";
              when x"6" => data <= x"36";
              when x"7" => data <= x"37";
              when x"8" => data <= x"38";
              when x"9" => data <= x"39";
              when x"A" => data <= x"41";
              when x"B" => data <= x"42";
              when x"C" => data <= x"43";
              when x"D" => data <= x"44";
              when x"E" => data <= x"45";
              when x"F" => data <= x"46";
              when others => data <= x"00";
            end case;
            send <= '1';
            state <= S_WAIT1;
          else
            send <= '0';
          end if;
          when S_WAIT1 =>
            if busy='0' then
              state <= S_BYTE2;
            end if;

          when S_BYTE2 =>
          if busy='0' then
            case hexData(3 downto 0) is
              when x"0" => data <= x"30";
              when x"1" => data <= x"31";
              when x"2" => data <= x"32";
              when x"3" => data <= x"33";
              when x"4" => data <= x"34";
              when x"5" => data <= x"35";
              when x"6" => data <= x"36";
              when x"7" => data <= x"37";
              when x"8" => data <= x"38";
              when x"9" => data <= x"39";
              when x"A" => data <= x"41";
              when x"B" => data <= x"42";
              when x"C" => data <= x"43";
              when x"D" => data <= x"44";
              when x"E" => data <= x"45";
              when x"F" => data <= x"46";
              when others => data <= x"00";
            end case;
            send <= '1';
            state <= S_WAIT2;
          else
            send <= '0';
          end if;

          when S_WAIT2 =>
            if busy='0' then
              state <= S_LF;
            end if;

          when S_LF =>
          if busy='0' then
            data <= LF;
            send <= '1';
            state <= S_WAIT;
          else
            send <= '0';
          end if;

        end case;

      end if;
    end process;

  end Behavioural;
