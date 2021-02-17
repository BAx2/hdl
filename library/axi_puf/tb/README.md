# Запуск симулятора

Необходимо определить в переменных среды тип симулятора (в терминалие или в ~/.bashrc):

## Xilinx xSim

```shell
$ export SIMULATOR=xsim
$ ./regmap_tb
$ xsim work.axi_puf_regmap_tb --gui
```

## Modelsim

```shell
$ export SIMULATOR=modelsim
$ ./regmap_tb
```

