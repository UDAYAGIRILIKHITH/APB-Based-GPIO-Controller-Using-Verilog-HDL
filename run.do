vlib work
vlog apb_gpio.v
vlog apb_gpio_tb.v
vsim -voptargs="+acc" work.apb_gpio_tb
add wave -r *
run -all
