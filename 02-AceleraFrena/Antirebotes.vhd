library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
--library UNISIM;
--use UNISIM.VComponents.all;

entity Antirebotes is
 Port   (
            clk         :       in STD_LOGIC;
            reset       :       in STD_LOGIC;
            boton       :       in std_logic;
            filtrado    :       out std_logic
        );

end Antirebotes;

architecture Behavioral of Antirebotes is

        --FSM
        type state_t is (S_NADA, S_BOTON);
        signal state:   state_t;

        -- Clock period definitions
        constant Max      : integer := 1200-1;
        signal contador   : integer range 0 to Max;

        --Otras se�anles
        signal bs  :     std_logic;     -- Salida tras el segundo biestable
        signal bs_0:     std_logic;     -- Salida tras el primer biestable
        signal bs_3:     std_logic;     -- Salida tras el tercer biestable
        signal bs_3n:     std_logic;     -- Salida negada
        signal bf  :     std_logic;     -- Salida tras detector de flancos
        signal t   :     std_logic;     -- Lo que sale del temporizador
        signal e   :     std_logic;     -- Lo que entra al temporizador
        signal s   :     std_logic;     -- Salida (final)


begin
        --FSM
        process(clk, reset)
        begin
            if reset = '1' then
                state <= S_NADA;
            elsif clk'event and clk='1' then
                case state is
                    when S_NADA =>
                        if bf = '1' then
                            state <= S_BOTON;
                        end if;
                    when S_BOTON =>
                    if t = '1' then
                        state <= S_NADA;
                    end if;
                end case;
            end if;
        end process;

        e <= '1' when state = S_BOTON else '0';                                 --Moore
        s <= '1' when state = S_BOTON and bs = '1' and t = '1' else '0';        --Mealy

        --SINCRONIZADOR
        process(clk, reset)
        begin
            if reset = '1' then
                bs      <= '0';
                bs_0    <= '0';
            elsif clk'event and clk = '1' then
                    bs_0    <= boton;
                    bs      <= bs_0;
            end if;
        end process;

        --DETECTOR DE FLANCOS
        process(clk,reset)
        begin
                if reset = '1' then
                    bs_3 <= '0';
                elsif clk'event and clk = '1' then
                    bs_3 <= bs;
                    if bs_3 = '1' then
                        bs_3n <= '0';
                    else
                      bs_3n <= '1';
                    end if;
                end if;

            end process;
            bf <= bs_3n and bs;

            --TEMPORIZADOR
            process(clk,reset)
            begin
                if reset = '1' then
                elsif clk'event and clk = '1' then
                    if e = '0' then
                        contador <= 0;
                    elsif e = '1' then
                        contador <= contador + 1;
                    end if;
                end if;
            end process;
            t <= '1' when contador = Max-1 and e = '1' else '0';
            filtrado <= s;
end Behavioral;
