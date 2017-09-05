# clock
set_property -dict {PACKAGE_PIN AC18 IOSTANDARD LVDS} [get_ports clk_p]
set_property -dict {PACKAGE_PIN AD18 IOSTANDARD LVDS} [get_ports clk_n]

# vga
set_property -dict {PACKAGE_PIN T20 IOSTANDARD LVCMOS33 SLEW FAST} [get_ports {vga_blue[0]}]
set_property -dict {PACKAGE_PIN R20 IOSTANDARD LVCMOS33 SLEW FAST} [get_ports {vga_blue[1]}]
set_property -dict {PACKAGE_PIN T22 IOSTANDARD LVCMOS33 SLEW FAST} [get_ports {vga_blue[2]}]
set_property -dict {PACKAGE_PIN T23 IOSTANDARD LVCMOS33 SLEW FAST} [get_ports {vga_blue[3]}]
set_property -dict {PACKAGE_PIN R22 IOSTANDARD LVCMOS33 SLEW FAST} [get_ports {vga_green[0]}]
set_property -dict {PACKAGE_PIN R23 IOSTANDARD LVCMOS33 SLEW FAST} [get_ports {vga_green[1]}]
set_property -dict {PACKAGE_PIN T24 IOSTANDARD LVCMOS33 SLEW FAST} [get_ports {vga_green[2]}]
set_property -dict {PACKAGE_PIN T25 IOSTANDARD LVCMOS33 SLEW FAST} [get_ports {vga_green[3]}]
set_property -dict {PACKAGE_PIN N21 IOSTANDARD LVCMOS33 SLEW FAST} [get_ports {vga_red[0]}]
set_property -dict {PACKAGE_PIN N22 IOSTANDARD LVCMOS33 SLEW FAST} [get_ports {vga_red[1]}]
set_property -dict {PACKAGE_PIN R21 IOSTANDARD LVCMOS33 SLEW FAST} [get_ports {vga_red[2]}]
set_property -dict {PACKAGE_PIN P21 IOSTANDARD LVCMOS33 SLEW FAST} [get_ports {vga_red[3]}]
set_property -dict {PACKAGE_PIN M22 IOSTANDARD LVCMOS33 SLEW FAST} [get_ports vga_h_sync]
set_property -dict {PACKAGE_PIN M21 IOSTANDARD LVCMOS33 SLEW FAST} [get_ports vga_v_sync]

## led
#set_property -dict {PACKAGE_PIN N26 IOSTANDARD LVCMOS33} [get_ports led_clk]
#set_property -dict {PACKAGE_PIN N24 IOSTANDARD LVCMOS33} [get_ports led_pen]
#set_property -dict {PACKAGE_PIN M26 IOSTANDARD LVCMOS33} [get_ports led_do]

# seg
set_property -dict {PACKAGE_PIN M24 IOSTANDARD LVCMOS33} [get_ports seg_clk]
set_property -dict {PACKAGE_PIN L24 IOSTANDARD LVCMOS33} [get_ports seg_do]
set_property -dict {PACKAGE_PIN R18 IOSTANDARD LVCMOS33} [get_ports seg_pen]

## btn
#set_property -dict {PACKAGE_PIN V17 IOSTANDARD LVCMOS18} [get_ports {btn_x[0]}]
#set_property -dict {PACKAGE_PIN W18 IOSTANDARD LVCMOS18} [get_ports {btn_x[1]}]
#set_property -dict {PACKAGE_PIN W19 IOSTANDARD LVCMOS18} [get_ports {btn_x[2]}]
#set_property -dict {PACKAGE_PIN W15 IOSTANDARD LVCMOS18} [get_ports {btn_x[3]}]
#set_property -dict {PACKAGE_PIN W16 IOSTANDARD LVCMOS18} [get_ports {btn_x[4]}]
#set_property -dict {PACKAGE_PIN V18 IOSTANDARD LVCMOS18} [get_ports {btn_y[0]}]
#set_property -dict {PACKAGE_PIN V19 IOSTANDARD LVCMOS18} [get_ports {btn_y[1]}]
#set_property -dict {PACKAGE_PIN V14 IOSTANDARD LVCMOS18} [get_ports {btn_y[2]}]
#set_property -dict {PACKAGE_PIN W14 IOSTANDARD LVCMOS18} [get_ports {btn_y[3]}]
#set_property -dict {PACKAGE_PIN V16 IOSTANDARD LVCMOS18} [get_ports {btn_y[4]}]

## switch
#set_property -dict {PACKAGE_PIN AA10 IOSTANDARD LVCMOS15} [get_ports {switch[0]}]
#set_property -dict {PACKAGE_PIN AB10 IOSTANDARD LVCMOS15} [get_ports {switch[1]}]
#set_property -dict {PACKAGE_PIN AA13 IOSTANDARD LVCMOS15} [get_ports {switch[2]}]
#set_property -dict {PACKAGE_PIN AA12 IOSTANDARD LVCMOS15} [get_ports {switch[3]}]
#set_property -dict {PACKAGE_PIN Y13 IOSTANDARD LVCMOS15} [get_ports {switch[4]}]
#set_property -dict {PACKAGE_PIN Y12 IOSTANDARD LVCMOS15} [get_ports {switch[5]}]
#set_property -dict {PACKAGE_PIN AD11 IOSTANDARD LVCMOS15} [get_ports {switch[6]}]
#set_property -dict {PACKAGE_PIN AD10 IOSTANDARD LVCMOS15} [get_ports {switch[7]}]
#set_property -dict {PACKAGE_PIN AE10 IOSTANDARD LVCMOS15} [get_ports {switch[8]}]
#set_property -dict {PACKAGE_PIN AE12 IOSTANDARD LVCMOS15} [get_ports {switch[9]}]
#set_property -dict {PACKAGE_PIN AF12 IOSTANDARD LVCMOS15} [get_ports {switch[10]}]
#set_property -dict {PACKAGE_PIN AE8 IOSTANDARD LVCMOS15} [get_ports {switch[11]}]
#set_property -dict {PACKAGE_PIN AF8 IOSTANDARD LVCMOS15} [get_ports {switch[12]}]
#set_property -dict {PACKAGE_PIN AE13 IOSTANDARD LVCMOS15} [get_ports {switch[13]}]
#set_property -dict {PACKAGE_PIN AF13 IOSTANDARD LVCMOS15} [get_ports {switch[14]}]
#set_property -dict {PACKAGE_PIN AF10 IOSTANDARD LVCMOS15} [get_ports {switch[15]}]