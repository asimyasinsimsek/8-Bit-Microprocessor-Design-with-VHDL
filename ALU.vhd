library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity ALU is
	port(
			A 			: in std_logic_vector(7 downto 0);
			B 			: in std_logic_vector(7 downto 0);
			ALU_Sel 	: in std_logic_vector(2 downto 0); -- Islem Turu
			-- Output:
			NZVC		: out std_logic_vector(3 downto 0);
			alu_result 	: out std_logic_vector(7 downto 0)
	);
end ALU;

architecture arch of ALU is

signal sum_unsigned 		: std_logic_vector(8 downto 0); -- Carry var mi gormek icin
signal alu_signal       	: std_logic_vector(7 downto 0);
signal toplama_overflow     : std_logic; -- Overflow var mi gormek icin (Toplama)
signal cikarma_overflow		: std_logic; -- Overflow var mi gormek icin (Cikarma)
begin

process(ALU_Sel, A, B)
begin
	sum_unsigned <= (others => '0'); -- reset parameter
	case ALU_Sel is
		when "000" =>	-- Toplama
			alu_signal <= A + B;
			sum_unsigned <= ('0' & A) + ('0' + B);
		when "001" =>	-- Cikarma
			alu_signal <= A - B;
			sum_unsigned <= ('0' & A) + ('0' + B);
		when "010" =>	-- AND
			alu_signal <= A and B;
		when "011" =>	-- OR
			alu_signal <= A or B;
		when "100" =>	-- +1 Artir
			alu_signal <= A + x"01";
		when "101" =>	-- -1 Azalt
			alu_signal <= A - x"01";
		when others =>
			alu_signal <= (others => '0');
			sum_unsigned <= (others => '0');
			
		
			
	end case;

end process;

alu_result <= alu_signal;
-- NZVC (Negatif, Sifir, Overflow, Carry)

-- N:
NZVC(3) <= alu_signal(7);

-- Z:
NZVC(2) <= '1' when alu_signal = x"00" else '0';

-- V:
toplama_overflow <= (A(7) = '0' and B(7) = '0' and alu_signal(7) = '1') or (A(7) = '1' and B(7) = '1' and alu_signal(7) = '0');
cikarma_overflow <= (A(7) = '0' and B(7) = '1' and alu_signal(7) = '1') or (A(7) = '1' and B(7) = '0' and alu_signal(7) = '0');

NZVC(1) <= toplama_overflow when (ALU_Sel = "000") else 
		   cikarma_overflow when (ALU_Sel = "001") else '0';

-- C:
NZVC(0) <= sum_unsigned(8) when (ALU_Sel = "000") else
		   sum_unsigned(8) when (ALU_Sel = "001") else '0';
		   
end architecture;
