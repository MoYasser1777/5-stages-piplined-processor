vsim -gui work.registerfile

add wave -position insertpoint  \
sim:/registerfile/clk \
sim:/registerfile/rst \
sim:/registerfile/enable \
sim:/registerfile/regWrite1 \
sim:/registerfile/regWrite2 \
sim:/registerfile/Rsrc1 \
sim:/registerfile/Rsrc2 \
sim:/registerfile/Rdst \
sim:/registerfile/RdstWrite1 \
sim:/registerfile/RdstWrite2 \
sim:/registerfile/writeBackData1 \
sim:/registerfile/writeBackData2 \
sim:/registerfile/reg0WriteData \
sim:/registerfile/reg1WriteData \
sim:/registerfile/reg2WriteData \
sim:/registerfile/reg3WriteData \
sim:/registerfile/reg4WriteData \
sim:/registerfile/reg5WriteData \
sim:/registerfile/reg6WriteData \
sim:/registerfile/reg7WriteData \
sim:/registerfile/Rsrc1Data \
sim:/registerfile/Rsrc2Data \
sim:/registerfile/RdstData \
sim:/registerfile/reg0 \
sim:/registerfile/reg1 \
sim:/registerfile/reg2 \
sim:/registerfile/reg3 \
sim:/registerfile/reg4 \
sim:/registerfile/reg5 \
sim:/registerfile/reg6 \
sim:/registerfile/reg7 \
sim:/registerfile/decoderSrc1Out \
sim:/registerfile/decoderSrc2Out \
sim:/registerfile/decoderDstOut \
sim:/registerfile/decoderDst1WriteOut \
sim:/registerfile/decoderDst2WriteOut \
sim:/registerfile/reg0WriteEnable \
sim:/registerfile/reg1WriteEnable \
sim:/registerfile/reg2WriteEnable \
sim:/registerfile/reg3WriteEnable \
sim:/registerfile/reg4WriteEnable \
sim:/registerfile/reg5WriteEnable \
sim:/registerfile/reg6WriteEnable \
sim:/registerfile/reg7WriteEnable \
sim:/registerfile/reg0ReadEnable \
sim:/registerfile/reg1ReadEnable \
sim:/registerfile/reg2ReadEnable \
sim:/registerfile/reg3ReadEnable \
sim:/registerfile/reg4ReadEnable \
sim:/registerfile/reg5ReadEnable \
sim:/registerfile/reg6ReadEnable \
sim:/registerfile/reg7ReadEnable \
sim:/registerfile/reg0Out \
sim:/registerfile/reg1Out \
sim:/registerfile/reg2Out \
sim:/registerfile/reg3Out \
sim:/registerfile/reg4Out \
sim:/registerfile/reg5Out \
sim:/registerfile/reg6Out \
sim:/registerfile/reg7Out \
sim:/registerfile/d1 \
sim:/registerfile/d2 \
sim:/registerfile/d3
force -freeze sim:/registerfile/clk 1 0, 0 {2 ps} -r 5
force -freeze sim:/registerfile/rst 0 0
force -freeze sim:/registerfile/enable 1 0
force -freeze sim:/registerfile/regWrite1 0 0
force -freeze sim:/registerfile/regWrite2 0 0
force -freeze sim:/registerfile/Rsrc1 000 0
force -freeze sim:/registerfile/Rsrc2 001 0
force -freeze sim:/registerfile/Rdst 010 0
force -freeze sim:/registerfile/RdstWrite1 111 0
force -freeze sim:/registerfile/RdstWrite2 110 0
force -freeze sim:/registerfile/writeBackData1 11110000111100001111000011110000 0
force -freeze sim:/registerfile/writeBackData2 10101010101010101010101010101010 0
run
force -freeze sim:/registerfile/regWrite1 1 0
force -freeze sim:/registerfile/RdstWrite1 000 0
force -freeze sim:/registerfile/RdstWrite2 001 0
run